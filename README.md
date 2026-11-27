# odinlings 
small exercises for learning Odin



# build instrutions

[install the Odin compiler](https://odin-lang.org/docs/install/)

```
git clone https://github.com/serpens8888/odinlings.git
cd odinlings
odin build .
```
windows:
```./init.bat```

linux/mac:
```
chmod +x init.sh
./init.sh
```

# odin for go programmers

exercises 28 to 47 cover the features odin has and go doesn't (or does very differently).
the comments in them compare odin with go:

| # | topic | # | topic |
|---|---|---|---|
| 28 | defer runs at the end of a scope | 38 | using (embedding, ^Player as ^Entity) |
| 29 | distinct types vs aliases | 39 | or_return / or_else instead of `if err != nil` |
| 30 | enumerated arrays `[Enum]T` | 40 | Maybe(T) and `#no_nil` unions |
| 31 | bit_set | 41 | manual memory: new/free, make/delete, [dynamic], map |
| 32 | array programming and swizzling | 42 | the context, allocators, temp_allocator |
| 33 | matrix types | 43 | #soa (structure of arrays) |
| 34 | procedure groups (overloading) | 44 | when, #assert, #config |
| 35 | default values and named arguments | 45 | cast, transmute, auto_cast, `---` |
| 36 | generic procedures `$T`, `$N`, where | 46 | bit_field |
| 37 | generic structs `Stack($T, $N)` | 47 | quiz 2 |

# using odinlings
these commands will only work in the odinlings root folder

use ```./odinlings curr``` to see the current exercise

use ```./odinlings run``` to build and run the current exercise

use ```./odinlings next``` to select the next exercise  

use ```./odinlings prev``` to select the previous exercist  

use ```./odinlings goto <number>``` to go to a specific exercise  


```./odinlings curr``` will give you the path of the current exercise file,
open it in your favorite text editor and try to fix the errors.

if you get stuck there are solved versions in the solutions folder   
the provided solutions are not the only way to solve the problems

