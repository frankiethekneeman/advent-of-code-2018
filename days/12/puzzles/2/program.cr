class Pots
    @planted = Set(Int64).new()

    getter planted : Set(Int64)
    def initialize()
    end

    def influence(locus : Int64) : Int64
        pieces = ((locus - 2)..(locus + 2)).map_with_index do |l, i|
            (@planted.includes?(l)? 1 : 0 ) << (4-i)
        end
        pieces.sum().to_i64
    end

    def plant(pot : Int64)
        @planted << pot
    end

    def next(transitions : Set(Int64)) : Pots
        toRet = Pots.new()
        mm = @planted.minmax()
        width = mm[1] - mm[0] + 4
        ((mm[0] - 2)..(mm[1] + 2)).each do |locus|
            toRet.plant(locus) if transitions.includes?(influence locus)
        end
        toRet
    end

    def size
        @planted.size
    end

    def sum
        @planted.sum
    end

    def to_s
        @planted.to_s
    end
    def ==(other : Pots)
        @planted == other.planted
    end

    def similar(other : Pots)
        zeroed == other.zeroed
    end

    def zeroed
        m = min
        @planted.map do |p|
            p - m
        end
    end
    
    def min
        @planted.min
    end

end

def asInt64(definition : String) : Int64
    pieces = definition.chars.map_with_index do |c, i|
        ((c == '#')?1:0) << (4 - i)
    end
    pieces.sum().to_i64
end

pots = Pots.new()
transitions = Set(Int64).new()

firstLine = STDIN.gets()
unless firstLine.nil?
    initialVector = firstLine.split(": ")[1]
    initialVector.each_char_with_index do |c, i|
        if c == '#'
            pots.plant i.to_i64
        end
    end
end
STDIN.gets()
line = STDIN.gets()
until line.nil?
    pieces = line.split(" => ")
    if pieces[1] == "#"
        transitions << asInt64(pieces[0])
    end
    line = STDIN.gets()
end

max_generations = 50000000000_i64
i = 1_i64
nextPots = pots

while i <= max_generations
    nextPots = pots.next(transitions)
    break if nextPots == pots
    break if nextPots.similar(pots)
    pots = nextPots
    i += 1
end
fin = (nextPots.min - pots.min) * (max_generations - i) * pots.size + nextPots.sum
puts fin
