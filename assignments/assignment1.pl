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

% Question 3
%

