% trigger(+Events, -Goals): Takes a list of events, each of the form 
%   junk(X,Y,S), and computes the corresponding list of goals for the agent, 
%   each of the form goal(X,Y,S).
% 

trigger([], []).
trigger([junk(X, Y, S)|Tail], [goal(X, Y, S)|Goals]) :-
    trigger(Tail, Goals).

% incorporate_goals(+Goals, +Belifes, +Intentions, -Intentions1): Takes Goals list 
%   and inserts only the new goals into the Intentions list immediatly before 
%   an intention with a goal of a lower value. By lower value first the Score
%   is compared then the Manhattan distance if the scores are the same.
%   
%   The plan associated with each new goal is the empty plan.
%

incorporate_goals([], _, Intentions, Intentions).  % Base case, no more Goals.

incorporate_goals([Goal|Tail], Belife, Intentions, Intentions1) :-
    % Goal is already in the Intentions list so skip it.
    is_member(Goal, Intentions),
    incorporate_goals(Tail, Belife, Intentions, Intentions1).

incorporate_goals([Goal|Tail], Belife, Intentions, Intentions1) :-
    % we only insert if its not already in the Intentions list.
    not(is_member(Goal, Intentions)),
    insert_goal(Goal, Intentions, Belife, UpdatedIntentions),
    incorporate_goals(Tail, Belife, UpdatedIntentions, Intentions1).

% insert_goal(+Goal, +Intentions, +Belife, -Intentions1): insert the Goal, as an 
%   Intention i.e. [goal, plan], into the Intentions list before the Plan with
%   a goal less than it (not greater than for decendig order).

insert_goal(Goal, [Intent|Intentions], Belife, [Intent|Intentions1]):-
    not(gt(Goal, Intent, Belife)), !,
    insert_goal(Goal, Intentions, Belife, Intentions1).

insert_goal(X, Intentions, _, [[X, []]|Intentions]).

% is_member(+Goal, +Intentions): Check weather a given Goal is in the Intentions
%   list. Each item in the Inteneiotns list is a two member list if the format
%   [Goal, Plan]. The Plan is a list of actions.
%

is_member(Goal, [Head|_]) :-
    member(Goal, Head).

is_member(Goal, [Head|Tail]) :-
    not(member(Goal, Head)),
	is_member(Goal, Tail).

% gt(+Goal, +Plan, -Belife): Goal is greater-than Plan (i.e. Goal1 > [Goal2|_]).
%   The Goal is compared to the goal in the head of the Plan list and is greater
%   if the Score (3rd param of goal) is greater, or if Scores are equal, the one
%   with the shortest distance to the Belife.
%   Note: The greater-than signs have been reversed as we want the list in 
%   decending order.

gt(goal(_, _, S1), [goal(_, _, S2)|_], _) :-
    S1 > S2.    % Compare scores.

gt(goal(X1, Y1, S1), [goal(X2, Y2, S2)|_], [at(X, Y)|_]) :-
    S1 == S2,
    distance((X, Y), (X1, Y1), D1),
    distance((X, Y), (X2, Y2), D2),
    D1 < D2.    % Comapre distances to Belife.

% select_action(+Beliefs, +Intentions, -Intentions1, -Action): Selects the next 
%   action for the agent to perform from the list of Intentions. If there are
%   none then it moves in the Y direction my 1 (just as good as random?).
%

% If the intentions are empty move towards the middle (5,5) and two-step.
select_action([at(5, 5)], [], [], move(6, 5)).
select_action([at(X, Y)], [], [], move(Xnew, Ynew)) :-
    X < 5,
    Xnew is X + 1,
    Ynew = Y
    ;
    X > 5,
    Xnew is X -1,
    Ynew = Y
    ;
    Y < 5,
    Ynew is Y + 1,
    Xnew = X
    ;
    Y > 5,
    Ynew is Y - 1,
    Xnew = X.

% If the action is good, use it and updated the Intentions list...
select_action(Belifes, [Intent|Tail], [[Goal, NextActions]|Tail], Action) :-
    decompose_intention(Intent, Goal, [Action|NextActions]),
    applicable(Belifes, Action).

% ... otherwise actions is not applicable so create a new Plan for the Goal.
select_action(Belifes, [Intent|Tail], [[Goal, Plan]|Tail], Action) :-
    decompose_intention(Intent, Goal, [BadAction|_]),
    not(applicable(Belifes, BadAction)),
    new_plan(Goal, Belifes, NewPlan),
    next_action(NewPlan, Plan, Action).

% next_action(+ExistingPlan, -Plan, -Action): Pops the first action off 
%   ExistingPlan and returns the Plan without it and the first Action.
%

next_action([Action|Plan], Plan, Action).

% decompose_intention(+Intention, -Goal, -Plan): Extract Goal and Plan from 
%   Intention.
%

decompose_intention([Goal|Plan], Goal, Plan).

% new_plan(+Goal, +Belifes, -Plan): Generate a list of move() actions ending with a 
%   pickup() action based on where the robot is at() currently.
%

new_plan(Goal, Belifes, Plan) :-
    new_plan(Goal, Belifes, [], Plan).

new_plan(goal(X, Y, _), [at(X, Y)], PartialPlan, Plan) :-
    reverse([pickup(X, Y)|PartialPlan], Plan).

new_plan(Goal, [at(X, Y)], PartialPlan, Plan) :-
    vaild_move(X, Y, move(Xnew, Ynew)),
    h(move(Xnew, Ynew), Goal, at(X, Y)),
    new_plan(Goal, [at(Xnew, Ynew)], [move(Xnew, Ynew)|PartialPlan], Plan).

% h(+Move, +Goal, +Belife): Heuristic function to determine weather a Move is in
%   the right direction or not.
%   Since the move distance can only be 1 or -1 this is more or less boolean.
%

h(move(X, Y), goal(Xg, Yg, _), at(Xr, Yr)) :-
    % Move has to be closer to the Goal than current robot position.
    distance((X, Y), (Xg, Yg), Dm),
    distance((Xr, Yr), (Xg, Yg), Dr),
    Dm < Dr.

% vaild_move(+X, +Y, -Move): Determin all valid moves for a given X, Y coordinate.
%

vaild_move(X, Y, Move) :-
    Dx is X +1,
    Move = move(Dx, Y)
    ;
    Dx is X - 1,
    Move = move(Dx, Y)
    ;
    Dy is Y + 1,
    Move = move(X, Dy)
    ;
    Dy is Y - 1,
    Move = move(X, Dy).

% reverse(+List, -Reverse)
% reverse(+List, ?PartReversed, -Reversed): Reversed is obtained by adding the 
%   elements of List in reverse order to PartReversed.
%   See Bratko, 3rd Ed. p.188

reverse(List, Reversed) :-
    reverse(List, [], Reversed).

reverse([], Reversed, Reversed).

reverse([X|Rest], PartReversed, TotalReversed) :-
    reverse(Rest, [X|PartReversed], TotalReversed).

% update_beliefs(+Observation, @Beliefs, -Beliefs1): update robots Belifes based 
%   on Observations. Replace the old at() with the new at().

update_beliefs(at(X, Y), _, [at(X,Y)]).

update_beliefs(_, Belifes, Belifes).    % ignore cleaned() observations.

% update_intentions(+Observation, +Intentions, -Intentions1): Update intentions 
%   based on Observations. Remove the goal once the junk has been cleaned. 
%   Assuming its still the last goal to have been reached.

update_intentions(cleaned(X, Y), [[goal(X, Y, _)|_]|Intentions1], Intentions1).

update_intentions(_, Intentions, Intentions). % catch the rest to stop backtracking.
