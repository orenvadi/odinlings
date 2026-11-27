package odinlings

import "core:fmt"

/*
 * defer
 *
 * you already know defer from Go, but odin's defer has different rules!
 *
 *   Go:   a deferred call runs when the surrounding FUNCTION returns
 *   odin: a deferred statement runs when the surrounding SCOPE ends,
 *         a scope is any { ... } block: an if, a for loop body, or a bare block
 *
 * the order is the same as in Go: last in, first out
 *
 * odin can defer any statement, not only a procedure call:
 *     defer x += 1
 *     defer if ok do cleanup()
 *     defer { a(); b() }
 *
 * and unlike Go, the deferred statement is NOT evaluated when 'defer' is
 * reached, it is evaluated when it actually runs at the end of the scope
*/


events: [8]string
event_count: int

push_event :: proc(event: string) {
    events[event_count] = event
    event_count += 1
}


main :: proc() {

    push_event("start")
    {
        defer push_event("block end")
        push_event("in block")
    }
    push_event("after block")

    //a Go programmer would expect "block end" to happen at the very end of main...
    //fix the expected order of events
    expected := [4]string{"start", "in block", "block end", "after block"}
    for event, i in expected {
        assert(events[i] == event)
    }


    x := 10
    {
        defer x *= 2 //this runs when the block ends, after 'x += 5'
        x += 5
    }
    assert(x == 30)


    //in Go a defer inside a loop runs when the function returns (a classic Go bug!)
    //in odin it runs at the end of each iteration
    open_files := 0
    for i in 0 ..< 3 {
        open_files += 1
        defer open_files -= 1

        assert(open_files == 1)
    }
    assert(open_files == 0)


    y := 1
    {
        //in Go this would print 1, because the arguments are evaluated immediately
        defer fmt.println("y at the end of the scope:", y)
        y = 100
    }


    //defers run in reverse order
    defer fmt.println("printed last")
    defer fmt.println("printed second")
    fmt.println("printed first")
}
