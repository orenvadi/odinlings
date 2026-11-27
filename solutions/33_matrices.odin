package odinlings

import "core:fmt"
import "core:math/linalg"

/*
 * matrices
 *
 * odin has a built in matrix type: matrix[rows, columns]Element
 * Go does not, you would need a library like gonum
 *
 *     m := matrix[2, 2]f32{
 *         1, 2,
 *         3, 4,
 *     }
 *
 * the literal is written row by row, like on paper
 * m[row, column] reads one element
 *
 * '*' between matrices is real matrix multiplication, not element by element,
 * so the shapes must fit: [A, B] * [B, C] -> [A, C]
 * a matrix times an array treats the array as a column vector
 *
 * casting a single number to a matrix type gives a diagonal matrix,
 * (matrix[2, 2]f32)(1) is the identity matrix
 *
 * core:math/linalg has helpers like transpose, inverse and rotation matrices
*/


main :: proc() {

    m := matrix[2, 2]f32{
        1, 2,
        3, 4,
    }

    assert(m[0, 1] == 2)
    assert(m[1, 0] == 3)


    identity := (matrix[2, 2]f32)(1)
    assert(m * identity == m)


    //rotate the point (1, 0) by 90 degrees counter-clockwise, it should end up at (0, 1)
    rotate_90 := matrix[2, 2]f32{
        0, -1,
        1, 0,
    }
    point := [2]f32{1, 0}
    assert(rotate_90 * point == [2]f32{0, 1})


    //a 2x3 matrix times a 3x2 matrix gives a 2x2 matrix
    a := matrix[2, 3]f32{
        1, 2, 3,
        4, 5, 6,
    }
    b := matrix[3, 2]f32{
        1, 0,
        0, 1,
        1, 1,
    }
    c := a * b
    fmt.println("a * b =", c)
    assert(c[0, 0] == 4)
    assert(c[1, 1] == 11)


    //transpose swaps rows and columns
    t := linalg.transpose(a)
    assert(t[2, 0] == 3)
}
