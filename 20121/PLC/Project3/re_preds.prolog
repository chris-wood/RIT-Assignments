
%% Testing predicate.

check_answs_solns_aux([],_).
check_answs_solns_aux([Answ|Answs],Solns) :-
        memberchk(Answ,Solns), check_answs_solns_aux(Answs,Solns).
check_answs_solns(Answs,Solns) :-
        length(Answs,N),
        length(Solns,N),
        check_answs_solns_aux(Answs,Solns).

test(Goal,Template,PrTemplate,_) :-
  Template = PrTemplate, write(Goal), write(' '), fail.
test(Goal,Template,_,Solns) :-
  findall(Template,Goal,Answs), (check_answs_solns(Answs,Solns) -> write('passed.\n') ; write('failed.\n')).

test_grnd(Goal,_) :-
  write(Goal), write(' '), fail.
test_grnd(Goal,S) :-
  (once(Goal) -> A = true ; A = false), (A = S -> write('passed.\n') ; write('failed.\n')).


%% Part 3: Regular Expression predicates


%% re_match
%% Regular expression matching
%%  re_match(RE,L)
%%    RE -- input paramter, regular expression
%%    L -- input/output paramter, char list matched by RE
% DEFINE re_match HERE

% The epsilon match
re_match(RE,L) :- 
  RE = epsilon, 
  L = [].

% The char match (match the singleton list)
re_match(RE,[H|T]) :- 
  RE = char(A), 
  length(T,N), 
  N is 0, 
  H = A.

% The seq match
re_match(RE,L) :- 
  RE = seq(RE1,RE2), 
  append(L1,L2,L), 
  re_match(RE1,L1), 
  re_match(RE2,L2).

% The alt match 
re_match(RE,L) :- 
  RE = alt(RE1,RE2), 
  re_match(RE1,L).
re_match(RE,L) :- 
  RE = alt(RE1,RE2), 
  re_match(RE2,L).

% The star match
re_match(RE,L) :- 
  RE = star(RES), 
  L = [].
re_match(RE,L) :- 
  RE = star(RES), 
  append(L1,L2,L), 
  length(L,N), 
  between(0,10,N), 
  L1 \= [], 
  re_match(RES,L1), 
  re_match(RE,L2).

% re_match tests
range(L,H,L) :- L =< H.
range(L,H,N) :- L < H, LX is L + 1, range(LX,H,N).
re_match_fwd_test(M,RE,Solns) :-
        test((range(0,M,N), length(L,N), re_match(RE,L)),L,'L',Solns).
re_match_test_grnd(RE,L,Soln) :-
        test_grnd(re_match(RE,L),Soln).
re_match_test0 :-
        re_match_test_grnd(alt(char(a),star(char(b))),[],true).
re_match_test1 :-
        re_match_test_grnd(alt(char(a),star(char(b))),[a],true).
re_match_test2 :-
        re_match_test_grnd(alt(char(a),star(char(b))),[a,b],false).
re_match_test3 :-
        re_match_test_grnd(alt(char(a),star(char(b))),[a,b,b],false).
re_match_test4 :-
        re_match_test_grnd(alt(char(a),star(char(b))),[b],true).
re_match_test5 :-
        re_match_test_grnd(alt(char(a),star(char(b))),[b,b],true).
re_match_test6 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[],false).
re_match_test7 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[a],true).
re_match_test8 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[b],false).
re_match_test9 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[a,b],true).
re_match_test10 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[a,b,b],true).
re_match_test11 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[a,b,b,c],true).
re_match_test12 :-
        re_match_test_grnd(seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),[a,b,b,c,c],false).
re_match_test13 :-
        re_match_test_grnd(star(seq(char(a),char(b))),[a,b],true).
re_match_simple_tests :-
        re_match_test0, re_match_test1, re_match_test2, re_match_test3, re_match_test4,
        re_match_test5, re_match_test6, re_match_test7, re_match_test8, re_match_test9,
        re_match_test10, re_match_test11, re_match_test12, re_match_test13.
re_match_test14 :-
        re_match_test_grnd(star(star(char(a))),[],true).
re_match_test15 :-
        re_match_test_grnd(star(star(char(a))),[a],true).
re_match_test16 :-
        re_match_test_grnd(star(star(char(a))),[a,a],true).
re_match_test17 :-
        re_match_test_grnd(star(star(char(a))),[a,a,b],false).
re_match_test18 :-
        re_match_test_grnd(star(star(seq(char(a),char(b)))),[a,b,a,b],true).
re_match_adv1_tests :-
        re_match_test14, re_match_test15, re_match_test16, re_match_test17, re_match_test18.
re_match_test19 :-
        re_match_fwd_test(7,alt(char(a),star(char(b))),
                          [[],
                           [a],
                           [b],
                           [b,b],
                           [b,b,b],
                           [b,b,b,b],
                           [b,b,b,b,b],
                           [b,b,b,b,b,b],
                           [b,b,b,b,b,b,b]]).
re_match_test20 :-
        re_match_fwd_test(7,seq(char(a),seq(star(char(b)),alt(char(c),epsilon))),
                          [[a],
                           [a,b],
                           [a,b,b],
                           [a,b,b,b],
                           [a,b,b,b,b],
                           [a,b,b,b,b,b],
                           [a,b,b,b,b,b,b],
                           [a,b,b,b,b,b,c],
                           [a,b,b,b,b,c],
                           [a,b,b,b,c],
                           [a,b,b,c],
                           [a,b,c],
                           [a,c]]).
re_match_test21 :-
        re_match_fwd_test(4,star(alt(char(a),char(b))),
                          [[],
                           [a],
                           [a,a],
                           [a,a,a],
                           [a,a,a,a],
                           [a,a,a,b],
                           [a,a,b],
                           [a,a,b,a],
                           [a,a,b,b],
                           [a,b],
                           [a,b,a],
                           [a,b,a,a],
                           [a,b,a,b],
                           [a,b,b],
                           [a,b,b,a],
                           [a,b,b,b],
                           [b],
                           [b,a],
                           [b,a,a],
                           [b,a,a,a],
                           [b,a,a,b],
                           [b,a,b],
                           [b,a,b,a],
                           [b,a,b,b],
                           [b,b],
                           [b,b,a],
                           [b,b,a,a],
                           [b,b,a,b],
                           [b,b,b],
                           [b,b,b,a],
                           [b,b,b,b]]).
re_match_test22 :-
        re_match_fwd_test(4,seq(star(char(a)),star(char(b))),
                          [[],
                           [a],
                           [a,a],
                           [a,a,a],
                           [a,a,a,a],
                           [a,a,a,b],
                           [a,a,b],
                           [a,a,b,b],
                           [a,b],
                           [a,b,b],
                           [a,b,b,b],
                           [b],
                           [b,b],
                           [b,b,b],
                           [b,b,b,b]]).
re_match_test23 :-
        re_match_fwd_test(8,star(seq(char(a),char(b))),
                          [[],
                           [a,b],
                           [a,b,a,b],
                           [a,b,a,b,a,b],
                           [a,b,a,b,a,b,a,b]]).
re_match_adv2_tests :-
        re_match_test19, re_match_test20, re_match_test21, re_match_test22, re_match_test23.
% Execute the following queries to test your re_match predicate.
% ?- re_match_simple_tests.
% ?- re_match_adv1_tests.
% ?- re_match_adv2_tests.


%% re_reverse
%% Regular expression reversal
%%  re_reverse(RE,RRE)
%%    RE -- input/output paramter, regular expression
%%    RRE -- input/output paramter, reversed regular expression
% DEFINE re_reverse HERE
re_reverse([],[]).
re_reverse(RE1,RE2) :-
  between(0,10,N),
  length(L1,N),
  length(L2,N),
  reverse(L1,L2),
  re_match(RE1,L1),
  re_match(RE2,L2).

% NOTE: no re_reverse tests.
