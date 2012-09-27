mortal(X) :- man(X).
man('Chris').

office('Rege', bldg_rm(70,3557)).
office('Fluet', bldg_rm(70,3555)).
office('Kwon', bldg_rm(70,3553)).
office('Duncan', bldg_rm(70,3551)).

office_neighbors(X, Y) :- 
	office(X, bldg_rm(B, NX)), % X has an office
	office(Y, bldg_rm(B, NY)), % Y has an office
%	BX = BY, % X and Y have offices in the same building
	2 =:= abs(NX - NY). % "abs(-(NX,NY)), =:= equal and in arithmeti, requires terms to be ground terms...

% X =/ Y, for inequality of two terms

%%%%%%%%
% Lists

list_is_list([]).
list_is_list([X|L]) :- list_is_list(L).

%list_length(L, N).
list_length([],0).
list_length([X|L],M) :- list_length(L,N), M is N+1.

list_append([], L, L).
list_append([X1|L2],L2,[X1|L3]) :- list_append(L1,L2,L3).
%list_append(L1,L2,L3)

list_member(X, [X|_]). % this is an axiom, x is a member of the list that starts with x...
list_member(X, [_|L]) :- list_member(X,L). % CLOSED WORLD ASSUMPTION - EVERYTHING WE DEFINE IN RULES/AXIOMS IS ALL TRUTH - NOTHING ELSE CAN BE PROVEN BEYOND THESE

list_last([X],X).
list_last([_|L],X) :- list_last(L,X).

list_sorted([]).
list_sorted([X]).
list_sorted([X1,X2|L]) :-
	X1 =< X2, list_sorted([X2|L]).

% This doesn't work, because Prolog is fucking retarded.
list_sort(L,SL) :-
	list_sorted(SL), permutation(L, SL).

