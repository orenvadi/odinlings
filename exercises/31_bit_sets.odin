package odinlings

import "core:fmt"

/*
 * bit sets
 *
 * in Go, flags are usually written by hand:
 *     const (
 *         Read = 1 << iota
 *         Write
 *         Execute
 *     )
 *     perms := Read | Write
 *     if perms & Write != 0 { ... }
 *
 * odin has a built in set type that stores one bit per enum value: bit_set[Enum]
 *
 *     perms: bit_set[Permission] = {.Read, .Write}
 *     .Write in perms        -> is the element in the set?
 *     .Write not_in perms    -> is it not in the set?
 *     a + b                  -> union
 *     a - b                  -> difference
 *     a & b                  -> intersection
 *     a <= b                 -> is a a subset of b?
 *     card(a)                -> how many elements are in the set
*/


Permission :: enum {
    Read,
    Write,
    Execute,
}

Permissions :: bit_set[Permission]


can_run :: proc(p: Permissions) -> bool {
    return .Read in p && .Execute in p
}


main :: proc() {

    admin := Permissions{.Read, .Write, .Execute}
    guest := Permissions{.Read}

    assert(.Write in admin)
    assert(.Write not_in guest)
    assert(card(admin) == 3)


    //an editor can do everything an admin can, except run programs
    editor := admin
    editor += {.Execute}

    assert(!can_run(editor))
    assert(.Write in editor)


    //intersection: what can BOTH the editor and the guest do?
    shared := editor & guest
    assert(shared == Permissions{???})

    //guest permissions are a subset of the editor's
    assert(guest <= editor)


    //bit sets also work with ranges of numbers, here a set of days in a month
    busy_days: bit_set[1 ..= 31]
    busy_days += {1, 15, 30}
    assert(15 in busy_days)

    //a bit_set is tiny, it is just bits in an integer
    fmt.println("size of Permissions in bytes:", size_of(Permissions))
    fmt.println("size of busy_days in bytes:", size_of(busy_days))
    fmt.println(admin, editor, guest)
}
