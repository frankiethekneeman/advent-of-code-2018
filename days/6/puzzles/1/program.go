package main

import (
    "fmt"
    "bufio"
    "os"
    "strconv"
    "strings"
    "sync"
)

type Vertex struct {
    X, Y int
}

var CONFLICT = Vertex{-1, -1}

func Abs(a int) int {
    if (a > 0) {
        return a
    }
    return -a
}
func Max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func Min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func GetFieldSize(vs []Vertex) (minX, minY, maxX, maxY int) {
    minX = int(^uint(0) >> 1)
    minY = minX
    maxX = -1
    maxY = -1
    for _, v := range vs {
        minX = Min(minX, v.X)
        minY = Min(minY, v.Y)
        maxX = Max(maxX, v.X)
        maxY = Max(maxY, v.Y)
    }
    return
}

func GetField(minX, minY, maxX, maxY int) [][]Vertex {
    toReturn := make([][]Vertex, maxX-minX+1)
    for i := range toReturn {
        toReturn[i] = make([]Vertex, maxY-minY+1)
    }
    return toReturn
}

func Dist(x, y int, v *Vertex) int {
    return Abs(x - v.X) + Abs(y - v.Y)
}

func FindClosest(x, y int, vs []Vertex) Vertex {
    conflict := false
    minDist := int(^uint(0) >> 1)
    var closest Vertex
    for _, v := range vs {
        d := Dist(x, y, &v)
        switch {
            case d < minDist:
                minDist = d
                closest = v
                conflict = false
            case d == minDist:
                conflict = true
        }
    }
    if conflict {
        return CONFLICT
    }
    return closest
}

func FillField(field [][]Vertex, minX, minY int, vertexes []Vertex) {
    var waitGroup sync.WaitGroup
    for i, row := range field {
        for j := range row {
            waitGroup.Add(1)
            go func(x, y int) {
                defer waitGroup.Done()
                field[x][y] = FindClosest(x + minX, y + minY, vertexes)
            }(i, j)
        }
    }
    waitGroup.Wait()
}

func CountField(field [][]Vertex) map[Vertex]int {
    toReturn := make(map[Vertex]int)
    for _, row := range field {
        for _, v := range row {
            toReturn[v]++
        }
    }
    return toReturn
}

func EliminateUnbounded(field [][]Vertex, counts map[Vertex]int, maxX, maxY int) {
    for x := 0; x <= maxX; x++ {
        delete(counts, field[x][0])
        delete(counts, field[x][maxY])
    }
    for y := 0; y <= maxY; y++ {
        delete(counts, field[0][y])
        delete(counts, field[maxX][y])
    }
}

func maxValue(m map[Vertex]int) (max int) {
    for _, v := range m {
        max = Max(v, max)
    }
    return
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    var i int;
    var vertexes []Vertex
    for scanner.Scan() {
        line := scanner.Text()
        coords := strings.Split(line, ", ")
        x, _ := strconv.Atoi(coords[0])// thank god for well formatted inputs
        y, _ := strconv.Atoi(coords[1])
        v := Vertex {x, y}
        i++
        vertexes = append(vertexes, v);
    }
    minX, minY, maxX, maxY := GetFieldSize(vertexes)
    field := GetField(minX, minY, maxX, maxY)
    FillField(field, minX, minY, vertexes)
    counts := CountField(field)
    delete(counts, CONFLICT)
    EliminateUnbounded(field, counts, maxX - minX, maxY - minY)
    fmt.Println(maxValue(counts))
}
