package runner

import "core:os"
import "core:fmt"
import "core:log"
import "core:strconv"
import "core:strings"
import "core:c/libc"
import "core:slice"

filename :: "current_exercise.txt"

main :: proc(){

    context.logger = log.create_console_logger()
    defer log.destroy_file_logger(context.logger)

    if(len(os.args) == 1){
        fmt.println("this is the odinlings exercise runner!\n")
        fmt.println("use 'run' to run the current exercise")
        fmt.println("use 'curr' to see the currently selected exercise")
        fmt.println("use 'next' to go to the next exercise")
        fmt.println("use 'prev' to go to the previous exercise")
        fmt.println("use 'goto' to go to a specific exercise by number")
        return
    }

    infos, read_err := os.read_all_directory_by_path("exercises", context.allocator)
    defer os.file_info_slice_delete(infos, context.allocator)
    if(read_err != nil){
        log.fatalf("failed to read exercises directory - %v", read_err)
        return
    }

    //the os does not guarantee any order, so sort the exercises by their file name (01_, 02_, ...)
    slice.sort_by(infos, proc(a, b: os.File_Info) -> bool { return a.name < b.name })

    current_exercise_file, file_err := os.read_entire_file(filename, context.allocator)
    defer delete(current_exercise_file)
    if(file_err != nil){
        log.fatalf("failed to read %s, run init.sh / init.bat first - %v", filename, file_err)
        return
    }
    current_exercise := strconv.parse_int(strings.trim_space(string(current_exercise_file))) or_else 0
    current_exercise = clamp(current_exercise, 0, len(infos)-1)
    
    switch os.args[1]{
        case "run" : run_exer(infos, current_exercise)
        case "curr": print_curr(infos, current_exercise)
        case "next": next_exer(infos, current_exercise)
        case "prev": prev_exer(infos, current_exercise)
        case "goto": goto_exer(infos)
    }
    
    //print out order of filenames for debugging
    /*
    for &info in infos{
        fmt.println(info.name)
    }
    */


    return
}

run_exer :: proc(infos: []os.File_Info, curr: int){
    to_run := infos[curr]
    fmt.printf("running %s\n", to_run.fullpath)

    cmd := fmt.ctprintf("odin run %s -file -sanitize:address -out:odin-out/%s.exe", to_run.fullpath, to_run.name)

    libc.system(cmd)

}

print_curr :: proc(infos: []os.File_Info, curr: int){
    fmt.printf("current exersice is exercise %d out of %d\n", curr+1, len(infos))
    fmt.printf("current exercise is located ad '%s'\n", infos[curr].fullpath)
}

next_exer :: proc(infos: []os.File_Info, curr: int){



    num := curr+1
    if(num >= len(infos)){
        log.errorf("%d is out of range", num)
        return
    }

    save_exer(num)

    return
}

prev_exer :: proc(infos: []os.File_Info, curr: int){
    
    num := curr-1
    if(num < 0){
        log.errorf("%d is out of range", num)
        return
    }

    save_exer(num)

    return
}

goto_exer :: proc(infos: []os.File_Info){

    if(len(os.args) < 3){
        log.error("goto requires a number to go to\n ex: ./odinlings goto 0")
        return
    }
    
    num := strconv.parse_int(os.args[2]) or_else -1
    
    if(num < 1 || num > len(infos)){
        log.errorf("%d is out of range", num)
        return
    }


    save_exer(num-1)

    return
}

save_exer :: proc(num: int){
    buf: [32]u8
    err := os.write_entire_file(filename, strconv.write_int(buf[:], i64(num), 10))
    if(err != nil){
        log.fatalf("failed to save tracked exercise - %v", err)
    }
}
