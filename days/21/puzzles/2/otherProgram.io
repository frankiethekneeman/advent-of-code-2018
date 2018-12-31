r0 := 0
r1 := 0
r2 := 0
r3 := 0
r4 := 0
r5 := 123
loop(
    r5 := r5 & 456
    r5 := if(r5 == 72, 1, 0)
    if (r5 == 1) then(break)
)
r5 := 0
seen := List clone
loop(
    r4 := r5 | 65536
    r5 := 13431073
    loop(
        r3 := r4 & 255 
        r5 := r5 + r3
        r5 := r5 & 16777215
        r5 := r5 * 65899
        r5 := r5 & 16777215
        r3 := if(256 > r4, 1, 0)
        if (r3 == 1) then(break)
        r3 = 0
        loop(
            r2 := r3 + 1
            r2 := r2 * 256
            r2 := if (r2 > r4, 1, 0)
            if (r2 == 0) then (r3 := r3 + 1) else (break)
        )
        r4 := r3
    )
    if (seen contains(r5)) then (break)
    seen append(r5)
)
seen at(seen size - 1) println
