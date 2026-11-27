package odinlings

import "core:fmt"
import "core:mem"

/*
 * the context and allocators
 *
 * every odin procedure gets a hidden parameter called 'context'
 * Go also has a context.Context, but you pass it by hand and it is mostly
 * for cancellation, odin's context is passed for you and holds things like:
 *     context.allocator       -> where make, new, append, ... get memory from
 *     context.temp_allocator  -> a fast scratch allocator for short lived data
 *     context.logger          -> used by core:log
 *     context.user_ptr / user_index -> your own data
 *
 * if you change the context inside a procedure, the change is seen by the
 * procedures it calls, but NOT by its caller, the change ends with the scope
 *
 * allocators are values, so you can swap them, this is how the tracking
 * allocator from the last exercise works: it wraps the normal allocator
 * and records every allocation and free
 *
 * the temp allocator is an arena: you never free single things from it,
 * you call free_all(context.temp_allocator) once, for example at the end
 * of every frame of a game or every request of a server
 *
 * procedures that allocate usually take an allocator parameter
 * that defaults to context.allocator, so the caller can choose
*/


build_greeting :: proc(name: string, allocator := context.allocator) -> string {
    //aprintf allocates a new string with the given allocator
    return fmt.aprintf("hello, %s!", name, allocator = allocator)
}


get_user_index :: proc() -> int {
    return context.user_index
}

call_with_index :: proc(index: int) -> int {
    context.user_index = index
    return get_user_index() //sees the new value
}


main :: proc() {

    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
    defer check_leaks(&track)


    //here we replace the temp allocator with our own small arena of 256 bytes on the stack,
    //so we can see how much of it is used
    scratch: [256]u8
    arena: mem.Arena
    mem.arena_init(&arena, scratch[:])
    context.temp_allocator = mem.arena_allocator(&arena)


    //1. a long running loop, like the frames of a game
    //   each greeting is only needed during one iteration,
    //   so use the temp allocator for it and clear the temp allocator every iteration
    names := [?]string{"alice", "bob", "carol"}
    for frame in 0 ..< 100 {
        greeting := build_greeting(names[frame % len(names)], context.temp_allocator)
        if frame < 3 do fmt.println(greeting)

        free_all(context.temp_allocator)
    }
    assert(arena.offset == 0, "the temp allocator was not cleared")


    //2. a greeting that we keep, so it uses the normal allocator and must be deleted
    kept := build_greeting("odin")
    defer delete(kept)
    assert(kept == "hello, odin!")


    //3. context changes are scoped
    assert(call_with_index(7) == 7)
    assert(context.user_index == 0)
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
