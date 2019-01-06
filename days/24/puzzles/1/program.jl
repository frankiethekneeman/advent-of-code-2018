
u = "units each with"
hp = "hit points"
i = "immune"
w = "weak"
a = "with an attack that does"
d = "damage at initiative"
type = "[a-zA-Z]+"
types = "$type(?:, $type)*"
effect = "(?:$i|$w) to (?:$types)"
effects = "($effect(?:; $effect)*)"
troopDef = Regex("^(\\d+) $u (\\d+) $hp (?:\\($effects\\) )?$a (\\d+) ($type) $d (\\d+)\$")

mutable struct Troop
    id::Int
    count::Int
    hp::Int
    immunities::Array{String}
    weaknesses::Array{String}
    attack::Int
    element::String
    initiative::Int
    army::String
end

function getTypes(str)::Array{String}
    if str == nothing
        []
    else
        split(str, ", ")
    end

end
function getEffect(effect, parsed)::Array{String}
    if parsed != nothing
        for candidate in split(parsed, "; ")
            if startswith(candidate, effect)
                return getTypes(candidate[length(effect)+1:end])
            end
        end
    end
    []
end
function getTroop(line, army, id)
    captures = match(troopDef, line).captures
    Troop(
        id,
        parse(Int, captures[1]),
        parse(Int, captures[2]),
        getEffect("$i to ", captures[3]),
        getEffect("$w to ", captures[3]),
        parse(Int, captures[4]),
        captures[5],
        parse(Int, captures[6]),
        army
    )
end

lines = Iterators.Stateful(map(chomp, readlines()))

troops=Troop[]
army=popfirst!(lines)
toParse=popfirst!(lines)
id=1
while toParse != ""
    global toParse
    global id
    push!(troops, getTroop(toParse, army, id))
    toParse = popfirst!(lines)
    id += 1
end

army=popfirst!(lines)
id=0
push!(troops, map(l-> begin
    global id
    id += 1
    getTroop(l, army, id)
end, collect(lines))...)

function calcDamage(attacker::Troop, defender::Troop)
    factor = if attacker.element in defender.weaknesses 
        2
    elseif attacker.element in defender.immunities
        0
    else
        1
    end
    attacker.count * attacker.attack * factor
end

function killCount(attacker::Troop, defender::Troop)
    min(div(calcDamage(attacker, defender), defender.hp),defender.count)
end
function getTarget(targeter::Troop, troops::Array{Troop}, targeted::Array{Troop})
    sorted = sort(troops, by=t->(-calcDamage(targeter,t), -t.count*t.attack, -t.initiative))
    filtered = filter(t -> t.army != targeter.army && !(t in targeted), sorted)
    if length(filtered) == 0 || calcDamage(targeter, filtered[1]) == 0
        nothing
    else
        filtered[1]
    end
end

function getTargets(troops::Array{Troop})
    toReturn = Dict{Troop,Troop}();
    for troop in sort(troops, by=t->(-t.count*t.attack, -t.initiative))
        target = getTarget(troop, troops, collect(values(toReturn)))
        if target != nothing
            toReturn[troop] = target;
        end
    end
    toReturn
end
function doAttacks(troops::Array{Troop}, targets::Dict{Troop, Troop})
    for attacker in sort(troops, by=t->-t.initiative)
        if haskey(targets, attacker) 
            defender = targets[attacker]
            kills = killCount(attacker, defender)
            defender.count = defender.count - kills
        end
    end
    filter(t -> t.count > 0, troops)
end
function countFactions(troops::Array{Troop})
    length(unique(map(t-> t.army, troops)))
end

while countFactions(troops) > 1
    global troops
    targets = getTargets(troops)
    troops = doAttacks(troops, targets)
end

println(sum(map(t -> t.count, troops)))
