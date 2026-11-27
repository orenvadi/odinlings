package odinlings

import "core:fmt"

/*
 * enumerated arrays
 *
 * in Go you would use a map[Direction]string or a [4]string together with iota constants
 * odin can index a fixed array directly with an enum: [Enum_Type]Element_Type
 *
 * the array has exactly one element for each enum value, so it never needs a hash map
 * and the compiler knows its size
 *
 *     names := [Direction]string{
 *         .North = "north",
 *         ...
 *     }
 *     names[.North]
 *
 * a literal must list every enum value, or be marked '#partial' to leave some at zero
*/


Direction :: enum {
    North,
    East,
    South,
    West,
}

names := [Direction]string {
    .North = "north",
    .East  = "east",
    .South = "south",
    .West  = "west",
}

opposite := [Direction]Direction {
    .North = .South,
    .East  = .West,
    .South = .North,
    .West  = .East,
}


//turning right goes North -> East -> South -> West -> North
//len(Direction) is the number of values in the enum
turn_right :: proc(d: Direction) -> Direction {
    return Direction((int(d) + 1) % len(Direction))
}


main :: proc() {

    //iterating gives the element and the enum value as the 'index'
    for name, dir in names {
        fmt.println(dir, "is called", name, "and its opposite is", names[opposite[dir]])
    }

    assert(opposite[.West] == .East)

    assert(turn_right(.North) == .East)
    assert(turn_right(.West) == .North)


    //enumerated arrays are great for counting things
    steps := [?]Direction{.North, .North, .East, .South, .North, .West}

    counts: [Direction]int
    for step in steps {
        counts[step] += 1
    }

    assert(counts[.North] == 3)
    fmt.println(counts)
}
