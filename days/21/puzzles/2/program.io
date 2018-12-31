Instruction := Object clone do(
    A := -1
    B := -1
    C := -1
    op := "noop"
    readsA := method(
        op == "addi" or
        op == "addr" or
        op == "muli" or
        op == "mulr" or
        op == "bani" or
        op == "banr" or
        op == "bori" or
        op == "borr" or
        op == "setr" or
        op == "gtrr" or
        op == "gtri" or
        op == "eqrr" or
        op == "eqri"
    )
    readsB := method(
        op == "addr" or
        op == "mulr" or
        op == "banr" or
        op == "borr" or
        op == "gtrr" or
        op == "gtir" or
        op == "eqrr" or
        op == "eqir"
    )
    readsR := method(r, (readsA() and (A == r)) or (readsB() and (B == r)))
)
computer := Object clone do(
    ip := 0
    registers := list(0,0,0,0,0,0)
    r := method(i, registers at(i))
    addi := method(A, B, C, registers atPut(C, r(A) + B))
    addr := method(A, B, C, registers atPut(C, r(A) + r(B)))
    muli := method(A, B, C, registers atPut(C, r(A) * B))
    mulr := method(A, B, C, registers atPut(C, r(A) * r(B)))
    bani := method(A, B, C, registers atPut(C, r(A) & B))
    banr := method(A, B, C, registers atPut(C, r(A) & r(B)))
    bori := method(A, B, C, registers atPut(C, r(A) | B))
    borr := method(A, B, C, registers atPut(C, r(A) | r(B)))
    seti := method(A, B, C, registers atPut(C, A))
    setr := method(A, B, C, registers atPut(C, r(A)))
    gtrr := method(A, B, C, registers atPut(C, if(r(A) > r(B), 1, 0)))
    gtir := method(A, B, C, registers atPut(C, if(  A  > r(B), 1, 0)))
    gtri := method(A, B, C, registers atPut(C, if(r(A) >   B , 1, 0)))
    eqrr := method(A, B, C, registers atPut(C, if(r(A) == r(B), 1, 0)))
    eqir := method(A, B, C, registers atPut(C, if(  A  == r(B), 1, 0)))
    eqri := method(A, B, C, registers atPut(C, if(r(A) ==   B , 1, 0)))
    ipRegister := -1
    setInstructionPointerRegister := method (ipLine, ipRegister = ipLine exSlice(-1) asNumber)
    program := List clone
    hasNext := method(ip < program size)
    injestInstruction := method(line, 
        Locals pieces := line split (" ")
        Locals newInstruction := Instruction clone
        newInstruction op := line exSlice(0,4)
        newInstruction A := pieces at(1) asNumber
        newInstruction B := pieces at(2) asNumber
        newInstruction C := pieces at(3) asNumber
        program append(newInstruction)
    )
    tick :=method(
        registers atPut(ipRegister, ip)
        Locals instruction := currentInstruction
        Locals toDo := self getSlot(instruction op)
        toDo(instruction A, instruction B, instruction C)
        ip = registers at(ipRegister)
        ip = ip + 1
    )
    state := method("#{ipRegister} -> #{ip}; #{registers}" interpolate)
    currentInstruction := method(program at(ip))
    currentInstructionReads0 := method(program at(ip) readsR(0))
    nextInstructionJumps := method(program at(ip + 1) C == ipRegister)

    getR0ValueForTruth := method(
        Locals instruction := currentInstruction
        Locals comparison := if(instruction readsA() and (instruction A == 0),
            if (instruction readsB(), r(instruction B), instruction B),
            if (instruction readsA(), r(instruction A), instruction A)
        )
        if(instruction op exSlice(0,2) == "eq",
            comparison,
            if(instruction op exSlice(0,2) == "gt"
                if(instruction readsA() and instruction A == 0,
                    comparison + 1,
                    comparison - 1
                ),
                Exception raise ("I was not prepared for this")
            )
        )

    )
)

computer setInstructionPointerRegister(File standardInput readLine)
File standardInput readLines foreach(line, computer injestInstruction(line))

exitValues := List clone
while (computer hasNext,
    computer tick
    if (computer currentInstructionReads0 and computer nextInstructionJumps,
        val := computer getR0ValueForTruth
        if(exitValues contains(val),
            break,
            exitValues append(val)
        )
    )
)
exitValues at(exitValues size -1) println
