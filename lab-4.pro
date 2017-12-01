/*
    Узлы
*/

node(a1, 1).
node(a2, 2).
node(a3, 3).
node(a4, 4).
node(a5, 5).
node(a6, 6).
node(a7, 7).
node(a8, 8).
node(a9, 9).
node(a10, 10).
node(a11, 11).
node(a12, 12).
node(a13, 13).
node(a14, 14).
node(a15, 15).
node(a16, 16).
node(a17, 17).
node(a18, 18).
node(a19, 19).
node(a20, 20).
node(a21, 21).
node(a22, 22).
node(a23, 23).
node(a24, 24).
node(a25, 25).
node(a26, 26).
node(a27, 27).
node(a28, 28).
node(a29, 29).
node(a30, 30).


/*
    Рёбра
*/

edge(a1, a2).
edge(a1, a3).
edge(a1, a4).
edge(a1, a5).
edge(a1, a6).
edge(a1, a7).
edge(a2, a1).
edge(a3, a1).
edge(a4, a1).
edge(a5, a1).
edge(a6, a1).
edge(a7, a1).

edge(a2, a8).
edge(a2, a9).
edge(a8, a2).
edge(a9, a2).

edge(a3, a9).
edge(a9, a3).

edge(a4, a9).
edge(a4, a10).
edge(a9, a4).
edge(a10, a4).

edge(a5, a11).
edge(a11, a5).

edge(a6, a12).
edge(a6, a13).
edge(a12, a6).
edge(a13, a6).

edge(a7, a13).
edge(a13, a7).

edge(a8, a14).
edge(a8, a15).
edge(a14, a8).
edge(a15, a8).

edge(a9, a10).
edge(a10, a9).

edge(a10, a11).
edge(a11, a10).

edge(a11, a15).
edge(a11, a16).
edge(a15, a11).
edge(a16, a11).

edge(a12, a16).
edge(a16, a12).

edge(a13, a17).
edge(a17, a13).

edge(a14, a18).
edge(a14, a19).
edge(a18, a14).
edge(a19, a14).

edge(a15, a20).
edge(a20, a15).

edge(a16, a21).
edge(a21, a16).

edge(a17, a21).
edge(a21, a17).

edge(a18, a22).
edge(a22, a18).

edge(a19, a23).
edge(a23, a19).

edge(a20, a23).
edge(a23, a20).

edge(a21, a24).
edge(a21, a28).
edge(a24, a21).
edge(a28, a21).

edge(a22, a26).
edge(a26, a22).

edge(a23, a26).
edge(a26, a23).

edge(a24, a23).
edge(a24, a27).
edge(a23, a24).
edge(a27, a24).

edge(a25, a26).
edge(a25, a30).
edge(a26, a25).
edge(a30, a25).

edge(a27, a29).
edge(a29, a27).

edge(a28, a29).
edge(a29, a28).

edge(a29, a30).
edge(a30, a29).


/*
    Алгоритм
*/

solveHillClimb(Start, Finish, _, [Finish]) :-
    edge(Start, Finish).
solveHillClimb(State, Finish, History, [State1|Moves]) :-
    hillClimb(State, State1),
    not(member(State1, History)),
    solveHillClimb(State1, Finish, [State1|History], Moves),
    !.

hillClimb(State, Move):-
    findall(M, edge(State, M), Moves),
    evalute(Moves, State, [], MVs),
    member((Move, _), MVs).

evalute([], _, MVs, MVs).
evalute([Move|Moves], State, MVs, OderedMVs):-
    node(Move, Value),
    insert((Move, Value), MVs, MVs1),
    evalute(Moves, State, MVs1, OderedMVs).

insert(MV, [], [MV]).
insert((M,V), [(M1,V1)|MVs], [(M,V),(M1,V1)|MVs]) :-
    V =< V1.
insert((M,V), [(M1,V1)|MVs], [(M1,V1)|MVs1]) :-
    V > V1,
    insert((M,V), MVs, MVs1).

hes(Start, Finish, List) :-
    edge(Start, _),
    solveHillClimb(Start, Finish, [Start], List1),
    append([Start], List1, List).
