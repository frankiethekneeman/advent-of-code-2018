open System

let input = 
    Seq.initInfinite(fun _ -> System.Console.In.ReadLine())
    |> Seq.takeWhile(fun line -> line <> null)
    |> Seq.cache
    ;;

[<StructuredFormatDisplay("Nanobot({X},{Y},{Z},{R})")>]
type Nanobot = struct
    val X : int
    val Y : int
    val Z : int
    val R : int

    new(x, y, z, r) = 
        {X = x; Y = y; Z = z; R = r}
end

[<StructuredFormatDisplay("OriginDist({Min},{Max})")>]
type DistFromOrigin = struct
    val Min: int
    val Max: int

    new(bot: Nanobot) =
        {
            Min = Math.Max(0, Math.Abs(bot.X) + Math.Abs(bot.Y) + Math.Abs(bot.Z) - bot.R)
            Max = Math.Abs(bot.X) + Math.Abs(bot.Y) + Math.Abs(bot.Z) + bot.R
        }
end

exception ParseException of string
let nanobotParser (line: string) = 
    let ints =
        line.Replace("pos=<", "")
            .Replace(">", "")
            .Replace(" r=", "")
            .Split(",")
            |> Array.map int
    match ints with
    | [| x; y; z; r |] -> new Nanobot(x,y,z,r)
    | _ -> raise (ParseException("Why are you like this? " + line))
    ;;

let stronger (left:Nanobot) (right:Nanobot) = 
    if left.R > right.R then left else right

let distance (left:Nanobot) (right:Nanobot) = 
    Math.Abs(left.X - right.X) 
        + Math.Abs(left.Y - right.Y) 
        + Math.Abs(left.Z - right.Z) 

let inRange (sender:Nanobot) (receiver:Nanobot) = 
    (distance sender receiver) <= sender.R

let toIncrementors (range: DistFromOrigin) = 
   [ (range.Min, +1); (range.Max + 1, -1) ]

[<EntryPoint>]
let main argv =
    let nanobots =
        input
            |> Seq.map nanobotParser
    let distances = 
        nanobots
            |> Seq.map (fun bot -> new DistFromOrigin(bot))
            |> Seq.collect toIncrementors
            |> Seq.sortBy (fun (pt, inc) -> pt)
            |> Seq.scan (fun (_, count) (dist, inc) -> (dist, count + inc)) (0,0)
            |> Seq.pairwise
            |> Seq.map (fun ((min, dist),(max, _)) -> (min, max - 1, dist))
            |> Seq.filter (fun (start, stop, _) -> stop >= start)
            |> Seq.sortBy (fun (_, _, count) -> -count)
    let (min, _, _) = Seq.head distances
    printfn "%A" min
    //for r in distances do printfn "%A" r
    0 // return an integer exit code
