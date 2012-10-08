
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


%% Part 1: List predicates

list_is_list([]).
list_is_list([_|T]) :- list_is_list(T).

list_length([],0).
list_length([_|T],LL) :- list_length(T,LT), LL is LT+1.

list_append([],L,L).
list_append([H|L1],L2,[H|L3]) :- list_append(L1,L2,L3).

list_member(X,[X|_]).
list_member(X,[_|T]) :- list_member(X,T).

list_zip([],_,[]).
list_zip(_,[],[]).
list_zip([H1|T1],[H2|T2],[[H1,H2]|T3]) :- list_zip(T1,T2,T3).

list_sorted([]).
list_sorted([_]).
list_sorted([X1,X2|T]) :-
        X1 =< X2, list_sorted([X1|T]).


%% list_sum
% DEFINE list_sum HERE
list_sum([],0).
list_sum([X|T],N) :- list_sum(T,NN), N is NN+X.

%% list_sum tests
list_sum_test(L,Solns) :-
        test(list_sum(L,N),N,'N',Solns).
list_sum_test9 :- list_sum_test([3,-9,8,7,-4,-9,-6,4,-6,-7,-6,-1,-4,-5,-5,6,-4,7,8,-3],[-26]).
list_sum_test8 :- list_sum_test([-10,-3,-7,-6,-6,-4,5,10,3,2,1,-9,-1,-8,-2],[-35]).
list_sum_test7 :- list_sum_test([-1,-1,-6,-3,6,6,1,3,3,-5],[3]).
list_sum_test6 :- list_sum_test([0,3,7,0,10,2,-3,-10,9,3],[21]).
list_sum_test5 :- list_sum_test([1,2,3,4,5],[15]).
list_sum_test4 :- list_sum_test([1,2,3,4],[10]).
list_sum_test3 :- list_sum_test([1,2,3],[6]).
list_sum_test2 :- list_sum_test([1,2],[3]).
list_sum_test1 :- list_sum_test([1],[1]).
list_sum_test0 :- list_sum_test([],[0]).
list_sum_tests :-
        list_sum_test0, list_sum_test1, list_sum_test2, list_sum_test3, list_sum_test4,
        list_sum_test5, list_sum_test6, list_sum_test7, list_sum_test8, list_sum_test9.
% Execute the following query to test your list_sum predicate.
% ?- list_sum_tests.


%% list_avg
% DEFINE list_avg HERE
list_avg(L,N) :- list_sum(L,M), list_length(L, LL), LL =\= 0, N is M/LL.

%% list_avg tests
list_avg_test(L,Solns) :-
        test(list_avg(L,N),N,'N',Solns).
list_avg_test9 :- list_avg_test([3,-9,8,7,-4,-9,-6,4,-6,-7,-6,-1,-4,-5,-5,6,-4,7,8,-3],[-1.3]).
list_avg_test8 :- A is -(2 + (1 / 3)), list_avg_test([-10,-3,-7,-6,-6,-4,5,10,3,2,1,-9,-1,-8,-2],[A]).
list_avg_test7 :- list_avg_test([-1,-1,-6,-3,6,6,1,3,3,-5],[0.3]).
list_avg_test6 :- list_avg_test([0,3,7,0,10,2,-3,-10,9,3],[2.1]).
list_avg_test5 :- A is 3 / 1, list_avg_test([1,2,3,4,5],[A]).
list_avg_test4 :- list_avg_test([1,2,3,4],[2.5]).
list_avg_test3 :- A is 2 / 1, list_avg_test([1,2,3],[A]).
list_avg_test2 :- list_avg_test([1,2],[1.5]).
list_avg_test1 :- A is 1 / 1, list_avg_test([1],[A]).
list_avg_test0 :- list_avg_test([],[]).
list_avg_tests :-
        list_avg_test0, list_avg_test1, list_avg_test2, list_avg_test3, list_avg_test4,
        list_avg_test5, list_avg_test6, list_avg_test7, list_avg_test8, list_avg_test9.
% Execute the following query to test your list_avg predicate.
% ?- list_avg_tests.


%% list_swizzle
% DEFINE list_swizzle HERE
list_swizzle([],[],[]).
list_swizzle([H1|L1],[],[H3|L3]) :- list_swizzle(L1,[],L3), H1 = H3.
list_swizzle([],[H2|L2],[H3|L3]) :- list_swizzle([],L2,L3), H2 = H3.
list_swizzle([H1|L1],[H2|L2],[H13|[H23|L3]]) :- list_swizzle(L1,L2,L3), H1 = H13, H2 = H23.

%% list_prod tests
list_swizzle_fwd_test(L1,L2,Solns) :-
        test(list_swizzle(L1,L2,LS),LS,'LS',Solns).
list_swizzle_rev_test(LS,Solns) :-
        test((list_swizzle(L1,L2,LS),L1L2=[L1,L2]),L1L2,'L1L2',Solns).
list_swizzle_test9 :- list_swizzle_rev_test([a,b,c,d,e,f],[[[], [a, b, c, d, e, f]],[[a, b, c, d, e, f], []],[[a], [b, c, d, e, f]],[[a, c, d, e, f], [b]],[[a, c], [b, d, e, f]],[[a, c, e, f], [b, d]],[[a, c, e], [b, d, f]]]).
list_swizzle_test8 :- list_swizzle_rev_test([a],[[[a],[]],[[],[a]]]).
list_swizzle_test7 :- list_swizzle_rev_test([],[[[],[]]]).
list_swizzle_test6 :- list_swizzle_fwd_test([a,b,c,d],[e,f],[[a,e,b,f,c,d]]).
list_swizzle_test5 :- list_swizzle_fwd_test([a,b],[c,d,e,f],[[a,c,b,d,e,f]]).
list_swizzle_test4 :- list_swizzle_fwd_test([a,b,c],[d,e,f],[[a,d,b,e,c,f]]).
list_swizzle_test3 :- list_swizzle_fwd_test([a],[b],[[a,b]]).
list_swizzle_test2 :- list_swizzle_fwd_test([],[b],[[b]]).
list_swizzle_test1 :- list_swizzle_fwd_test([a],[],[[a]]).
list_swizzle_test0 :- list_swizzle_fwd_test([],[],[[]]).
list_swizzle_tests :-
        list_swizzle_test0, list_swizzle_test1, list_swizzle_test2,
        list_swizzle_test3, list_swizzle_test4, list_swizzle_test5,
        list_swizzle_test6, list_swizzle_test7, list_swizzle_test8,
        list_swizzle_test9.
% Execute the following query to test your list_swizzle predicate.
% ?- list_swizzle_tests.


%% list_partition
% DEFINE list_partition HERE
list_partition([],[]).

% Try it with concatenation...
list_partition(T,[L1|L2]) :- 
  T = L1,
  L2 = [],
  L1 \= [].

  %list_length(L1,L1N),
  %list_length(L2,L2N),
  %L1N \= 0,
  %L2N = 0.

list_partition(T,[L1|L2]) :- 
  %list_length(T1,T1N),
  %list_length(T2,T2N),
  %T1N \= 0,
  %T2N \= 0,

  list_append(T1,T2,T),
  T1 \= [],
  %list_length(T2,T2N),
  %T2N \= 0,
  T2 \= [],
  T \= [],
  L1 = T1,
  list_partition(T2,L2).

%list_partition(L,[[a],[b],[c],[d]])

  %list_append(L1,L2,[T1|T2]),
  %L1 \= [],  
  %T1 \= [], 
  %list_partition(T1,L1),
  %list_partition(T2,L2).

%% list_partition tests
list_partition_fwd_test(L,Solns) :-
        test(list_partition(L,P),P,'P',Solns).
list_partition_rev_test(P,Solns) :-
        test(list_partition(L,P),L,'L',Solns).
list_partition_test0 :- list_partition_fwd_test([],[[]]).
list_partition_test1 :- list_partition_fwd_test([a],[[[a]]]).
list_partition_test2 :- list_partition_fwd_test([a,b],[[[a], [b]], [[a, b]]]).
list_partition_test3 :- list_partition_fwd_test([a,b,c,d],[[[a], [b], [c], [d]], [[a], [b], [c, d]], [[a], [b, c], [d]], [[a], [b, c, d]], [[a, b], [c], [d]], [[a, b], [c, d]], [[a, b, c], [d]], [[a, b, c, d]]]).
list_partition_test4 :- list_partition_fwd_test([1,2,3,4],[[[1], [2], [3], [4]], [[1], [2], [3, 4]], [[1], [2, 3], [4]], [[1], [2, 3, 4]], [[1, 2], [3], [4]], [[1, 2], [3, 4]], [[1, 2, 3], [4]], [[1, 2, 3, 4]]]).
list_partition_test5 :- list_partition_fwd_test([a,b,c,a],[[[a], [b], [c], [a]], [[a], [b], [c, a]], [[a], [b, c], [a]], [[a], [b, c, a]], [[a, b], [c], [a]], [[a, b], [c, a]], [[a, b, c], [a]], [[a, b, c, a]]]).
list_partition_test6 :- list_partition_rev_test([[a],[b],[c],[d]],[[a,b,c,d]]).
list_partition_test7 :- list_partition_rev_test([[a,b],[c,d],[e]],[[a,b,c,d,e]]).
list_partition_test8 :- list_partition_rev_test([],[[]]).
list_partition_test9 :- list_partition_rev_test([[1],[2],[3,4,5]],[[1, 2, 3, 4, 5]]).
list_partition_tests :-
        list_partition_test0, list_partition_test1, list_partition_test2, list_partition_test3, list_partition_test4,
        list_partition_test5, list_partition_test6, list_partition_test7, list_partition_test8, list_partition_test9.
% Execute the following query to test your list_partition predicate.
% ?- list_partition_tests.



%% list_mergesort
% DEFINE list_mergesort HERE

%% list_mergesort tests
list_mergesort_test(L,Solns) :-
        test(list_mergesort(L,LS),LS,'LS',Solns).
list_mergesort_test0 :- list_mergesort_test([],[[]]).
list_mergesort_test1 :- list_mergesort_test([1],[[1]]).
list_mergesort_test2 :- list_mergesort_test([5,4,3,2,1],[[1,2,3,4,5]]).
list_mergesort_test3 :- list_mergesort_test([-45,-7,-26,7,-18,-35,-45,31,2,-24,-31,-14,-47,-39,-12,25,-33],
                                            [[-47,-45,-45,-39,-35,-33,-31,-26,-24,-18,-14,-12,-7,2,7,25,31]]).
list_mergesort_test4 :- list_mergesort_test([4,3,2,1,2,3,4],[[1,2,2,3,3,4,4]]).
list_mergesort_test5 :- list_mergesort_test([-15,0,-48,-31,37,4,-10,22,-42,34,-6,-28,23,-45,-20,-4,-10,33,47,41,-10,-48,
                                             -27,-41,-42,36,-42,25,17,-29,-18,-4,-31,-44,-46,1,-1,18,18,18,-36,21,33,
                                             -20,49,-10,22,25,-32,-17,35,2,48,9,9,44,-17,-15,31,17,-38,3,-5,-25,4,45,12,
                                             -38,-34,-35,44,22,48,-36,-24,0,17,28,-24,-20,12,-2,-12,41,35,27,-16,-39,46,
                                             39,-5,-7,33,-18,9,-22,-9,-46,-14,12,-4,37,13,35,4,46,-29,26,41,-49,-9,-9,
                                             -1,48,38,-18,-37,12,34,7,-23,42,45,22,-22,3,-9,-41,-12,-5,41,40,42,-49,28,
                                             -1,47,-33,33,12,-23,-35,-3,-31,-22,1,24,27,-35,25,-1,-44,-14,-41,-28,8,14,
                                             -22,4,-16,-33,-14,43,-22,17,5,1,-47,10,28,-40,41,41,20,-9,31,-26,-19,5,-26,
                                             -12,-41,25,-6,-38,-25,8,44,-30,19,14,48,29,-39,-43,20,-31,44,41,33],
                                            [[-49,-49,-48,-48,-47,-46,-46,-45,-44,-44,-43,-42,-42,-42,-41,-41,-41,-41,
                                              -40,-39,-39,-38,-38,-38,-37,-36,-36,-35,-35,-35,-34,-33,-33,-32,-31,-31,
                                              -31,-31,-30,-29,-29,-28,-28,-27,-26,-26,-25,-25,-24,-24,-23,-23,-22,-22,
                                              -22,-22,-22,-20,-20,-20,-19,-18,-18,-18,-17,-17,-16,-16,-15,-15,-14,-14,
                                              -14,-12,-12,-12,-10,-10,-10,-10,-9,-9,-9,-9,-9,-7,-6,-6,-5,-5,-5,-4,-4,-4,
                                              -3,-2,-1,-1,-1,-1,0,0,1,1,1,2,3,3,4,4,4,4,5,5,7,8,8,9,9,9,10,12,12,12,12,
                                              12,13,14,14,17,17,17,17,18,18,18,19,20,20,21,22,22,22,22,23,24,25,25,25,25,
                                              26,27,27,28,28,28,29,31,31,33,33,33,33,33,34,34,35,35,35,36,37,37,38,39,40,
                                              41,41,41,41,41,41,41,42,42,43,44,44,44,44,45,45,46,46,47,47,48,48,48,48,49]]
                                           ).
list_mergesort_tests :-
        list_mergesort_test0, list_mergesort_test1, list_mergesort_test2, list_mergesort_test3, list_mergesort_test4,
        list_mergesort_test5.
% Execute the following query to test your list_mergesort predicate.
% ?- list_mergesort_tests.
