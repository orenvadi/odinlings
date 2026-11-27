package odinlings

import "core:fmt"

/*
 * distinct types
 *
 * in Go:
 *     type Celsius float64     -> a NEW type, you must convert to mix it with float64
 *     type Celsius = float64   -> an alias, Celsius IS float64
 *
 * in odin it is the other way around:
 *     Celsius :: f64           -> an alias, Celsius IS f64
 *     Celsius :: distinct f64  -> a NEW type, you must convert to mix it with f64
 *
 * so if you want the compiler to catch unit mix-ups you need 'distinct'
*/


Meters :: f64
Feet :: f64

//'#assert' checks something at compile time, you will see more of it later
//right now this fails because Meters and Feet are the same type
#assert(Meters != Feet)


feet_to_meters :: proc(f: Feet) -> Meters {
    return Meters(f * 0.3048)
}

add_distances :: proc(a, b: Meters) -> Meters {
    return a + b
}


main :: proc() {

    jump: Feet = 6
    walk: Meters = 2

    //this compiles while Meters and Feet are aliases, but it's a bug!
    //once both types are distinct the compiler will complain,
    //fix it by converting the feet to meters
    total := add_distances(jump, walk)

    fmt.println("total distance in meters:", total)
    assert(total > 3.8 && total < 3.9)


    //distinct works for any type, not just numbers
    User_Id :: distinct int
    Order_Id :: distinct int

    user: User_Id = 7
    order: Order_Id = 7

    //user == order would not compile, the types are different
    //you can still convert explicitly if you really mean it
    assert(int(user) == int(order))
}
