package odinlings

import "core:fmt"

/*
 * bit fields
 *
 * sometimes data is packed into single bits, for example in file formats,
 * network packets or colors
 * in Go you would write the masks and shifts by hand:
 *     r := (c >> 11) & 0x1f
 *
 * odin can describe the layout with a bit_field, and you use it like a struct
 *
 *     Color565 :: bit_field u16 {
 *         b: u8 | 5,    -> 5 bits, read and written as a u8
 *         g: u8 | 6,
 *         r: u8 | 5,
 *     }
 *
 * the first field uses the lowest bits
 * the sizes must add up to at most the size of the backing type (u16 = 16 bits)
*/


Color565 :: bit_field u16 {
    b: u8 | 5,
    g: u8 | 7,
    r: u8 | 5,
}


Packet_Kind :: enum u8 {
    Ping,
    Data,
    Ack,
}

Packet_Header :: bit_field u8 {
    version: u8          | 2,
    kind:    Packet_Kind | 3,
    urgent:  bool        | 1,
    _:       u8          | 2, //unused bits
}


main :: proc() {

    red: Color565
    red.r = 31 //the biggest number that fits in 5 bits
    fmt.printf("red is %16b\n", transmute(u16)red)
    assert(transmute(u16)red == 0b11111_000000_00000)

    white := Color565 {
        r = 31,
        g = 63,
        b = 31,
    }
    assert(transmute(u16)white == 0xffff)


    header := Packet_Header {
        version = 1,
        kind    = .Ack,
        urgent  = true,
    }
    assert(header.kind == .Ack)
    assert(size_of(header) == 1)

    //version is in bits 0-1, kind in bits 2-4, urgent in bit 5
    assert(transmute(u8)header == 0b????_????)

    fmt.println(header)
}
