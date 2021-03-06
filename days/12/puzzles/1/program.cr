class Pots
    def initialize()
        @planted = Set(Int16).new()
    end

    def influence(locus : Int16) : Int16
        pieces = ((locus - 2)..(locus + 2)).map_with_index do |l, i|
            (@planted.includes?(l)? 1 : 0 ) << (4-i)
        end
        pieces.sum().to_i16
    end

    def plant(pot : Int16)
        @planted << pot
    end

    def next(transitions : Set(Int16)) : Pots
        toRet = Pots.new()
        mm = @planted.minmax()
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
end

def asInt16(definition : String) : Int16
    pieces = definition.chars.map_with_index do |c, i|
        ((c == '#')?1:0) << (4 - i)
    end
    pieces.sum().to_i16
end

pots = Pots.new()
transitions = Set(Int16).new()

firstLine = STDIN.gets()
unless firstLine.nil?
    initialVector = firstLine.split(": ")[1]
    initialVector.each_char_with_index do |c, i|
        if c == '#'
            pots.plant i.to_i16
        end
    end
end
STDIN.gets()
line = STDIN.gets()
until line.nil?
    pieces = line.split(" => ")
    if pieces[1] == "#"
        transitions << asInt16(pieces[0])
    end
    line = STDIN.gets()
end

fin = (1..20).reduce(pots) do |p, i|
    p.next(transitions)
end
puts fin.sum
