 package advent.of.code
 import java.util.*
 import java.io.BufferedReader
 import java.io.InputStreamReader

 enum class Acre(val repr: Char) {
    OPEN('.'),
    TREES('|'),
    LUMBER('#')
 }

 class Field {
    var acres: List<List<Acre>> = emptyList()
    constructor(prev: Field) {
        acres = prev.acres.mapIndexed{ y: Int, xs -> 
            xs.mapIndexed{ x: Int, acre -> run {
                val neighbors = prev.neighbors(x, y)
                when(acre) {
                    Acre.OPEN -> if (neighbors.count{it == Acre.TREES} >=3) Acre.TREES else Acre.OPEN
                    Acre.TREES -> if (neighbors.count{it == Acre.LUMBER} >=3) Acre.LUMBER else Acre.TREES
                    Acre.LUMBER -> if(neighbors.count{it == Acre.LUMBER} >=1 &&
                        neighbors.count{it == Acre.TREES} >=1) Acre.LUMBER else Acre.OPEN
                }
                
            }}
        }
    }
    constructor(input: BufferedReader) {
        acres = input.lineSequence().map{
            line: String ->
                line.map{
                    c: Char -> when(c) {
                        '.' -> Acre.OPEN
                        '|' -> Acre.TREES
                        '#' -> Acre.LUMBER
                        else -> throw Exception("poopy")
                    }
                }
        }.toList()
    }
    fun at(x: Int, y: Int): Acre? {
        if (x < 0 || y < 0 || y >= acres.count() || x >= acres.first().count()) {
            return null
        }
        return acres.elementAt(y).elementAt(x)
    }

    fun neighbors(x: Int, y: Int): List<Acre> {
        return generateSequence(
            -1, {p -> if (p == 1) null else p+1}
        ).flatMap{ dx ->
            generateSequence(
                -1, {p -> if (p == 1) null else p+1}
            ).mapNotNull{ dy ->
                if (dy == 0 && dx == 0) null else at(x + dx, y + dy);
            }
        }.toList()
    }

    fun print() {
        acres.forEach{ row -> run {
            row.forEach{ acre -> print(acre.repr) }
            println()
        }}
    }

    fun count(acre: Acre): Int {
        return acres.flatten().count{it == acre}
    }
}
fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    var field = Field(reader)
    for (i in 1..10) {
        field = Field(field);
    }
    println(field.count(Acre.TREES) * field.count(Acre.LUMBER))
}
