use_module(library(lists)).

exact_region(ID, X1, Y1, X2, Y2) :- region(ID, X1, Y1, W, H),
    X2 is X1 + W - 1,
    Y2 is Y1 + H - 1.

in_order([_]) :- true.
in_order([F,S|T]) :- F < S,
    in_order([S|T]).

distinct(R1, R2) :- exact_region(R1, X1, Y1, X2, Y2),
    exact_region(R2, X3, Y3, X4, Y4),
    (
        in_order([X1, X2, X3, X4]);
        in_order([Y1, Y2, Y3, Y4]);
        in_order([X3, X4, X1, X2]);
        in_order([Y3, Y4, Y1, Y2])
    ),
    R1 =\= R2.

overlap(R1, R2) :- exact_region(R1, _, _, _, _),
    exact_region(R2, _, _, _, _),
    \+ distinct(R1, R2),
    R1 =\= R2.

uncontested(R1) :-
    region(R1, _, _, _, _),
    \+ overlap(R1, _).
