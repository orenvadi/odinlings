package odinlings

import "core:fmt"

/*
 * array programming and swizzling
 *
 * you saw in the arrays exercise that arrays support math: a * b
 * this is very useful for small vectors in games and graphics
 * Go has nothing like it, you would write a Vec3 struct and methods by hand
 *
 * arrays of length 1 to 4 also get special field names:
 *     x, y, z, w   or   r, g, b, a
 *
 * you can combine those names to make a new array, this is called swizzling:
 *     v.xy   -> [2]T{v.x, v.y}
 *     v.zyx  -> [3]T{v.z, v.y, v.x}
 *     v.xxx  -> [3]T{v.x, v.x, v.x}
 *
 * and a scalar can be mixed with an array, it applies to every element:
 *     v * 2  -> {v.x * 2, v.y * 2, v.z * 2}
*/


Vec2 :: [2]f32
Vec3 :: [3]f32
Color :: [4]f32


main :: proc() {

    position := Vec3{1, 2, 3}
    velocity := Vec3{0.5, 0, -1}

    //move for 2 seconds
    position += velocity * 2
    assert(position == Vec3{2, 2, 1})


    //the shadow of the object on the ground only has x and z
    shadow: Vec2 = position.xz
    assert(shadow == Vec2{2, 1})


    //reverse the vector
    reversed := Vec3{3, 2, 1}.zyx
    assert(reversed == Vec3{1, 2, 3})


    //colors use r, g, b, a
    red := Color{1, 0, 0, 1}
    half_red := red.rgb * 0.5
    assert(half_red == Vec3{0.5, 0, 0})

    //you can also assign to a single component
    red.a = 0.25
    fmt.println(red)


    //dot product: multiply element by element, then add everything up
    a := Vec3{1, 2, 3}
    b := Vec3{4, 5, 6}
    product := a * b
    dot := product.x + product.y + product.z
    assert(dot == 32)
}
