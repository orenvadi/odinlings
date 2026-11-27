package odinlings

import "core:fmt"

/*
 * structure of arrays (#soa)
 *
 * a normal array of structs, []Particle in Go or odin, keeps each struct together:
 *     x y alive | x y alive | x y alive | ...
 *
 * when a hot loop only reads 'x', the cpu still has to load y and alive too
 * a structure of arrays keeps each field in its own array instead:
 *     x x x x ... | y y y y ... | alive alive alive ...
 *
 * in Go you would have to rewrite your struct by hand to get this
 * in odin you just add #soa to the array type, and keep writing particles[i].x
 *
 *     particles: #soa[100]Particle
 *     particles.x    -> all the x values, as their own array
 *
 * there are also #soa[]T slices and #soa[dynamic]T dynamic arrays
*/


Particle :: struct {
    x, y:  f32,
    alive: bool,
}


main :: proc() {

    particles: #soa[4]Particle

    particles[0] = {1, 1, true}
    particles[1] = {2, 2, false}
    particles[2] = {3, 3, true}
    particles[3] = {4, 4, true}

    //you can use it just like a normal array
    for &p in particles {
        if p.alive do p.y -= 1
    }
    assert(particles[1].y == 2)
    assert(particles[2].y == 2)


    //but you can also get one field for every particle at once
    xs := particles.x
    total: f32
    for x in xs {
        total += x
    }
    assert(total == 10)


    //a dynamic soa array grows with append, just like [dynamic]T
    more: #soa[dynamic]Particle
    defer delete(more)
    append(&more, Particle{5, 5, true})
    append(&more, Particle{6, 6, false})
    assert(len(more) == 2)
    assert(more[1].x == 6)

    fmt.println(particles)
}
