% COMP9814 Artificia Intelligence - Assignment 1 - Prolog Programming
% Alexander Whillas z3446737
%


% Question 1
%
sumsq_div3or5([], 0).
sumsq_div3or5([Head|Tail], Sum) :-
  0 is Head mod 3,
  !,
  sumsq_div3or5(Tail, SubTotal),
  Sum is Head * Head + SubTotal.
sumsq_div3or5([Head|Tail], Sum) :-
  0 is Head mod 5,
  !,
  sumsq_div3or5(Tail, SubTotal),
  Sum is Head * Head + SubTotal.
sumsq_div3or5([_|Tail], Sum) :-
  sumsq_div3or5(Tail, SubTotal),
  Sum is SubTotal.


% Question 2
%
givers(Giver1, Giver2) :-
  gives(Giver1, Giver2, Thing1),
  gives(Giver2, Giver1, Thing2),
  not(Giver1 == Giver2),
  not(Thing1 == Thing2).


% Question 3a
%
log_table([], []).
log_table([Head|Tail], ResultList) :-
  log_table(Tail, SubList),
  X is log(Head),
  ResultList = [[Head, X]|SubList].

% Question 3b
%
function_table([], _, []).
function_table([Head|Tail], Function, ResultList) :-
  function_table(Tail, Function, SubResult),
  X =.. [Function, Head],
  Y is X,
  ResultList = [[Head|Y]|SubResult].


% Question 4
%
chop_down([], []).
chop_down([Head|Tail], NewList) :-
  is_decrentedal(Head, Tail),
  !,
  chop_down(Tail, NewList).
chop_down([Head|Tail], [Head|NewList]) :-
  chop_down(Tail, NewList).

is_decrentedal(Number, [Head|_]) :-
  Number =:= Head + 1.


% Question 5
%
tree_eval(Value, tree(empty, z, empty), Value).
tree_eval(_, tree(empty, Num, empty), Num).
tree_eval(Value, tree(Left, Op, Right), Eval) :-
  tree_eval(Value, Left, L),
  tree_eval(Value, Right, R),
  !,
  Expression =.. [Op, L, R],
  Eval is Expression.

