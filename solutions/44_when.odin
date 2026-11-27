package odinlings

import "core:fmt"

/*
 * compile time code: when, #assert and #config
 *
 * Go chooses code per platform with build tags and separate files:
 *     //go:build windows
 *
 * odin has 'when', an if statement that runs at compile time
 * the branch that is not taken is thrown away and NOT type checked,
 * so it may even call procedures that don't exist on this platform
 *
 *     when ODIN_OS == .Windows {
 *         ...
 *     } else {
 *         ...
 *     }
 *
 * useful built in constants: ODIN_OS, ODIN_ARCH, ODIN_DEBUG, ODIN_ENDIAN
 *
 * #assert(condition) fails the BUILD (not the program) if it is false
 *
 * #config(NAME, default) reads a value given on the command line:
 *     odin run . -define:VERBOSE=true
*/


VERBOSE :: #config(VERBOSE, false)


//buffers are processed in chunks of 64 bytes, so the size must be a multiple of 64
BUFFER_SIZE :: 1024
#assert(BUFFER_SIZE % 64 == 0, "BUFFER_SIZE must be a multiple of 64")


Header :: struct {
    id:    u32,
    flags: u16,
    kind:  u8,
}
//the struct has a padding byte at the end, so it is 8 bytes
#assert(size_of(Header) == 8)


when ODIN_OS == .Windows {
    NEWLINE :: "\r\n"
} else {
    NEWLINE :: "\n"
}


main :: proc() {

    fmt.print("hello from", ODIN_OS, "on", ODIN_ARCH, NEWLINE)

    when VERBOSE {
        fmt.println("verbose mode is on")
    }

    //this procedure only exists when compiling for the web (JS), a normal 'if' would still type check it
    when ODIN_OS == .JS {
        browser_only_procedure()
    }

    //constants are compile time values, so this array size is fine
    buffer: [BUFFER_SIZE]u8
    fmt.println("buffer has", len(buffer), "bytes")
}
