package odinlings

import "core:fmt"

/*
 * or_return and or_else
 *
 * in odin errors are ordinary values, usually an enum or a union, and they
 * are returned as the last result, just like in Go
 *
 * but odin has small operators so you don't write 'if err != nil' every time
 *
 *   Go:
 *       n, err := parse(s)
 *       if err != nil {
 *           return 0, err
 *       }
 *
 *   odin:
 *       n := parse(s) or_return
 *
 * or_return: if the last value is an error (not zero / not nil / false),
 * return from the current procedure with that error, otherwise give back the other values
 * the procedure using or_return must have named results, or a single result
 *
 * or_else: if there is an error, use this value instead
 *       port := parse(s) or_else 8080
 *
 * (there are also or_break and or_continue for loops)
*/


Parse_Error :: enum {
    None,
    Empty,
    Not_A_Digit,
}


parse_digit :: proc(c: u8) -> (int, Parse_Error) {
    if c < '0' || c > '9' do return 0, .Not_A_Digit
    return int(c - '0'), .None
}


parse_number :: proc(s: string) -> (n: int, err: Parse_Error) {
    if len(s) == 0 do return 0, .Empty

    for i in 0 ..< len(s) {
        digit := parse_digit(s[i]) or_return
        n = n * 10 + digit
    }
    return
}


sum_numbers :: proc(a, b: string) -> (total: int, err: Parse_Error) {
    x, _ := parse_number(a)
    y, _ := parse_number(b)
    return x + y, .None
}


main :: proc() {

    total, err := sum_numbers("12", "30")
    assert(err == .None)
    assert(total == 42)

    //the error from parse_digit should go all the way up
    _, err = sum_numbers("12", "4x")
    assert(err == .Not_A_Digit)

    _, err = sum_numbers("", "1")
    assert(err == .Empty)


    //an empty port setting should fall back to 8080
    port, _ := parse_number("")
    assert(port == 8080)


    //or_else also works with anything that returns an 'ok' bool, like a union type assertion
    Value :: union {
        int,
        string,
    }
    v: Value = "not a number"
    number := v.(int) or_else -1
    assert(number == -1)

    fmt.println("everything parsed!")
}
