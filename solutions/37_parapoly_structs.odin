package odinlings

import "core:fmt"

/*
 * parametric polymorphism in structs
 *
 * Go:   type Stack[T any] struct { items []T }
 * odin: Stack :: struct($T: typeid) { ... }
 *
 * just like procedures, odin structs can also take compile time values,
 * so this stack has a fixed capacity that is part of its type:
 *     Stack :: struct($T: typeid, $N: int) { items: [N]T, count: int }
 *
 *     s: Stack(int, 8)      -> a stack of at most 8 ints, no heap allocation
 *
 * procedures that work on any stack write the parameters with '$' again:
 *     push :: proc(s: ^Stack($T, $N), item: T)
*/


Stack :: struct($T: typeid, $N: int) {
    items: [N]T,
    count: int,
}


push :: proc(s: ^Stack($T, $N), item: T) -> (ok: bool) {
    if s.count >= N do return false

    s.items[s.count] = item
    s.count += 1
    return true
}


pop :: proc(s: ^Stack($T, $N)) -> (item: T, ok: bool) {
    if s.count == 0 do return

    s.count -= 1
    item = s.items[s.count]
    return item, true
}


//a generic pair, both fields can have different types
Pair :: struct($A, $B: typeid) {
    first:  A,
    second: B,
}


main :: proc() {

    numbers: Stack(int, 3)

    assert(push(&numbers, 1))
    assert(push(&numbers, 2))
    assert(push(&numbers, 3))
    assert(!push(&numbers, 4)) //the stack is full

    top, ok := pop(&numbers)
    assert(ok && top == 3)

    top, ok = pop(&numbers)
    assert(ok && top == 2)


    words: Stack(string, 2)
    push(&words, "hello")
    word, _ := pop(&words)
    assert(word == "hello")

    _, ok = pop(&words)
    assert(!ok) //empty now


    p := Pair(string, int){"answer", 42}
    fmt.println(p.first, "=", p.second)
}
