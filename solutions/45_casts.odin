package odinlings

import "core:fmt"

/*
 * cast, transmute, auto_cast and ---
 *
 * Go has one kind of conversion, T(x), and needs 'unsafe' or math.Float32bits
 * to look at the raw bits of a value
 *
 * odin has three:
 *     T(x) or cast(T)x   -> convert the VALUE: f32(3.9) -> int gives 3
 *     transmute(T)x      -> keep the same BITS and read them as another type,
 *                           both types must have the same size
 *     auto_cast x        -> convert to whatever type is needed right there
 *                           handy, but it hides what is going on, use it rarely
 *
 * odin zeroes every variable like Go does, but you can opt out with ---
 *     buffer: [4096]u8 = ---    -> the memory is left as it is, faster but random
*/


takes_f64 :: proc(x: f64) -> f64 {
    return x * 2
}


main :: proc() {

    f: f32 = 3.9
    i := int(f)
    assert(i == 3)


    //the bits of the float 1.0 are 0x3f80_0000
    one: f32 = 1.0
    bits := transmute(u32)one
    assert(bits == 0x3f80_0000)
    fmt.printf("1.0 as bits: %32b\n", bits)


    //transmute works for any types of the same size, here 4 bytes
    bytes := transmute([4]u8)bits
    //most computers are little endian: the lowest byte comes first
    assert(bytes[3] == 0x3f)


    count := 21
    assert(takes_f64(auto_cast count) == 42)


    scratch: [256]u8 = ---
    scratch[0] = 1 //only use the parts you have written to!
    fmt.println(scratch[0])
}
