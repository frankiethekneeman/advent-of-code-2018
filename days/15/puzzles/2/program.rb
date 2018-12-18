require 'set'
def getNeighborCoords(x, y, maxX, maxY) 
    [
        [x - 1, y],
        [x + 1, y],
        [x, y - 1],
        [x, y + 1]
    ].delete_if{|p| p[0] < 0 || p[0] > maxX || p[1] < 0 || p[1] > maxY}
end
class SearchNode
    attr_accessor :locus, :searchX, :searchY
    def initialize(locus, searchX, searchY)
        @locus = locus
        @searchX = searchX
        @searchY = searchY
    end
    def <=>(other)
        [@locus.y, @locus.x, @searchY, @searchX] <=> [other.locus.y, other.locus.x, other.searchY, other.searchX]
    end
    def to_s()
        "#{@locus}...#{@searchX}...#{@searchY}"
    end
end
class Combatant
    attr_accessor :x, :y, :type, :hp, :ap, :t
    def initialize(x, y, type, ap)
        @x = x
        @y = y
        @type = type
        @hp = 200
        @ap = ap
        @t = 0
    end
    def turn(arena, opponents)
        move(arena, opponents)
        attack(arena)
        @t += 1
    end
    def move(arena, opponents)
        if (!opponents.reject{|o| o.surrounded(arena)}.empty? && threatens(@x, @y, arena).size == 0)
            maxX = arena.size - 1;
            maxY = arena[0].size - 1;
            visited = Set.new([arena[@x][@y]])
            candidates = getNeighborCoords(@x, @y, maxX,maxY)
                .map!{|c| SearchNode.new(arena[c[0]][c[1]], c[0], c[1])}
                .delete_if{|c| !c.locus.traversible? || visited.member?(c.locus)}
            viable = candidates.reject{|c| threatens(c.locus.x, c.locus.y, arena).size == 0}
            while (viable.size == 0 && candidates.size > 0)
                visited.merge(candidates.map {|c| c.locus})
                candidates.map!{|cand| 
                    getNeighborCoords(cand.locus.x, cand.locus.y, maxX, maxY)
                        .map!{|coord| SearchNode.new(arena[coord[0]][coord[1]], cand.searchX, cand.searchY)}
                        .delete_if{|c| !c.locus.traversible? || visited.member?(c.locus)}
                }.flatten!
                candidates = candidates.group_by{|c| c.locus}.values.map!{|cs| cs.sort![0]}
                viable = candidates.reject{|c| threatens(c.locus.x, c.locus.y, arena).size == 0}
            end
            if (viable.size > 0)
                goto = viable.sort![0]
                arena[@x][@y].inhabitant = nil
                @x = goto.searchX
                @y = goto.searchY
                arena[@x][@y].inhabitant = self
            end
        end
    end
    def threatens(x, y, arena)
        opponents = getNeighborCoords(x, y, arena.size - 1, arena[x].size - 1)
            .map!{|c| getPossibleOpponent(c[0], c[1], arena)}
            .delete_if{|i| i.nil?}
    end
    def attack(arena)
        opponents = threatens(@x, @y, arena)
        if opponents.length > 1 
            minH = opponents.map{|i| i.hp}.sort![0]
            opponents.delete_if{|i| i.hp != minH}.sort!
        end
        stab(opponents[0], arena) if opponents.length > 0
    end
    def surrounded(arena)
        getNeighborCoords(@x, @y, arena.size - 1, arena[@x].size - 1)
            .map!{|c| arena[c[0]][c[1]]}
            .delete_if{|i| !i.traversible?}
            .empty?
    end

    def getPossibleOpponent(x, y, arena)
        l = arena[x][y]
        # Don't attack people like me
        l.inhabitant.nil? || l.inhabitant.type == @type ? nil : l.inhabitant;
    end
    def <=>(other) 
        [@y, @x] <=> [other.y, other.x]
    end
    def stab(other, arena)
        other.wound(@ap, arena)
    end
    def wound(points, arena)
        @hp -= points
        if @hp <= 0
            arena[@x][@y].inhabitant = nil
        end
    end
    def to_s
       "#{@type}(#{@x}, #{@y}, HP#{@hp}, T#{@t})"
    end
    include Comparable
end

class Locus
    attr_accessor :x, :y, :inhabitant, :isWall
    def initialize(x, y)
        @x = x
        @y = y
        @inhabitant = nil
        @isWall = false
    end
    def traversible?
        @inhabitant.nil? && !@isWall
    end
    def getNeighborCoordinates(maxX, maxY)
        getNeighborCoors(@x, @y, maxX, maxY)
    end
    def to_s
       "(#{@x}, #{@y})#{@isWall?"wall":inhabitant}"
    end
end

def visualize(arena)
    for y in 0...(arena[0].size()) do
        for x in 0...(arena.size()) do
            if arena[x][y].isWall
                print('#')
            elsif !arena[x][y].inhabitant.nil?
                print(arena[x][y].inhabitant.type)
            else
                print('.')
            end
        end
        puts ''
    end
end

def shouldStop(combatants) 
    combatants.reject{|c| c.hp < 0}
        .map!{|c| c.type}
        .uniq
        .size() < 2
end

lines = ARGF.readlines.map{|s| s.chomp}
def COMBAT(lines, elfAttackPower)
    combatants = []
    arena = Array.new(lines[0].size) do |x|
        Array.new(lines.size()) do |y| 
            l = Locus.new(x, y)
            case lines[y][x] #lines is unintuitive
                when '#'
                    l.isWall = true
                when 'E'
                    c = Combatant.new(x, y, lines[y][x], elfAttackPower)
                    l.inhabitant = c
                    combatants.push(c)
                when 'G'
                    c = Combatant.new(x, y, lines[y][x], 3)
                    l.inhabitant = c
                    combatants.push(c)
            end
            l
        end
    end
    factions = combatants.group_by{|c| c.type}
    targetElfCount = factions['E'].size()
    while factions.size > 1 do
        combatants.sort!.each do |c|
            c.turn(arena, factions[factions.keys.delete_if{|k| k==c.type}[0]]) if (c.hp > 0)
            break if shouldStop(combatants)
        end
        combatants.delete_if{ |c| c.hp <=0 }
        factions = combatants.group_by{|c| c.type}
    end
    alive = combatants.reject{ |c| c.hp <= 0 }
    rounds = alive.map{|c| c.t}.sort![0]
    health = alive.map{|c| c.hp}.inject(:+)
    if factions['E'] == nil || factions['E'].size() < targetElfCount
        0
    else
        rounds * health
    end
end
p = 4
while true do
    score = COMBAT(lines, p)
    if(score > 0) 
        puts score
        break
    end
    p += 1
end
