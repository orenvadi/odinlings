package odinlings

import "base:intrinsics"
import "core:fmt"

/*
 * parametric polymorphism (generics) in procedures
 *
 * Go:   func Contains[T comparable](list []T, x T) bool
 * odin: contains :: proc(list: []$T, x: T) -> bool
 *
 * the '$' marks the place where T is declared, the compiler works T out from
 * the argument, later uses of T do not need a '$'
 *
 * odin can do a few things Go generics can't:
 *   - be generic over a compile time VALUE, not only a type: [$N]T is an array of any length
 *   - take a type as a normal argument with $T: typeid, like make([]int, 3) does
 *   - check any compile time condition with a 'where' clause
 *     (intrinsics.type_is_numeric(T), N > 0, ...)
*/


contains :: proc(list: []$T, x: T) -> bool {
    for item in list {
        if item == x do return true
    }
    return false
}


//N and T are both worked out from the array that is passed in
sum :: proc(arr: [$N]$T) -> T where intrinsics.type_is_numeric(T) {
    total: T
    for x in arr {
        total += x
    }
    return total
}


//here N is passed explicitly, and it decides the size of the returned array
filled :: proc($N: int, value: $T) -> [N]T where N > 0 {
    result: [N]T
    for &x in result {
        x = value
    }
    return result
}


//a type can be passed like any other argument
biggest_value :: proc($T: typeid) -> T where intrinsics.type_is_integer(T) {
    return max(T)
}


main :: proc() {

    assert(contains([]string{"go", "odin", "c"}, "odin"))
    assert(!contains([]int{1, 2, 3}, 4))


    ints := [4]int{1, 2, 3, 4}
    floats := [3]f32{0.5, 0.25, 0.25}

    assert(sum(ints) == 10)
    assert(sum(floats) == 1)


    three_hellos := filled(3, "hello")
    assert(len(three_hellos) == 3)
    fmt.println(three_hellos)


    assert(biggest_value(u8) == 255)
    assert(biggest_value(i16) == 32767)
}
