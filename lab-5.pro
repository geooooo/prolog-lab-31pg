/*
    Рёбра
*/

edge(a, b).
edge(a, h).
edge(a, a).
edge(b, c).
edge(b, h).
edge(h, e).
edge(h, c).
edge(h, b).
edge(e, b).
edge(e, f).
edge(c, h).
edge(c, d).
edge(d, g).
edge(g, f).


/*
    Весы
*/

weight(a, b, 8).
weight(a, h, 1).
weight(a, a, 0).
weight(b, c, 3).
weight(b, h, 4).
weight(h, e, 2).
weight(h, c, 1).
weight(h, b, 4).
weight(e, b, 3).
weight(e, f, 15).
weight(c, h, 1).
weight(c, d, 7).
weight(d, g, 3).
weight(g, f, 1).


/*
    Вершина - цель
*/

goal(c).


/*
    Алгоритм
*/

path_length([В1,В2], VAL) :-
    weight(В2, В1, VAL).
path_length([В1,В2|PATH], SUM) :-
    path_length([В2|PATH], S1),
    weight(В2, В1, VAL),
    SUM is VAL + S1.

path_weight([], []).
path_weight([PATH|AS], [(PATH,WEIGHT)|AL]) :-
    path_length(PATH, WEIGHT),
    path_weight(AS, AL).

partition([(X,WEIGHT)|XS], WEIGHT1, [(X,WEIGHT)|LS], BS) :-
    WEIGHT >= WEIGHT1,
    partition(XS, WEIGHT1, LS, BS).
partition([(X,WEIGHT)|XS], WEIGHT1, LS, [(X,WEIGHT)|BS]) :-
    WEIGHT < WEIGHT1,
    partition(XS, WEIGHT1, LS, BS).
partition([], _, [], []).

quicksort([(X,WEIGHT)|XS], YS) :-
    partition(XS, WEIGHT, LITTLESS, BIGS),
    quicksort(LITTLESS, LS),
    quicksort(BIGS, BS),
    append(LS, [(X,WEIGHT)|BS], YS).
quicksort([], []).

go(TOP, TOP1, (SOLUTION,VAL0)) :-
    weight(TOP, TOP1, VAL),
    in_depth([([TOP],VAL)], SOLUTION),
    path_length(SOLUTION, VAL0).

in_depth([([TOP0|PATH],_)|_], [TOP0|PATH]) :-
     goal(TOP0).
in_depth([([В|PATH],_)|PATHS], SOLUTION) :-
    bagof([В1,В|PATH], (edge(В,В1),not(member(В1,[В|PATH]))), NEW_PATHS),
    path_weight(NEW_PATHS, NEW_PATHS1),
    append(PATHS, PATHS1, NEW_PATHS1),
    !,
    quicksort(PATHS1, PATHS2),
    in_depth(PATHS2, SOLUTION);
    quicksort(PATHS, PATHS3),
    in_depth(PATHS3, SOLUTION).


/*
    Поиск решения
*/

find(PATH, VAL) :-
    go(a, a, (X,VAL)),
    reverse(X, PATH).
