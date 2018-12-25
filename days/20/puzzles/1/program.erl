-module(program).
-export([main/0]).

go({X, Y}, Dir) ->
    NextX = case Dir of
        $E -> X + 1;
        $W -> X - 1;
        $N -> X;
        $S -> X
    end,
    NextY = case Dir of
        $E -> Y;
        $W -> Y;
        $N -> Y + 1;
        $S -> Y - 1
    end,
    {NextX, NextY}.
step(Heads, Dir) ->
    lists:map(fun(P) -> go(P, Dir) end, Heads).

buildDoorFrom({ok, {N,S,E,W}}, Dir) ->
    case Dir of
        $E -> {N,S,true,W};
        $W -> {N,S,E,true};
        $N -> {true,S,E,W};
        $S -> {N,true,E,W}
    end;
buildDoorFrom(error, Dir) ->
    case Dir of 
        $E -> {false,false,true,false};
        $W -> {false,false,false,true};
        $N -> {true,false,false,false};
        $S -> {false,true,false,false}
    end.

buildDoorTo({ok, {N,S,E,W}}, Dir) ->
    case Dir of
        $W -> {N,S,true,W};
        $E -> {N,S,E,true};
        $S -> {true,S,E,W};
        $N -> {N,true,E,W}
    end;
buildDoorTo(error, Dir) ->
    case Dir of 
        $W -> {false,false,true,false};
        $E -> {false,false,false,true};
        $S -> {true,false,false,false};
        $N -> {false,true,false,false}
    end.

mashDoors(Doors, error) -> Doors;
mashDoors({LN, LS, LE, LW}, {ok, {RN, RS, RE, RW}}) ->
    {LN or RN, LS or RS, LE or RE, LW or RW}.

mergeDoorKnowledge(L, R) ->
    maps:fold(fun(Room, Doors, Acc) ->
        maps:put(Room, mashDoors(Doors, maps:find(Room, Acc)), Acc)
    end, R, L).

alternate(ToParse, Heads) ->
    {From, BranchDoors, BranchHeads, Left} = walk(ToParse, Heads),
    case From of
        alternate ->
            {_, RestDoors, RestHeads, Unparsed} = alternate(Left, Heads),
            {
                ok,
                mergeDoorKnowledge(BranchDoors, RestDoors),
                sets:to_list(sets:union(sets:from_list(BranchHeads), sets:from_list(RestHeads))),
                Unparsed
            }
        ;
        end_alternation -> {ok, BranchDoors, BranchHeads, Left}
    end
    .
walk([$||Tail], Heads) ->
    {alternate, #{}, Heads, Tail};
walk([$)|Tail], Heads) ->
    {end_alternation, #{}, Heads, Tail};
walk([$$], Heads) ->
    {parsed, #{}, Heads, ok};
walk([$(|Tail], Heads) ->
    {_, BranchDoors, NewHeads, Rest} = alternate(Tail, Heads),
    {ReturnFrom, RestDoors, RestHeads, Unparsed} = walk(Rest, NewHeads),
    ReturnDoors = mergeDoorKnowledge(RestDoors, BranchDoors),
    {ReturnFrom, ReturnDoors, RestHeads, Unparsed};

walk([H|Tail], Heads) ->
    NextHeads=step(Heads, H),
    {ReturnFrom, Doors, ReturnHeads, Left} = walk(Tail, NextHeads),
    ReturnDoors = lists:foldl(fun({Before, After}, Acc) ->
        NewBefore = buildDoorFrom(maps:find(Before, Acc), H),
        NewAfter = buildDoorTo(maps:find(After, Acc), H),
        maps:put(After, NewAfter, maps:put(Before, NewBefore, Acc))
    end, Doors, lists:zip(Heads, NextHeads)),
    {ReturnFrom, ReturnDoors, ReturnHeads, Left}.

findFurthest(Doors, Seen) ->
    DoorsLeft = maps:without(Seen, Doors),
    if
        map_size(DoorsLeft) == 0 -> 0;
        true ->
            NewRooms = lists:flatmap(fun(P) ->
                case maps:find(P, Doors) of
                    {ok, {N,S,E,W}} -> lists:flatten([
                        if N -> [go(P, $N)]; true -> [] end,
                        if S -> [go(P, $S)]; true -> [] end,
                        if E -> [go(P, $E)]; true -> [] end,
                        if W -> [go(P, $W)]; true -> [] end
                    ]);
                    error -> []
                end
            end, Seen),
            1 + findFurthest(DoorsLeft, NewRooms)
    end.

findFurthest(Doors) ->
    findFurthest(Doors, [{0,0}]).

walk([$^|Tail]) ->  %IT BEGINS
    {_, Doors, _, _} = walk(Tail, [{0,0}]),
    findFurthest(Doors).

main() ->
    Input = io:get_line(""),
    Chomped = string:chomp(Input),
    D = walk(Chomped),
    io:fwrite("~B~n", [D]).
