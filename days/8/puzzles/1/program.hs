import Debug.Trace

lineToInts :: [Char] -> [Int]
lineToInts line = [ read i :: Int | i <- words line ]

data Node = Node {
    children :: [Node]
    , metadata :: [Int]
    , leftovers :: [Int]
} deriving (Show)

parseNode :: [Int] -> Node
parseNode ints =
    let nChildren = head ints
        nMeta = head (tail ints)
        children = gatherNodes nChildren (drop 2 ints)
        left = if nChildren > 0 
            then leftovers (last children)
            else drop 2 ints
        metadata = take nMeta left
        remains = drop nMeta left
    in Node children metadata remains

gatherNodes :: Int -> [Int] -> [Node]
gatherNodes num ints
    | num == 0 = []
    | otherwise = 
        let first = parseNode ints
        in first : gatherNodes (num - 1) (leftovers first)


sumMeta :: Node -> Int
sumMeta (Node kids meta _) = 
    (sum [sumMeta child | child <- kids]) + (sum meta)

main = do
    line <- getLine
    let ints = lineToInts line
    let node = parseNode ints
    print $ sumMeta node
