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

func Dist(x, y int, v *Vertex) int {
    return Abs(x - v.X) + Abs(y - v.Y)
}

func getDistSum(x, y int, vs []Vertex) (sum int) {
    for _, v := range vs {
        sum += Dist(x, y, &v)
    }
    return
}

func CountBeneath(minX, minY, maxX, maxY, limit int, vertexes []Vertex) int {
    toSum := make(chan int, 100)
    waitOnSummer := make(chan int)
    var waitGroup sync.WaitGroup
    var sum int
    go func() {
        defer close(waitOnSummer)
        for s := range toSum {
            sum += s
        }
    }()
    for i := minX; i <= maxX; i++ {
        for j := minY; j <= maxY; j++ {
            waitGroup.Add(1)
            go func(x, y int) {
                defer waitGroup.Done()
                if getDistSum(x, y, vertexes) < limit {
                    toSum <- 1
                }
            }(i, j)
        }
    }
    waitGroup.Wait()
    close(toSum)
    for _ = range waitOnSummer {}
    return sum
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
    fmt.Println(CountBeneath(minX, minY, maxX, maxY, 10000, vertexes))
}
