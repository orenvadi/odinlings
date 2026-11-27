package odinlings

import "core:fmt"
import "core:mem"

//quiz two - find the bugs
//this time there are three of them


Item_Kind :: enum {
    Sword,
    Shield,
    Potion,
}

Tag :: enum {
    Magic,
    Cursed,
    Heavy,
}

Item :: struct {
    name:   string,
    kind:   Item_Kind,
    tags:   bit_set[Tag],
    weight: int,
}

Inventory_Error :: enum {
    None,
    Too_Heavy,
    Cursed,
}

//the total weight may be exactly MAX_WEIGHT
MAX_WEIGHT :: 20

Inventory :: struct {
    items:  [dynamic]Item,
    weight: int,
}


add_item :: proc(inv: ^Inventory, item: Item) -> Inventory_Error {
    if .Cursed in item.tags do return .Cursed
    if inv.weight + item.weight >= MAX_WEIGHT do return .Too_Heavy

    append(&inv.items, item)
    inv.weight += item.weight
    return .None
}


//adds items until one fails, 'added' is how many were really added
add_all :: proc(inv: ^Inventory, items: ..Item) -> (added: int, err: Inventory_Error) {
    for item in items {
        added += 1
        add_item(inv, item) or_return
    }
    return
}


count_by_kind :: proc(inv: Inventory) -> (counts: [Item_Kind]int) {
    for item in inv.items {
        counts[item.kind] += 1
    }
    return
}


destroy_inventory :: proc(inv: ^Inventory) {
    delete(inv.items)
}


main :: proc() {

    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
    defer check_leaks(&track)


    inv: Inventory

    added, err := add_all(
        &inv,
        Item{"rusty sword", .Sword, {}, 5},
        Item{"magic shield", .Shield, {.Magic}, 10},
        Item{"health potion", .Potion, {}, 1},
        Item{"red potion", .Potion, {.Magic}, 4},
        Item{"anvil", .Shield, {.Heavy}, 50},
    )
    assert(err == .Too_Heavy)
    assert(added == 4)
    assert(inv.weight == 20)

    _, err = add_all(&inv, Item{"cursed ring", .Potion, {.Cursed, .Magic}, 0})
    assert(err == .Cursed)

    counts := count_by_kind(inv)
    assert(counts[.Potion] == 2)

    fmt.println("inventory:", counts, "weight:", inv.weight)
}


check_leaks :: proc(track: ^mem.Tracking_Allocator) {
    for _, leak in track.allocation_map {
        fmt.printf("LEAK: %v bytes allocated at %v\n", leak.size, leak.location)
    }
    leak_count := len(track.allocation_map)
    mem.tracking_allocator_destroy(track)

    assert(leak_count == 0, "you have memory leaks!")
    fmt.println("no leaks, well done!")
}
