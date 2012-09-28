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
