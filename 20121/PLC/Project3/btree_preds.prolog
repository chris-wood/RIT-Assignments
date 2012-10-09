
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


%% Part 2: Binary Tree predicates

%% Example binary trees.
btree_ex0(leaf).
btree_ex1(node(leaf,99,leaf)).
btree_ex2(node(node(leaf,9,leaf),99,node(leaf,999,leaf))).
btree_ex3(node(node(node(leaf,9,leaf),20,leaf),30,node(node(leaf,99,leaf),33,node(leaf,1000,leaf)))).
btree_ex4(node(node(node(leaf,9,leaf),99,node(leaf,999,leaf)),9999,node(node(leaf,9,leaf),99,node(leaf,999,leaf)))).
btree_ex5(node(leaf,5,node(leaf,4,node(leaf,3,node(leaf,2,node(leaf,1,node(leaf,0,leaf))))))).
btree_ex6(node(leaf,567,node(leaf,208,node(node(leaf,509,leaf),-442,leaf)))).
btree_ex7(node(leaf,525,node(leaf,609,leaf))).
btree_ex8(node(leaf,468,node(node(node(leaf,873,node(leaf,315,node(leaf,825,node(leaf,54,node(leaf,885,leaf))))),-34,node(leaf,248,leaf)),-66,node(leaf,456,leaf)))).
btree_ex9(node(node(leaf,-696,leaf),-930,node(leaf,208,node(leaf,-364,node(node(leaf,484,leaf),-1003,node(node(node(leaf,189,node(node(node(leaf,-75,leaf),214,leaf),872,leaf)),0,node(leaf,-450,leaf)),937,leaf)))))).
btree_ex10(node(node(node(leaf,3,leaf),3,node(leaf,3,leaf)),3,node(node(leaf,3,leaf),3,node(leaf,3,leaf)))).

%% Verify binary tree structure;
%% satisfied when the input parameter is a binary tree.
%%  is_btree(Z)
%%    Z -- input parameter
btree_is_btree(leaf).
btree_is_btree(node(BTL,_,BTR)) :-
        btree_is_btree(BTL), btree_is_btree(BTR).


%% btree_height
%% Binary tree height.
%%  btree_height(BT,D)
%%   BT -- input parameter, binary tree
%%   D -- output parameter, integer height of BT
btree_height(BT,0) :- 
    btree_is_btree(BT), 
    BT = leaf.
btree_height(BT,H) :- 
    btree_is_btree(BT), 
    BT = node(BTL,_,BTR), 
    btree_height(BTL,HL), 
    btree_height(BTR, HR), 
    HL >= HR, 
    H is 1 + HL.
btree_height(BT,H) :- 
    btree_is_btree(BT), 
    BT = node(BTL,_,BTR), 
    btree_height(BTL,HL), 
    btree_height(BTR, HR),
    HR > HL, 
    H is 1 + HR.

%% btree_height tests
btree_height_fwd_test(BT,Solns) :-
        test(btree_height(BT,N),N,'N',Solns).
btree_height_rev_test(N,Solns) :-
        test(btree_height(BT,N),BT,'BT',Solns).
btree_height_test0 :-
        btree_ex0(BT), btree_height_fwd_test(BT,[0]).
btree_height_test1 :-
        btree_ex1(BT), btree_height_fwd_test(BT,[1]).
btree_height_test2 :-
        btree_ex2(BT), btree_height_fwd_test(BT,[2]).
btree_height_test3 :-
        btree_ex3(BT), btree_height_fwd_test(BT,[3]).
btree_height_test4 :-
        btree_ex4(BT), btree_height_fwd_test(BT,[3]).
btree_height_test5 :-
        btree_ex5(BT), btree_height_fwd_test(BT,[6]).
btree_height_test6 :-
        btree_ex6(BT), btree_height_fwd_test(BT,[4]).
btree_height_test7 :-
        btree_ex7(BT), btree_height_fwd_test(BT,[2]).
btree_height_test8 :-
        btree_ex8(BT), btree_height_fwd_test(BT,[8]).
btree_height_test9 :-
        btree_ex9(BT), btree_height_fwd_test(BT,[10]).
btree_height_tests :-
        btree_height_test0, btree_height_test1, btree_height_test2, btree_height_test3, btree_height_test4,
        btree_height_test5, btree_height_test6, btree_height_test7, btree_height_test8, btree_height_test9.
% Execute the following query to test your btree_height predicate.
% ?- btree_height_tests.


%% btree_deepest
%% Binary tree deepest element; satisfied when the second paramter is
%% an element of the first paramter that occurs deepest in the tree.
%%  btree_deepest(BT,X)
%%   BT -- input parameter, binary tree
%%   X -- input/output paramter, element

% Rule for no children
btree_deepest(BT,D) :-  
    btree_is_btree(BT), 
    BT = node(BTL,X,BTR), 
    BTL = leaf, 
    BTR = leaf, 
    D is X, !.

% Rules for one leaf and one node child
btree_deepest(BT,D) :- 
    btree_is_btree(BT), 
    BT = node(BTL,X,BTR), 
    BTL = leaf, 
    btree_deepest(BTR,DR), 
    D is DR.
btree_deepest(BT,D) :- 
    btree_is_btree(BT),
    BT = node(BTL,X,BTR), 
    BTR = leaf, 
    btree_deepest(BTL,DL), 
    D is DL.

% Rules for two node children
btree_deepest(BT,D) :- 
    btree_is_btree(BT), 
    BT = node(BTL,X,BTR), 
    BTL \= leaf, 
    BTR \= leaf, 
    btree_height(BTL,HL), 
    btree_height(BTR,HR), 
    btree_deepest(BTL,DL), 
    HL >= HR, 
    D is DL.
btree_deepest(BT,D) :- 
    btree_is_btree(BT), 
    BT = node(BTL,X,BTR), 
    BTL \= leaf, 
    BTR \= leaf, 
    btree_height(BTL,HL), 
    btree_height(BTR,HR), 
    btree_deepest(BTR,DR), 
    HR >= HL, 
    D is DR.

%% btree_deepest tests
btree_deepest_fwd_test(BT,Solns) :-
        test(btree_deepest(BT,X),X,'X',Solns).
btree_deepest_test0 :-
        btree_ex0(BT), btree_deepest_fwd_test(BT,[]).
btree_deepest_test1 :-
        btree_ex1(BT), btree_deepest_fwd_test(BT,[99]).
btree_deepest_test2 :-
        btree_ex2(BT), btree_deepest_fwd_test(BT,[9,999]).
btree_deepest_test3 :-
        btree_ex3(BT), btree_deepest_fwd_test(BT,[9,99,1000]).
btree_deepest_test4 :-
        btree_ex4(BT), btree_deepest_fwd_test(BT,[9,999,9,999]).
btree_deepest_test5 :-
        btree_ex5(BT), btree_deepest_fwd_test(BT,[0]).
btree_deepest_test6 :-
        btree_ex6(BT), btree_deepest_fwd_test(BT,[509]).
btree_deepest_test7 :-
        btree_ex7(BT), btree_deepest_fwd_test(BT,[609]).
btree_deepest_test8 :-
        btree_ex8(BT), btree_deepest_fwd_test(BT,[885]).
btree_deepest_test9 :-
        btree_ex9(BT), btree_deepest_fwd_test(BT,[-75]).
btree_deepest_tests :-
        btree_deepest_test0, btree_deepest_test1, btree_deepest_test2, btree_deepest_test3, btree_deepest_test4,
        btree_deepest_test5, btree_deepest_test6, btree_deepest_test7, btree_deepest_test8, btree_deepest_test9.
% Execute the following query to test your btree_deepest predicate.
% ?- btree_deepest_tests.


%% btree_balanced
%% Binary tree balanced.
%%  btree_balanced(BT)
%%   BT -- input parameter, binary tree

% Rule for leaf
btree_balanced(BT) :- 
    btree_is_btree(BT), 
    BT = leaf.

% Rule for other cases (taking into account height += 1 delta)
btree_balanced(BT) :- 
    btree_is_btree(BT), 
    BT = node(BTL,_,BTR), 
    btree_height(BTL,HL), 
    btree_height(BTR,HR), 
    HR is HL - 1, 
    btree_balanced(BTL), 
    btree_balanced(BTR).
btree_balanced(BT) :- 
    btree_is_btree(BT), 
    BT = node(BTL,_,BTR), 
    btree_height(BTL,HL), 
    btree_height(BTR,HR), 
    HR is HL + 1, 
    btree_balanced(BTL), 
    btree_balanced(BTR).
btree_balanced(BT) :- 
    btree_is_btree(BT),
    BT = node(BTL,_,BTR), 
    btree_height(BTL,HL), 
    btree_height(BTR,HR), 
    HR = HL, 
    btree_balanced(BTL), 
    btree_balanced(BTR).

%% btree_balanced tests
btree_balanced_test_grnd(BT,Soln) :-
        test_grnd(btree_balanced(BT),Soln).
btree_balanced_test0 :-
        btree_ex0(BT), btree_balanced_test_grnd(BT,true).
btree_balanced_test1 :-
        btree_ex1(BT), btree_balanced_test_grnd(BT,true).
btree_balanced_test2 :-
        btree_ex2(BT), btree_balanced_test_grnd(BT,true).
btree_balanced_test3 :-
        btree_ex3(BT), btree_balanced_test_grnd(BT,true).
btree_balanced_test4 :-
        btree_ex4(BT), btree_balanced_test_grnd(BT,true).
btree_balanced_test5 :-
        btree_ex5(BT), btree_balanced_test_grnd(BT,false).
btree_balanced_test6 :-
        btree_ex6(BT), btree_balanced_test_grnd(BT,false).
btree_balanced_test7 :-
        btree_ex7(BT), btree_balanced_test_grnd(BT,true).
btree_balanced_test8 :-
        btree_ex8(BT), btree_balanced_test_grnd(BT,false).
btree_balanced_test9 :-
        btree_ex9(BT), btree_balanced_test_grnd(BT,false).
btree_balanced_tests :-
        btree_balanced_test0, btree_balanced_test1, btree_balanced_test2, btree_balanced_test3, btree_balanced_test4,
        btree_balanced_test5, btree_balanced_test6, btree_balanced_test7, btree_balanced_test8, btree_balanced_test9.
% Execute the following query to test your btree_balanced predicate.
% ?- btree_balanced_tests.
 
%% btree_subtree
%% Binary tree subtrees; satisfied when the second paramter is a
%% subtree of the first paramter.
%%  btree_subtree(BT,BTS)
%%   BT -- input/output parameter, binary tree
%%   BTS -- input/output parameter, binary tree

% Two leaves
btree_subtree(BT1,BT2) :- 
    BT2 = leaf. % always true, no matter what BT1 is

% No children are leaves
btree_subtree(BT1,BT2) :-
    BT1 = node(BT1L,X,BT1R),
    BT2 = node(BT2L,Y,BT2R),
    BT1L = node(_,_,_),
    BT1R = node(_,_,_),
    btree_subtree(BT1L,BT2L),
    btree_subtree(BT1R,BT2R),
    X = Y.

% Right child is a leaf
btree_subtree(BT1,BT2) :-
    BT1 = node(BT1L,X,BT1R),
    BT2 = node(BT2L,Y,BT2R),
    BT1L = node(_,_,_),
    BT1R = leaf,
    btree_subtree(BT1L,BT2L),
    btree_subtree(BT1R,BT2R),
    X = Y.

% Left child is a leaf
btree_subtree(BT1,BT2) :-
    BT1 = node(BT1L,X,BT1R),
    BT2 = node(BT2L,Y,BT2R),
    BT1L = leaf,
    BT1R = node(_,_,_),
    btree_subtree(BT1L,BT2L),
    btree_subtree(BT1R,BT2R),
    X = Y.

% Both children are leaves
btree_subtree(BT1,BT2) :-
    BT1 = node(BT1L,X,BT1R),
    BT2 = node(BT2L,X,BT2R),
    BT1L = leaf,
    BT1R = leaf,
    BT2L = BT1L,
    BT2R = BT1R,
    X = Y.

%% btree_subtree tests
btree_subtree_fwd_test(BT,Solns) :-
        test(btree_subtree(BT,BTS),BTS,'BTS',Solns).
btree_subtree_rev_test(BTS,Solns) :-
        test(btree_subtree(BT,BTS),BT,'BT',Solns).
btree_subtree_test_grnd(BT,BTS,Soln) :-
        test_grnd(btree_subtree(BT,BTS),Soln).
btree_subtree_test0 :-
        btree_ex0(BT), btree_subtree_fwd_test(BT,[leaf]).
btree_subtree_test1 :-
        btree_ex1(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 99, leaf), leaf, leaf]).
btree_subtree_test2 :-
        btree_ex2(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 99, leaf), node(leaf, 99, node(leaf, 999, leaf)), node(node(leaf, 9, leaf), 99, leaf), node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), leaf, node(leaf, 999, leaf), leaf, leaf, leaf, node(leaf, 9, leaf), leaf, leaf]).
btree_subtree_test3 :-
        btree_ex3(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 30, leaf), node(leaf, 30, node(leaf, 33, leaf)), node(leaf, 30, node(leaf, 33, node(leaf, 1000, leaf))), node(leaf, 30, node(node(leaf, 99, leaf), 33, leaf)), node(leaf, 30, node(node(leaf, 99, leaf), 33, node(leaf, 1000, leaf))), node(node(leaf, 20, leaf), 30, leaf), node(node(leaf, 20, leaf), 30, node(leaf, 33, leaf)), node(node(leaf, 20, leaf), 30, node(leaf, 33, node(leaf, 1000, leaf))), node(node(leaf, 20, leaf), 30, node(node(leaf, 99, leaf), 33, leaf)), node(node(leaf, 20, leaf), 30, node(node(leaf, 99, leaf), 33, node(leaf, 1000, leaf))), node(node(node(leaf, 9, leaf), 20, leaf), 30, leaf), node(node(node(leaf, 9, leaf), 20, leaf), 30, node(leaf, 33, leaf)), node(node(node(leaf, 9, leaf), 20, leaf), 30, node(leaf, 33, node(leaf, 1000, leaf))), node(node(node(leaf, 9, leaf), 20, leaf), 30, node(node(leaf, 99, leaf), 33, leaf)), node(node(node(leaf, 9, leaf), 20, leaf), 30, node(node(leaf, 99, leaf), 33, node(leaf, 1000, leaf))), leaf, node(leaf, 33, leaf), node(leaf, 33, node(leaf, 1000, leaf)), node(node(leaf, 99, leaf), 33, leaf), node(node(leaf, 99, leaf), 33, node(leaf, 1000, leaf)), leaf, node(leaf, 1000, leaf), leaf, leaf, leaf, node(leaf, 99, leaf), leaf, leaf, leaf, node(leaf, 20, leaf), node(node(leaf, 9, leaf), 20, leaf), leaf, leaf, node(leaf, 9, leaf), leaf, leaf]).
btree_subtree_test4 :-
        btree_ex4(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 9999, leaf), node(leaf, 9999, node(leaf, 99, leaf)), node(leaf, 9999, node(leaf, 99, node(leaf, 999, leaf))), node(leaf, 9999, node(node(leaf, 9, leaf), 99, leaf)), node(leaf, 9999, node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf))), node(node(leaf, 99, leaf), 9999, leaf), node(node(leaf, 99, leaf), 9999, node(leaf, 99, leaf)), node(node(leaf, 99, leaf), 9999, node(leaf, 99, node(leaf, 999, leaf))), node(node(leaf, 99, leaf), 9999, node(node(leaf, 9, leaf), 99, leaf)), node(node(leaf, 99, leaf), 9999, node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf))), node(node(leaf, 99, node(leaf, 999, leaf)), 9999, leaf), node(node(leaf, 99, node(leaf, 999, leaf)), 9999, node(leaf, 99, leaf)), node(node(leaf, 99, node(leaf, 999, leaf)), 9999, node(leaf, 99, node(leaf, 999, leaf))), node(node(leaf, 99, node(leaf, 999, leaf)), 9999, node(node(leaf, 9, leaf), 99, leaf)), node(node(leaf, 99, node(leaf, 999, leaf)), 9999, node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf))), node(node(node(leaf, 9, leaf), 99, leaf), 9999, leaf), node(node(node(leaf, 9, leaf), 99, leaf), 9999, node(leaf, 99, leaf)), node(node(node(leaf, 9, leaf), 99, leaf), 9999, node(leaf, 99, node(leaf, 999, leaf))), node(node(node(leaf, 9, leaf), 99, leaf), 9999, node(node(leaf, 9, leaf), 99, leaf)), node(node(node(leaf, 9, leaf), 99, leaf), 9999, node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf))), node(node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), 9999, leaf), node(node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), 9999, node(leaf, 99, leaf)), node(node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), 9999, node(leaf, 99, node(leaf, 999, leaf))), node(node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), 9999, node(node(leaf, 9, leaf), 99, leaf)), node(node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), 9999, node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf))), leaf, node(leaf, 99, leaf), node(leaf, 99, node(leaf, 999, leaf)), node(node(leaf, 9, leaf), 99, leaf), node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), leaf, node(leaf, 999, leaf), leaf, leaf, leaf, node(leaf, 9, leaf), leaf, leaf, leaf, node(leaf, 99, leaf), node(leaf, 99, node(leaf, 999, leaf)), node(node(leaf, 9, leaf), 99, leaf), node(node(leaf, 9, leaf), 99, node(leaf, 999, leaf)), leaf, node(leaf, 999, leaf), leaf, leaf, leaf, node(leaf, 9, leaf), leaf, leaf]).
btree_subtree_test5 :-
        btree_ex5(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 5, leaf), node(leaf, 5, node(leaf, 4, leaf)), node(leaf, 5, node(leaf, 4, node(leaf, 3, leaf))), node(leaf, 5, node(leaf, 4, node(leaf, 3, node(leaf, 2, leaf)))), node(leaf, 5, node(leaf, 4, node(leaf, 3, node(leaf, 2, node(leaf, 1, leaf))))), node(leaf, 5, node(leaf, 4, node(leaf, 3, node(leaf, 2, node(leaf, 1, node(leaf, 0, leaf)))))), leaf, node(leaf, 4, leaf), node(leaf, 4, node(leaf, 3, leaf)), node(leaf, 4, node(leaf, 3, node(leaf, 2, leaf))), node(leaf, 4, node(leaf, 3, node(leaf, 2, node(leaf, 1, leaf)))), node(leaf, 4, node(leaf, 3, node(leaf, 2, node(leaf, 1, node(leaf, 0, leaf))))), leaf, node(leaf, 3, leaf), node(leaf, 3, node(leaf, 2, leaf)), node(leaf, 3, node(leaf, 2, node(leaf, 1, leaf))), node(leaf, 3, node(leaf, 2, node(leaf, 1, node(leaf, 0, leaf)))), leaf, node(leaf, 2, leaf), node(leaf, 2, node(leaf, 1, leaf)), node(leaf, 2, node(leaf, 1, node(leaf, 0, leaf))), leaf, node(leaf, 1, leaf), node(leaf, 1, node(leaf, 0, leaf)), leaf, node(leaf, 0, leaf), leaf, leaf, leaf, leaf, leaf, leaf, leaf]).
btree_subtree_test6 :-
        btree_ex6(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 567, leaf), node(leaf, 567, node(leaf, 208, leaf)), node(leaf, 567, node(leaf, 208, node(leaf, -442, leaf))), node(leaf, 567, node(leaf, 208, node(node(leaf, 509, leaf), -442, leaf))), leaf, node(leaf, 208, leaf), node(leaf, 208, node(leaf, -442, leaf)), node(leaf, 208, node(node(leaf, 509, leaf), -442, leaf)), leaf, node(leaf, -442, leaf), node(node(leaf, 509, leaf), -442, leaf), leaf, leaf, node(leaf, 509, leaf), leaf, leaf, leaf, leaf]).
btree_subtree_test7 :-
        btree_ex7(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 525, leaf), node(leaf, 525, node(leaf, 609, leaf)), leaf, node(leaf, 609, leaf), leaf, leaf, leaf]).
btree_subtree_test8 :-
        btree_ex8(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, 468, leaf), node(leaf, 468, node(leaf, -66, leaf)), node(leaf, 468, node(leaf, -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(leaf, -34, leaf), -66, leaf)), node(leaf, 468, node(node(leaf, -34, leaf), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(leaf, -34, node(leaf, 248, leaf)), -66, leaf)), node(leaf, 468, node(node(leaf, -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, leaf), -34, leaf), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, leaf), -34, leaf), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, leaf), -34, node(leaf, 248, leaf)), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, leaf), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, leaf), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, leaf), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, node(leaf, 248, leaf)), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, leaf), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, leaf), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, node(leaf, 248, leaf)), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, leaf), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, leaf), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, node(leaf, 248, leaf)), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, leaf), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, leaf), -66, node(leaf, 456, leaf))), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, node(leaf, 248, leaf)), -66, leaf)), node(leaf, 468, node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf))), leaf, node(leaf, -66, leaf), node(leaf, -66, node(leaf, 456, leaf)), node(node(leaf, -34, leaf), -66, leaf), node(node(leaf, -34, leaf), -66, node(leaf, 456, leaf)), node(node(leaf, -34, node(leaf, 248, leaf)), -66, leaf), node(node(leaf, -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, leaf), -34, leaf), -66, leaf), node(node(node(leaf, 873, leaf), -34, leaf), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, leaf), -34, node(leaf, 248, leaf)), -66, leaf), node(node(node(leaf, 873, leaf), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, leaf), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, leaf), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, node(leaf, 248, leaf)), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, leaf)), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, leaf), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, leaf), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, node(leaf, 248, leaf)), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, leaf), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, leaf), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, node(leaf, 248, leaf)), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, leaf), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, leaf), -66, node(leaf, 456, leaf)), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, node(leaf, 248, leaf)), -66, leaf), node(node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, node(leaf, 248, leaf)), -66, node(leaf, 456, leaf)), leaf, node(leaf, 456, leaf), leaf, leaf, leaf, node(leaf, -34, leaf), node(leaf, -34, node(leaf, 248, leaf)), node(node(leaf, 873, leaf), -34, leaf), node(node(leaf, 873, leaf), -34, node(leaf, 248, leaf)), node(node(leaf, 873, node(leaf, 315, leaf)), -34, leaf), node(node(leaf, 873, node(leaf, 315, leaf)), -34, node(leaf, 248, leaf)), node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, leaf), node(node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), -34, node(leaf, 248, leaf)), node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, leaf), node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), -34, node(leaf, 248, leaf)), node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, leaf), node(node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), -34, node(leaf, 248, leaf)), leaf, node(leaf, 248, leaf), leaf, leaf, leaf, node(leaf, 873, leaf), node(leaf, 873, node(leaf, 315, leaf)), node(leaf, 873, node(leaf, 315, node(leaf, 825, leaf))), node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf)))), node(leaf, 873, node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))))), leaf, node(leaf, 315, leaf), node(leaf, 315, node(leaf, 825, leaf)), node(leaf, 315, node(leaf, 825, node(leaf, 54, leaf))), node(leaf, 315, node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf)))), leaf, node(leaf, 825, leaf), node(leaf, 825, node(leaf, 54, leaf)), node(leaf, 825, node(leaf, 54, node(leaf, 885, leaf))), leaf, node(leaf, 54, leaf), node(leaf, 54, node(leaf, 885, leaf)), leaf, node(leaf, 885, leaf), leaf, leaf, leaf, leaf, leaf, leaf, leaf]).
btree_subtree_test9 :-
        btree_ex9(BT), btree_subtree_fwd_test(BT,[leaf, node(leaf, -930, leaf), node(leaf, -930, node(leaf, 208, leaf)), node(leaf, -930, node(leaf, 208, node(leaf, -364, leaf))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, leaf)))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(leaf, 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, leaf)))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(leaf, 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(leaf, -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, leaf), node(node(leaf, -696, leaf), -930, node(leaf, 208, leaf)), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, leaf))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, leaf)))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(leaf, 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, leaf)))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(leaf, 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf))))), node(node(leaf, -696, leaf), -930, node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))))), leaf, node(leaf, 208, leaf), node(leaf, 208, node(leaf, -364, leaf)), node(leaf, 208, node(leaf, -364, node(leaf, -1003, leaf))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(leaf, 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, leaf))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(leaf, 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf)))), node(leaf, 208, node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)))), leaf, node(leaf, -364, leaf), node(leaf, -364, node(leaf, -1003, leaf)), node(leaf, -364, node(leaf, -1003, node(leaf, 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, leaf), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf))), node(leaf, -364, node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, leaf)), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(leaf, 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, leaf), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf))), node(leaf, -364, node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf))), leaf, node(leaf, -1003, leaf), node(leaf, -1003, node(leaf, 937, leaf)), node(leaf, -1003, node(node(leaf, 0, leaf), 937, leaf)), node(leaf, -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf)), node(leaf, -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)), node(node(leaf, 484, leaf), -1003, leaf), node(node(leaf, 484, leaf), -1003, node(leaf, 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, leaf), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf)), node(node(leaf, 484, leaf), -1003, node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf)), leaf, node(leaf, 937, leaf), node(node(leaf, 0, leaf), 937, leaf), node(node(leaf, 0, node(leaf, -450, leaf)), 937, leaf), node(node(node(leaf, 189, leaf), 0, leaf), 937, leaf), node(node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), 937, leaf), node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), 937, leaf), node(node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf), node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), 937, leaf), node(node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf), node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), 937, leaf), node(node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), 937, leaf), leaf, leaf, node(leaf, 0, leaf), node(leaf, 0, node(leaf, -450, leaf)), node(node(leaf, 189, leaf), 0, leaf), node(node(leaf, 189, leaf), 0, node(leaf, -450, leaf)), node(node(leaf, 189, node(leaf, 872, leaf)), 0, leaf), node(node(leaf, 189, node(leaf, 872, leaf)), 0, node(leaf, -450, leaf)), node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, leaf), node(node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, leaf), node(node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), 0, node(leaf, -450, leaf)), leaf, node(leaf, -450, leaf), leaf, leaf, leaf, node(leaf, 189, leaf), node(leaf, 189, node(leaf, 872, leaf)), node(leaf, 189, node(node(leaf, 214, leaf), 872, leaf)), node(leaf, 189, node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf)), leaf, node(leaf, 872, leaf), node(node(leaf, 214, leaf), 872, leaf), node(node(node(leaf, -75, leaf), 214, leaf), 872, leaf), leaf, leaf, node(leaf, 214, leaf), node(node(leaf, -75, leaf), 214, leaf), leaf, leaf, node(leaf, -75, leaf), leaf, leaf, leaf, leaf, node(leaf, 484, leaf), leaf, leaf, leaf, leaf, leaf, node(leaf, -696, leaf), leaf, leaf]).
btree_subtree_test10 :-
        btree_ex3(BT), btree_subtree_test_grnd(BT,leaf,true).
btree_subtree_test11 :-
        btree_ex3(BT), btree_subtree_test_grnd(BT,node(leaf,9,leaf),true).
btree_subtree_test12 :-
        btree_ex3(BT), btree_subtree_test_grnd(BT,node(leaf,8,leaf),false).
btree_subtree_test13 :-
        btree_ex3(BT), btree_subtree_test_grnd(BT,node(node(leaf,99,leaf),33,node(leaf,1000,leaf)),true).
btree_subtree_test14 :-
        btree_ex3(BT), btree_subtree_test_grnd(BT,node(node(leaf,1000,leaf),33,node(leaf,99,leaf)),false).
btree_subtree_tests :-
        btree_subtree_test0, btree_subtree_test1, btree_subtree_test2, btree_subtree_test3, btree_subtree_test4,
        btree_subtree_test5, btree_subtree_test6, btree_subtree_test7, btree_subtree_test8, btree_subtree_test9,
        btree_subtree_test10, btree_subtree_test11, btree_subtree_test12, btree_subtree_test13, btree_subtree_test14.
% Execute the following query to test your btree_subtree predicate.
% ?- btree_subtree_tests.


%% btree_iso
%% Binary tree isomorphisms; satisifed when the two paramters are
%% isomorphic binary trees.
%%  btree_is(BT1,BT2)
%%   BT1 -- input/output paramter, binary tree
%%   BT2 -- input/output paramter, binary tree
% DEFINE btree_iso HERE

%% btree_iso tests
btree_iso_fwd_test(BT1,Solns) :-
        test(btree_iso(BT1,BT2),BT2,'BT2',Solns).
btree_iso_rev_test(BT2,Solns) :-
        test(btree_iso(BT1,BT2),BT1,'BT1',Solns).
btree_iso_test_grnd(BT1,BT2,Soln) :-
        test_grnd(btree_iso(BT1,BT2),Soln).
btree_iso_test0 :-
        btree_ex0(BT1), btree_ex0(BT2), btree_iso_test_grnd(BT1,BT2,true).
btree_iso_test1 :-
        btree_ex0(BT1), btree_ex1(BT2), btree_iso_test_grnd(BT1,BT2,false).
btree_iso_test2 :-
        btree_ex1(BT1), btree_ex0(BT2), btree_iso_test_grnd(BT1,BT2,false).
btree_iso_test3 :-
        btree_ex1(BT1), btree_ex1(BT2), btree_iso_test_grnd(BT1,BT2,true).
btree_iso_test4 :-
        btree_ex3(BT1), BT2 = leaf, btree_iso_test_grnd(BT1,BT2,false).
btree_iso_test5 :-
        btree_ex3(BT1), BT2 = node(node(node(leaf,99,leaf),33,node(leaf,1000,leaf)),30,node(leaf,20,node(leaf,9,leaf))), btree_iso_test_grnd(BT1,BT2,true).
btree_iso_test6 :-
        btree_ex10(BT1), BT2 = node(node(node(leaf,3,leaf),3,node(leaf,3,leaf)),3,node(node(leaf,3,leaf),3,node(leaf,3,leaf))), btree_iso_test_grnd(BT1,BT2,true).
btree_iso_test7 :-
        btree_ex0(BT1), btree_iso_fwd_test(BT1, [leaf]).
btree_iso_test8 :-
        btree_ex0(BT2), btree_iso_rev_test(BT2, [leaf]).
btree_iso_test9 :-
        btree_ex1(BT1), btree_iso_fwd_test(BT1, [node(leaf,99,leaf)]).
btree_iso_test10 :-
        btree_ex1(BT2), btree_iso_rev_test(BT2, [node(leaf,99,leaf)]).
btree_iso_test11 :-
        btree_ex2(BT1), btree_iso_fwd_test(BT1, [node(node(leaf,9,leaf),99,node(leaf,999,leaf)),node(node(leaf,999,leaf),99,node(leaf,9,leaf))]).
btree_iso_test12 :-
        btree_ex2(BT2), btree_iso_rev_test(BT2, [node(node(leaf,9,leaf),99,node(leaf,999,leaf)),node(node(leaf,999,leaf),99,node(leaf,9,leaf))]).
btree_iso_test13 :-
        btree_ex3(BT1), btree_iso_fwd_test(BT1, [node(node(leaf,20,node(leaf,9,leaf)),30,node(node(leaf,99,leaf),33,node(leaf,1000,leaf))),
                                                 node(node(leaf,20,node(leaf,9,leaf)),30,node(node(leaf,1000,leaf),33,node(leaf,99,leaf))),
                                                 node(node(node(leaf,9,leaf),20,leaf),30,node(node(leaf,99,leaf),33,node(leaf,1000,leaf))),
                                                 node(node(node(leaf,9,leaf),20,leaf),30,node(node(leaf,1000,leaf),33,node(leaf,99,leaf))),
                                                 node(node(node(leaf,99,leaf),33,node(leaf,1000,leaf)),30,node(leaf,20,node(leaf,9,leaf))),
                                                 node(node(node(leaf,99,leaf),33,node(leaf,1000,leaf)),30,node(node(leaf,9,leaf),20,leaf)),
                                                 node(node(node(leaf,1000,leaf),33,node(leaf,99,leaf)),30,node(leaf,20,node(leaf,9,leaf))),
                                                 node(node(node(leaf,1000,leaf),33,node(leaf,99,leaf)),30,node(node(leaf,9,leaf),20,leaf))]).
btree_iso_test14 :-
        btree_ex3(BT2), btree_iso_rev_test(BT2, [node(node(leaf,20,node(leaf,9,leaf)),30,node(node(leaf,99,leaf),33,node(leaf,1000,leaf))),
                                                 node(node(leaf,20,node(leaf,9,leaf)),30,node(node(leaf,1000,leaf),33,node(leaf,99,leaf))),
                                                 node(node(node(leaf,9,leaf),20,leaf),30,node(node(leaf,99,leaf),33,node(leaf,1000,leaf))),
                                                 node(node(node(leaf,9,leaf),20,leaf),30,node(node(leaf,1000,leaf),33,node(leaf,99,leaf))),
                                                 node(node(node(leaf,99,leaf),33,node(leaf,1000,leaf)),30,node(leaf,20,node(leaf,9,leaf))),
                                                 node(node(node(leaf,99,leaf),33,node(leaf,1000,leaf)),30,node(node(leaf,9,leaf),20,leaf)),
                                                 node(node(node(leaf,1000,leaf),33,node(leaf,99,leaf)),30,node(leaf,20,node(leaf,9,leaf))),
                                                 node(node(node(leaf,1000,leaf),33,node(leaf,99,leaf)),30,node(node(leaf,9,leaf),20,leaf))]).
btree_iso_test15 :-
        btree_ex4(BT1), btree_iso_fwd_test(BT1, [node(node(node(leaf,9,leaf),99,node(leaf,999,leaf)),9999,node(node(leaf,9,leaf),99,node(leaf,999,leaf))),
                                                 node(node(node(leaf,9,leaf),99,node(leaf,999,leaf)),9999,node(node(leaf,999,leaf),99,node(leaf,9,leaf))),
                                                 node(node(node(leaf,999,leaf),99,node(leaf,9,leaf)),9999,node(node(leaf,9,leaf),99,node(leaf,999,leaf))),
                                                 node(node(node(leaf,999,leaf),99,node(leaf,9,leaf)),9999,node(node(leaf,999,leaf),99,node(leaf,9,leaf)))]).
btree_iso_test16 :-
        btree_ex4(BT2), btree_iso_rev_test(BT2, [node(node(node(leaf,9,leaf),99,node(leaf,999,leaf)),9999,node(node(leaf,9,leaf),99,node(leaf,999,leaf))),
                                                 node(node(node(leaf,9,leaf),99,node(leaf,999,leaf)),9999,node(node(leaf,999,leaf),99,node(leaf,9,leaf))),
                                                 node(node(node(leaf,999,leaf),99,node(leaf,9,leaf)),9999,node(node(leaf,9,leaf),99,node(leaf,999,leaf))),
                                                 node(node(node(leaf,999,leaf),99,node(leaf,9,leaf)),9999,node(node(leaf,999,leaf),99,node(leaf,9,leaf)))]).
btree_iso_test17 :-
        btree_ex10(BT1), btree_iso_fwd_test(BT1, [node(node(node(leaf,3,leaf),3,node(leaf,3,leaf)),3,node(node(leaf,3,leaf),3,node(leaf,3,leaf)))]).
btree_iso_test18 :-
        btree_ex10(BT2), btree_iso_rev_test(BT2, [node(node(node(leaf,3,leaf),3,node(leaf,3,leaf)),3,node(node(leaf,3,leaf),3,node(leaf,3,leaf)))]).
btree_iso_tests :-
        btree_iso_test0, btree_iso_test1, btree_iso_test2, btree_iso_test3, btree_iso_test4,
        btree_iso_test5, btree_iso_test6, btree_iso_test7, btree_iso_test8, btree_iso_test9,
        btree_iso_test10, btree_iso_test11, btree_iso_test12, btree_iso_test13, btree_iso_test14,
        btree_iso_test15, btree_iso_test16, btree_iso_test17, btree_iso_test18.
% Execute the following query to test your btree_iso predicate.
% ?- btree_iso_tests.
