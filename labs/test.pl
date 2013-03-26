test(f(A, B, C), D) :-
	A = B, C = D.

% Concatenate 2 lists
%
cons([], List, List).

cons([Head | Tail], List, [Head|TailList]) :-
	cons(Tail, List, TailList).
