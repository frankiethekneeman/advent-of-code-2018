function addi (A, B, C, registers)
    registers[C + 1] = registers[A + 1] + B
end

function addr (A, B, C, registers)
    registers[C + 1] = registers[A + 1] + registers[B + 1]
end

function muli (A, B, C, registers)
    registers[C + 1] = registers[A + 1] * B
end

function mulr (A, B, C, registers)
    --print()
    --print ("mulr " .. A .." "..B.." "..C)
    --print(registers[A + 1])
    --print(registers[B + 1])
    --print(registers[A + 1] * registers[B + 1])
    --print(registers[A + 1] * registers[B + 1])
    registers[C + 1] = registers[A + 1] * registers[B + 1]
end

function bani (A, B, C, registers)
    registers[C + 1] = bit32.band(registers[A + 1], B)
end

function banr (A, B, C, registers)
    registers[C + 1] = bit32.band(registers[A + 1], registers[B + 1])
end

function bori (A, B, C, registers)
    registers[C + 1] = bit32.bor(registers[A + 1], B)
end

function borr (A, B, C, registers)
    registers[C + 1] = bit32.bor(registers[A + 1], registers[B + 1])
end

function seti (A, B, C, registers)
    registers[C + 1] = A
end

function setr (A, B, C, registers)
    registers[C + 1] = registers[A + 1]
end

function gtir (A, B, C, registers)
    registers[C + 1] = A > registers[B + 1] and 1 or 0
end

function gtri (A, B, C, registers)
    registers[C + 1] = registers[A + 1] > B and 1 or 0
end

function gtrr (A, B, C, registers)
    registers[C + 1] = registers[A + 1] > registers[B + 1] and 1 or 0
end

function eqir (A, B, C, registers)
    registers[C + 1] = A == registers[B + 1] and 1 or 0
end

function eqri (A, B, C, registers)
    registers[C + 1] = registers[A + 1] == B and 1 or 0
end

function eqrr (A, B, C, registers)
    registers[C + 1] = registers[A + 1] == registers[B + 1] and 1 or 0
end

io.read(3)
ir = io.read("*n") + 1
io.read("*l")
op = io.read(4)
program = {}
while op do 
    cmd = {op, io.read("*n"), io.read("*n"), io.read("*n")}
    program[1 + #program] = cmd
    io.read("*l") -- chomp the line
    op = io.read(4)
end
rs = {0, 0, 0, 0, 0, 0}

ip = rs[ir] + 1
while program[ip] do
    rs[ir] = (ip - 1)
    cmd = program[ip]
    _G[cmd[1]](cmd[2], cmd[3], cmd[4], rs)
    ip = (rs[ir] + 2)
end
print(rs[1])
