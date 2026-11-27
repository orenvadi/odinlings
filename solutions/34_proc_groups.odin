package odinlings

import "core:fmt"
import "core:math"

/*
 * procedure groups (overloading)
 *
 * Go has no function overloading, so you end up with names like
 * AreaCircle, AreaRect, AreaTriangle, or an interface with an Area() method
 *
 * odin lets you group procedures under one name:
 *     area :: proc{area_circle, area_rect}
 *
 * when you call area(x) the compiler picks the procedure whose
 * parameters match the arguments, at compile time
 *
 * you already used groups without noticing: make, delete and len
 * work on many types
*/


Circle :: struct {
    radius: f32,
}

Rect :: struct {
    width, height: f32,
}

Triangle :: struct {
    base, height: f32,
}


area_circle :: proc(c: Circle) -> f32 {
    return math.PI * c.radius * c.radius
}

area_rect :: proc(r: Rect) -> f32 {
    return r.width * r.height
}

area_triangle :: proc(t: Triangle) -> f32 {
    return t.base * t.height / 2
}

area :: proc {
    area_circle,
    area_rect,
    area_triangle,
}


//groups can also pick by number of arguments
describe_one :: proc(name: string) {
    fmt.println("this is", name)
}

describe_two :: proc(name: string, count: int) {
    fmt.println("there are", count, name)
}

describe :: proc {
    describe_one,
    describe_two,
}


main :: proc() {

    fmt.println(area(Circle{1}))
    fmt.println(area(Rect{2, 3}))
    fmt.println(area(Triangle{4, 5}))

    assert(area(Rect{2, 3}) == 6)
    assert(area(Triangle{4, 5}) == 10)

    describe("a cat")
    describe("cats", 3)
}
