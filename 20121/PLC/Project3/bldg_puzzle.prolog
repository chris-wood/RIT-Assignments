%% Part 3: Logic puzzle

% Alex, Bret, Chris, Derek, Eddie, Fred, Greg, Harold, and John are
% nine students who live in a three storey building, with three rooms
% on each floor. A room in the West wing, one in the centre, and one
% in the East wing. If you look directly at the building, the left
% side is West and the right side is East. Each student is assigned
% exactly one room. Can you find where each of their rooms is:
%
% 1. Harold does not live on the bottom floor.
% 
% 2. Fred lives directly above John and directly next to Bret (who lives in the West wing).
% 
% 3. Eddie lives in the East wing and one floor higher than Fred.
% 
% 4. Derek lives directly above Fred.
% 
% 5. Greg lives directly above Chris.

students([alex,bret,chris,derek,eddie,fred,greg,harold,john]).

student(S) :-
        students(L), member(S,L).

empty_building(building(floor(_,_,_),floor(_,_,_),floor(_,_,_))).


%% puzzle_soln
% DEFINE puzzle_soln HERE

% The location predicate is used to specify both floor and room number (for room, 1 = west, 2 = center, 3 = east)
location(P,1,1,building(floor(P,_,_),_,_)).
location(P,1,2,building(floor(_,P,_),_,_)).
location(P,1,3,building(floor(_,_,P),_,_)).
location(P,2,1,building(_,floor(P,_,_),_)).
location(P,2,2,building(_,floor(_,P,_),_)).
location(P,2,3,building(_,floor(_,_,P),_)).
location(P,3,1,building(_,_,floor(P,_,_))).
location(P,3,2,building(_,_,floor(_,P,_))).
location(P,3,3,building(_,_,floor(_,_,P))).

% Here is the solution predicate
puzzle_soln(BLDG) :-
	% Empty building to start
	empty_building(BLDG), 

	% Predicates for every student location
	location(harold,HFN,HRN,BLDG), 
	location(fred,FFN,FRN,BLDG), 
	location(john,JFN,JRN,BLDG),
	location(bret,BFN,BRN,BLDG),
	location(eddie,EFN,ERN,BLDG),
	location(derek,DFN,DRN,BLDG),
	location(greg,GFN,GRN,BLDG),
	location(chris,CFN,CRN,BLDG),
	location(alex,AFN,ARN,BLDG), 		% don't forget alex!

	% Now come the rules for each student location
	HFN \= 1, 							% harold does not live on the bottom floor
	FFN is JFN + 1, 					% fred lives directly above john
	FRN = JRN,
	FRN is 2, 							% fred lives directly next to bret (bret lives in the west wing)
	FFN = BFN,
	BRN is 1,							% bret lives in the west wing
	ERN is 3,							% eddie lives in the east wing
	EFN is FFN + 1,						% eddie lives one floor higher than fred
	DFN is FFN + 1,						% derek lives directly above fred 
	DRN = FRN,
	GFN is CFN + 1,						% greg lives directly above chris
	GRN = CRN.
	%true.

	%location(cooper,CN,BLDG), CN \= 1,
	%location(fletcher,FN,BLDG), FN \= 5, FN \= 1,
	%location(smith,SN,BLDG),
	%ADFS is abs(FN - SN), ADFS \= 1,
	%ADFC is abs(FN - CN), ADFC \= 1,
	%location(miller,MN,BLDG),
	%MN > CN,
	%true.
