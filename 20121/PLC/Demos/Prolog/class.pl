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
	

