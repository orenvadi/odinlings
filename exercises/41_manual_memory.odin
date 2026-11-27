package odinlings

import "core:fmt"
import "core:mem"

/*
 * manual memory
 *
 * Go has a garbage collector, odin does NOT
 * anything you allocate you must give back yourself
 *
 *   new(T)              -> ^T on the heap         give it back with free(ptr)
 *   make([]T, n)        -> a slice on the heap    give it back with delete(s)
 *   [dynamic]T          -> like a Go slice that grows with append(&arr, x)
 *                          give it back with delete(arr)
 *   map[K]V             -> like a Go map          give it back with delete(m)
 *
 * notice that append takes a POINTER to the dynamic array: append(&arr, x)
 * in Go append returns a new slice, in odin it changes the array in place
 *
 * the usual pattern is to put the cleanup right after the allocation with defer:
 *     nums := make([dynamic]int)
 *     defer delete(nums)
 *
 * this exercise uses a "tracking allocator" that remembers every allocation,
 * at the end it reports everything you forgot to free and crashes
 * the next exercise explains how it works, for now just fix the leaks!
*/


main :: proc() {

    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
    defer check_leaks(&track)


    //1. new and free
    score := new(int)
    score^ = 42
    assert(score^ == 42)


    //2. dynamic arrays
    nums: [dynamic]int
    append(&nums, 1, 2, 3)
    append(&nums, ..[]int{4, 5})
    assert(len(nums) == 5)
    pop(&nums)
    assert(len(nums) == 4)


    //3. maps
    ages := make(map[string]int)
    ages["alice"] = 30
    ages["bob"] = 25
    delete_key(&ages, "bob")

    _, has_bob := ages["bob"]
    assert(!has_bob)
    assert(len(ages) == 1)


    //4. slices made with make
    buffer := make([]u8, 64)
    defer delete(buffer)
    buffer[0] = 'A'


    fmt.println("nums:", nums, "ages:", ages)
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
