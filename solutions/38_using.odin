package odinlings

import "core:fmt"

/*
 * using
 *
 * Go has struct embedding:
 *     type Player struct { Entity; Score int }
 *     player.X   // works, X comes from the embedded Entity
 *
 * odin does the same with 'using' on a struct field:
 *     Player :: struct { using entity: Entity, score: int }
 *     player.x   // works
 *
 * but odin goes a bit further than Go:
 *   a ^Player can be passed where a ^Entity is expected,
 *   in Go you would have to write &player.Entity yourself
 *
 * you can still reach the embedded struct by its name: player.entity
 *
 * (older odin code also uses 'using' on procedure parameters and as a statement,
 *  that is now turned off by default because it makes code hard to read,
 *  so only use it on struct fields)
*/


Entity :: struct {
    name: string,
    x, y: int,
}

Player :: struct {
    using entity: Entity,
    score:        int,
}


move :: proc(e: ^Entity, dx, dy: int) {
    e.x += dx
    e.y += dy
}


describe :: proc(e: Entity) {
    fmt.printf("%s is at (%d, %d)\n", e.name, e.x, e.y)
}


main :: proc() {

    player := Player {
        name  = "hero",
        score = 0,
    }

    player.x = 5
    player.y = 5

    //the ^Player is accepted as a ^Entity because of 'using'
    move(&player, 1, -2)
    assert(player.x == 6)
    assert(player.y == 3)

    //the embedded struct can still be reached by its field name
    describe(player.entity)

    //using works for several levels of nesting
    Boss :: struct {
        using player: Player,
        rage:         int,
    }
    boss: Boss
    boss.name = "dragon"
    boss.score = 1000
    move(&boss, 10, 10)
    assert(boss.x == 10)
    describe(boss.entity)
}
