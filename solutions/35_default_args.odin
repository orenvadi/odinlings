package odinlings

import "core:fmt"

/*
 * default values and named arguments
 *
 * Go has neither, so people use option structs or "functional options"
 *
 * in odin a parameter can have a default value:
 *     spawn :: proc(name: string, health := 100, speed: f32 = 1.5)
 *
 * and any argument can be passed by name, in any order:
 *     spawn("bat", speed = 3)
 *     spawn(speed = 3, name = "bat")
 *
 * the one rule: after you pass an argument by name,
 * all the arguments after it must be named too
*/


Monster :: struct {
    name:    string,
    health:  int,
    speed:   f32,
    hostile: bool,
}


spawn :: proc(name: string, health := 100, speed: f32 = 1.5, hostile := false) -> Monster {
    return Monster{name, health, speed, hostile}
}


main :: proc() {

    slime := spawn("slime")
    assert(slime.health == 100)
    assert(slime.speed == 1.5)

    bat := spawn("bat", speed = 3)
    assert(bat.health == 100)
    assert(bat.speed == 3)

    dragon := spawn(hostile = true, name = "dragon", health = 1000)
    assert(dragon.hostile)

    //a goblin is hostile and has 50 health
    goblin := spawn("goblin", health = 50, hostile = true)
    assert(goblin.health == 50)
    assert(goblin.hostile)

    //structs work in a similar way: fields you don't name are zero
    rabbit := Monster {
        name  = "rabbit",
        speed = 4,
    }
    assert(rabbit.health == 0)

    fmt.println(slime, bat, dragon, goblin, rabbit, sep = "\n")
}
