use_module(library(lists)).

exact_region(ID, X1, Y1, X2, Y2) :- region(ID, X1, Y1, W, H),
    X2 is X1 + W - 1,
    Y2 is Y1 + H - 1.

before_first(_, []) :- true.
before_first(F, [S|_]) :- F < S.

in_order([]) :- true.
in_order([H|T]) :- before_first(H, T),
    in_order(T).

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

middle([_, B, C, _], L, R) :- L is B,
    R is C.

contested(R1, R2, XL, YL, XR, YR) :-
    overlap(R1, R2),
    exact_region(R1, X1, Y1, X2, Y2),
    exact_region(R2, X3, Y3, X4, Y4),
    msort([X1, X2, X3, X4], XS),
    msort([Y1, Y2, Y3, Y4], YS),
    middle(XS, XL, XR),
    middle(YS, YL, YR).

enumerate(X1, _, X2, _, []) :- X1 > X2.
enumerate(X1, Y1, X2, Y2, RES) :- X1 =< X2,
    X is X1 + 1,
    enumerate(X, Y1, X2, Y2, REST),
    enumerate_row(X1, Y1, Y2, ROW),
    append([ROW, REST], RES).

enumerate_row(_, Y1, Y2, []) :- Y1 > Y2.
enumerate_row(X, Y1, Y2, RES) :- Y1 =< Y2,
    Y is Y1 + 1,
    enumerate_row(X, Y, Y2, REST),
    append([[[X, Y1]], REST], RES).
    
contested_points(R1, R2, RES) :-
    contested(R1, R2, XL, YL, XR, YR),
    R1 < R2,
    enumerate(XL, YL, XR, YR, RES).

main(COUNT) :- 
    findall(RES, contested_points(_, _, RES), BAG),
    append(BAG, ALL),
    sort(ALL, SORTED),
    length(SORTED, COUNT).
