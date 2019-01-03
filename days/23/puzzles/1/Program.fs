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

[<EntryPoint>]
let main argv =
    let nanobots =
        input
            |> Seq.map nanobotParser
    let strongestBot =
        nanobots
            |> Seq.maxBy (fun bot -> bot.R)
    let receivers =
        nanobots
            |> Seq.filter (inRange strongestBot)
            |> Seq.length
    printfn "%i" receivers
    //for bot in nanobots do printfn "%A" bot
    0 // return an integer exit code
