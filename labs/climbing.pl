% male(Person)
% female(Person)
%
% The argument term for these predicates is a structure
% representing a person.  It is in the form:
% person(FirstName, LastName)
%
male(person('Barry', 'Drake')).
male(person('Jim', 'Fried')).
female(person('Dot', 'Kanga')).

% climb(Name, Grade, FirstAscentPerson, FirstAscentDate).
%
% This predicate records the climb details.
%
climb('Happy Go Lucky', 15, person('Barry', 'Drake'), date(11, 9,1996)).
climb('High n Dry',     16, person('Jim', 'Fried'),   date(11, 9,1996)).
climb('Roller',         21, person('Barry', 'Drake'), date(15, 9,1996)).
climb('Naturally',      14, person('Barry', 'Drake'), date(11,10,1997)).
climb('The Picnic',     10, person('Dot', 'Kanga'),   date(14, 2,1953)).

later(date(Day1, Month, Year), date(Day2, Month, Year)) :- !,
	Day1 > Day2.
later(date(_, Month1, Year), date(_, Month2, Year)) :- !,
	Month1 > Month2.
later(date(_, _, Year1), date(_, _, Year2)) :-
	Year1 > Year2.

