package odinlings

import "core:fmt"

/*
 * Maybe and nil-less unions
 *
 * in Go "there may be no value" is written with a nil pointer or a (value, ok) pair
 * odin has Maybe(T), which is just a union with one variant: union{T}
 * so it is either a T, or nil
 *
 *     m: Maybe(int) = 5
 *     x, ok := m.?          -> unwrap with an ok bool
 *     x := m.? or_else -1   -> unwrap with a default
 *     x := m.?              -> unwrap, crash if it is nil
 *
 * '.?' works on any union with a single variant
 *
 * normal unions start out as nil (no variant)
 * a union marked '#no_nil' can never be nil, its zero value is its first variant
*/


find_index :: proc(list: []string, target: string) -> Maybe(int) {
    for item, i in list {
        if item == target do return i
    }
    return nil
}


Circle :: struct {
    radius: f32,
}

Square :: struct {
    side: f32,
}

Shape :: union #no_nil {
    Circle,
    Square,
}


main :: proc() {

    names := []string{"alice", "bob", "carol"}

    //a Maybe(int) is not an int, you have to unwrap it first
    carol := find_index(names, "carol").? + 1
    assert(carol == 3)

    if i, ok := find_index(names, "bob").?; ok {
        fmt.println("found bob at", i)
    }

    //zed is not in the list, use -1 instead
    zed := find_index(names, "zed").? or_else -1
    assert(zed == -1)


    //a fresh shape should be a circle, not nil
    s: Shape
    _, is_circle := s.(Circle)
    assert(is_circle)

    s = Square{2}
    switch v in s {
    case Circle:
        fmt.println("circle", v.radius)
    case Square:
        fmt.println("square", v.side)
    }
}
