defmodule Parser do
    def toRange([first, second]), do: Range.new(first, second)
    def toRange([first]), do: Range.new(first, first)
    def generateRange(str, var) do
        strings = Regex.run(~r/#{var}=(\d+)(?:..(\d+))?/, str, capture: :all_but_first)
        toRange(for s <- strings do
            {i, _} = Integer.parse(s)
            i
        end)
    end
    def generateClay(line) do
        for x <- generateRange(line, 'x'), y <- generateRange(line, 'y'), into: MapSet.new(), do: {x, y}
    end
    def getAllClay(input) do
        sets = Enum.map(IO.stream(input, :line), &generateClay(&1))
        Enum.reduce(sets, MapSet.new(), &MapSet.union(&1, &2))
    end
end
defmodule Water do
    def left({x, y}), do: {x-1, y}
    def right({x, y}), do: {x+1, y}
    def down({x, y}), do: {x, y+1}
    def supported?(p, clay, settled) do 
        d = down(p)
        MapSet.member?(clay, d) or MapSet.member?(settled, d)
    end
    def settleable?(p, clay, visited, settled) do
        supported?(p, clay, settled) and
            settleableL?(p, clay, visited, settled) and
            settleableR?(p, clay, visited, settled)
    end
    def settleableL?(p, clay, visited, settled) do
        supported?(p, clay, settled) and (
            MapSet.member?(clay, left(p)) or (
                MapSet.member?(visited, left(p))
                settleableL?(left(p), clay, visited, settled)
            )
        )
    end
    def settleableR?(p, clay, visited, settled) do
        supported?(p, clay, settled) and (
            MapSet.member?(clay, right(p)) or (
                MapSet.member?(visited, right(p))
                settleableR?(right(p), clay, visited, settled)
            )
        )
    end
    def visit(maxY, clay, settled, visited) do
        newSettled = for p <- visited,
            not MapSet.member?(settled, p) and settleable?(p, clay, visited, settled),
            into: MapSet.new(),
            do: p
        settled = MapSet.union(settled, newSettled)
        vDown = for p <- visited,
                {_, y} <- [p],
            y < maxY and not MapSet.member?(visited, down(p)) and not MapSet.member?(clay, down(p)),
            into: MapSet.new(),
            do: down(p)
        vLR = for p <- visited,
            n <- [left(p), right(p)],
            not MapSet.member?(visited, n) and not MapSet.member?(clay, n) and supported?(p, clay, settled),
            into: MapSet.new(),
            do: n
        newVisited = MapSet.union(vDown, vLR)
        visited = MapSet.union(newVisited, visited)
        if (MapSet.size(newSettled) + MapSet.size(newVisited) == 0) do
            {settled, visited}
        else
            visit(maxY, clay, settled, visited)
        end
    end
end
clay = Parser.getAllClay(:stdio)
ys = for {_, y} <- clay, do: y
minY = Enum.min(ys)
maxY = Enum.max(ys)
{settled, _} = Water.visit(maxY, clay, MapSet.new(), MapSet.new([{500, minY}]))
IO.puts MapSet.size(settled)
