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

