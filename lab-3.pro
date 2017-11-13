% path(a, b).
% path(b, a).
% path(b, c).
% path(c, b).
% path(c, d).
% path(d, c).
% path(c, a).
% path(a, c).
%
% move(X, Y) :-
%     path(X, Y).
% move(X, Y) :-
% 	path(X, Z),
% 	path(Z, Y).
%
% prolong([X|T],[Y,X|T]) :-
%     move(X,Y),
% 	not(member(Y,[X|T])).

/*
    nodes
*/
node(a1).
node(a2).
node(a3).
node(a4).
node(a5).
node(a6).
node(a7).
node(a8).
node(a9).
node(a10).
node(a11).
node(a12).
node(a13).
node(a14).
node(a15).
node(a16).
node(a17).
node(a18).
node(a19).
node(a20).
node(a21).
node(a22).
node(a23).
node(a24).
node(a25).
node(a26).
node(a27).
node(a28).
node(a29).
node(a30).

/*
    edges
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
    возвращает путь из вершины 1 в вершину 2
*/
path(A, B, Path):-
  breadth([A], [], [], B, UE),
  path(A, B, UE, Path).

/*
    восстанавливает путь из вершины 1 в вершину 2 по дугам
*/
path(A, B, UE, [(A, B)]):-
    member((A, B), UE),
     !.
path(A, B, UE, Path):-
    member((X, B), UE),
    !,
    path(A, X, UE, TPath),
    append(TPath, [(X, B)], Path).

/*
  обход графа в ширину
  список добавленных вершин
  исходный список использованных дуг
  список пройденных вершин
  конечная вершина
  результат - список использованных дуг
*/
breadth([], _, _, _, _):-
    !,
    fail.
breadth([H|_], UE, _, H, UE):-
    !.
breadth(V, UE, UV, FV, RUE):-
  add_adj(V, UE, UV, TV, TUE, TUV),
  breadth(TV, TUE, TUV, FV, RUE).

/*
    удаляет из списка вершин @1, вершины, входящие в @2 или @3. Результат в @4
*/
adj_filter([], _, _, []):-
    !.
adj_filter([H|T], L1, L2, [H|TR]):-
    not(member(H, L1)),
    not(member(H, L2)),
    !,
adj_filter(T, L1, L2, TR).
adj_filter([_|T], L1, L2, TR):-
    adj_filter(T, L1, L2, TR).
/*
    добавляет дуги из вершины @1 до вершин списка @2 в список @3. Результат в @4
*/
add_adj_edges(_, [], R, R):-
    !.
add_adj_edges(SV, [H|T], IL, [(SV,H)|TR]):-
    add_adj_edges(SV, T, IL, TR).

/*
    исходный список добавленных вершин
    исходный список дуг
    исходный список пройденных вершин
    результат - список добавленных вершин
    результат - список дуг
    результат - список пройденных вершин
*/
add_adj([], _, _, _, _, _):-!, fail.
add_adj([H|T], UE, UV, RV, RUE, RUV):-
    findall(X, edge(H, X), AVHL), % получили список смежных вершин
    adj_filter(AVHL, UE, UV, FAVHL), % убрали из него лишние вершины
    append(FAVHL, T , RV), % изменив порядок соединения списков,
                          % можно получить обход в глубину
    add_adj_edges(H, FAVHL, UE, RUE),
    RUV = [H|UV],
    !.
