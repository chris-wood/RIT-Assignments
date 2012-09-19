#lang scheme

;; Utility functions
; function composition
(define (compose f g) (lambda (x) (f (g x))))
; convenience functions for getting list elements
(define get-1st car)
(define get-2nd (compose get-1st cdr))
(define get-3rd (compose get-2nd cdr))
(define get-4th (compose get-3rd cdr))

;; Testing functions
(define (run-test proc check test)
  (let ((name (get-1st test))
        (input (get-2nd test))
        (output (get-3rd test)))
    (if (check (apply proc input) output)
        (display (string-append "Test " name " passed.\n"))
        (display (string-append "Test " name " failed.\n")))))
(define (run-tests proc check tests) (for-each (lambda (test) (run-test proc check test)) tests))

; list for-all
(define (list-for-all p l)
  (if (null? l) #t
      (and (p (car l)) (list-for-all p (cdr l)))))
; list exists
(define (list-exists p l)
  (if (null? l) #f
      (or (p (car l)) (list-exists p (cdr l)))))
; list equal as sets
(define (list-as-set-equal? eq? l1 l2)
  (and (equal? (length l1) (length l2))
       (list-for-all (lambda (x) (list-exists (lambda (y) (eq? x y)) l2)) l1)
       (list-for-all (lambda (x) (list-exists (lambda (y) (eq? x y)) l1)) l2)))



;; Part 2a: Binary Trees

; A leaf is represented as a list with the symbol 'leaf.
(define leaf (list 'leaf))
; A node is represented as a list with the symbol 'node, the left-subtree, the data, and the right-subtree.
(define (node l x r) (list 'node l x r))
; convenience functions for getting node elements.
(define (get-node-l n) (cadr n))
(define (get-node-x n) (caddr n))
(define (get-node-r n) (cadddr n))

; Some example binary trees.
(define btree-ex1 leaf)
(define btree-ex2 (node leaf 1 leaf))
(define btree-ex3 (node (node leaf 1 leaf) 2 (node leaf 3 leaf)))
(define btree-ex4 (node (node (node leaf 1 leaf) 2 leaf) 3 (node (node leaf 4 leaf) 5 leaf)))
(define btree-ex5 (node (node (node leaf 1 (node leaf "a" leaf)) 2 leaf) 3 (node (node leaf 4 leaf) 5 leaf)))
(define btree-ex6 (node (node (node leaf 1 (node leaf "a" leaf)) 2 leaf) 3 (node (node (node (node leaf "b" leaf) "c" leaf) 4 leaf) 5 leaf)))

; Some more test trees
(define btree-caw-1 (node (node leaf 1 leaf) 2 leaf))
(define btree-caw-2 (node leaf 2 (node leaf 3 leaf)))

; A leaf? predicate.
(define (leaf? x) (equal? x leaf))
; A node? predicate.
(define (node? x) (and (list? x)
                       (equal? (length x) 4)
                       (equal? (car x) 'node)))
; A btree? predicate.
(define (btree? x)
  (or (leaf? x)
      (and (node? x)
           (btree? (get-node-l x))
           (btree? (get-node-r x)))))

; Convert a binary tree (of data) to a list (of data).
(define (btree->list bt)
  (if (btree? bt)
      (if (leaf? bt)
          '()
          (append (btree->list (get-node-l bt))
                  (list (get-node-x bt))
                  (btree->list (get-node-r bt))))
      (error "btree->list: expects type <btree> as 1st argument")))

; Return true if all data of the binary tree satisfies the predicate.
(define (btree-for-all p bt)
  (if (btree? bt)
      (if (leaf? bt)
          #t
          (and (btree-for-all p (get-node-l bt)) 
               (p (get-node-x bt))
               (btree-for-all p (get-node-r bt))))
      (error "btree-for-all: expects type <btree> as 2nd argument")))

; Return true if there exists data of the binary tree satisfies the predicate.
(define (btree-exists p bt)
  (if (btree? bt)
      (if (leaf? bt)
          #f
          (or (btree-exists p (get-node-l bt)) 
              (p (get-node-x bt))
              (btree-exists p (get-node-r bt))))
      (error "btree-exists: expects type <btree> as 2nd argument")))

; Fold the function "f", with base-case value "b", over the binary tree.
(define (btree-fold f b bt)
  (if (btree? bt)
      (if (leaf? bt)
          b
          (f (btree-fold f b (get-node-l bt))
             (get-node-x bt)
             (btree-fold f b (get-node-r bt))))
      (error "btree-exists: expects type <btree> as 3rd argument")))


;; btree-size
; DEFINE btree-size HERE
(define (btree-size bt)
  (if (null? bt)
      -1 ; standard
      (if (leaf? bt)
          0
          (+ 1 (btree-size (get-node-l bt)) (btree-size (get-node-r bt))))))

;; btree-size tests
(define btree-size-test01
  (list "btree-size-test01"
        (list btree-ex1)
        0))
(define btree-size-test02
  (list "btree-size-test02"
        (list btree-ex2)
        1))
(define btree-size-test03
  (list "btree-size-test03"
        (list btree-ex3)
        3))
(define btree-size-test04
  (list "btree-size-test04"
        (list btree-ex4)
        5))
(define btree-size-test05
  (list "btree-size-test05"
        (list btree-ex5)
        6))
(define btree-size-test06
  (list "btree-size-test06"
        (list btree-ex6)
        8))
(define btree-size-tests
  (list btree-size-test01
        btree-size-test02
        btree-size-test03
        btree-size-test04
        btree-size-test05
        btree-size-test06))
; Uncomment the following to test your btree-size procedure.
(run-tests btree-size equal? btree-size-tests)


;; btree-height
; DEFINE btree-height HERE
(define (btree-height bt)
  (if (null? bt)
      -1 ; standard definition for tree height
      (if (leaf? bt)
          0
          (max (+ 1 (btree-height (get-node-l bt))) (+ 1 (btree-height (get-node-r bt)))))))

;; btree-height tests
(define btree-height-test01
  (list "btree-height-test01"
        (list btree-ex1)
        0))
(define btree-height-test02
  (list "btree-height-test02"
        (list btree-ex2)
        1))
(define btree-height-test03
  (list "btree-height-test03"
        (list btree-ex3)
        2))
(define btree-height-test04
  (list "btree-height-test04"
        (list btree-ex4)
        3))
(define btree-height-test05
  (list "btree-height-test05"
        (list btree-ex5)
        4))
(define btree-height-test06
  (list "btree-height-test06"
        (list btree-ex6)
        5))
(define btree-height-tests
  (list btree-height-test01
        btree-height-test02
        btree-height-test03
        btree-height-test04
        btree-height-test05
        btree-height-test06))
; Uncomment the following to test your btree-height procedure.
(run-tests btree-height equal? btree-height-tests)


;; btree-deepest
; DEFINE btree-deepest HERE
(define (btree-deepest bt)
  (define (deepest tree)
    (cond
      ((and (node? (get-node-l tree)) (node? (get-node-r tree))) ; if they're both nodes, choose which one has the deepest element
       (let
           ((left (deepest (get-node-l tree)))
            (right (deepest (get-node-r tree))))
         (if (>= (cdr left) (cdr right)) ; choose the one that has the deepest element
             (cons (car left) (+ 1 (cdr left)))
             (cons (car right) (+ 1 (cdr right))))))
      ((node? (get-node-l tree)) ; TODO: use let to store result from 1 function call
       (cons (car (deepest (get-node-l tree))) (+ 1 (cdr (deepest (get-node-l tree)))))) ; pass up 1 + deepness of left
      ((node? (get-node-r tree)) ; TODO: use let to store result from 1 function call
       (cons (car (deepest (get-node-r tree))) (+ 1 (cdr (deepest (get-node-r tree)))))) ; pass up 1 + deepeness of right
      (else 
       (cons (get-node-x tree) 0)))) ; pass up data and 0 (we didn't go any deeper)
 (if (or (null? bt) (leaf? bt))
      #f ; null tree or leaf returns false
      (car (deepest bt))))
  
  #|
  (define (deepest-element bt d)
    (if (leaf? bt)
        (list #f -1) ; pass up data to indicate not to pick this branch
        (cond ; pass up the first element
          ((and (node? (get-node-l bt)) (node? (get-node-r bt))) 
           (if (>= (cdr (deepest-element (get-node-l bt) (+ 1 d))) d)
               (list #f -1)
               (deepest-element (get-node-l bt) (+ 1 d))))
          ((node? (get-node-l bt)) (deepest-element (get-node-l bt) (+ 1 d)))
          ((node? (get-node-r bt)) (deepest-element (get-node-r bt) (+ 1 d)))
          (else (list (get-node-x bt) 0)))))
  (if (null? bt)
      #f
      (car (deepest-element bt -1))))|#
  

;; btree-deepest tests
(define btree-deepest-test01
  (list "btree-deepest-test01"
        (list btree-ex1)
        #f))
(define btree-deepest-test02
  (list "btree-deepest-test02"
        (list btree-ex2)
        1))
(define btree-deepest-test03
  (list "btree-deepest-test03"
        (list btree-ex3)
        1))
(define btree-deepest-test04
  (list "btree-deepest-test04"
        (list btree-ex4)
        1))
(define btree-deepest-test05
  (list "btree-deepest-test05"
        (list btree-ex5)
        "a"))
(define btree-deepest-test06
  (list "btree-deepest-test06"
        (list btree-ex6)
        "b"))
(define btree-deepest-tests
  (list btree-deepest-test01
        btree-deepest-test02
        btree-deepest-test03
        btree-deepest-test04
        btree-deepest-test05
        btree-deepest-test06))
; Uncomment the following to test your btree-deepest procedure.
(run-tests btree-deepest equal? btree-deepest-tests)


;; btree-subtree?
; DEFINE btree-subtree? HERE
; TODO: copying from sublist? in lists file makes it work about 50% - need to figure out why the rest fail
; TODO: there are a couple cases being omitted (what if one is node and other is not? etc etc)
(define (btree-subtree? bt1 bt2)
  (define (pop-stack bt stack) ; function to pop the stack state off onto the second list parameter
    (if (null? stack)
        bt ; return the end result
        (pop-stack (cons (car stack) bt) (cdr stack))))
  (define (subtree? bt1 bt2 stack) ; function to perform btree-subtree? but maintain state so we can roll back if matches don't occur - the stack is a stack of nodes that are visited on l/r basis
    (cond
      ;((null? bt2) #t) 
      ;((null? bt1) #f)
      ((and (leaf? bt1) (leaf? bt2)) #t)
      ((leaf? bt1) #f) 
      ((leaf? bt2) #t) ; this is okay, since we know that btrees are proper (they have leaves at terminating endpoints, so we can short-circuit here)
       ;(or 
        ;(subtree? (get-node-l bt1) (pop-stack bt2 stack) null)
        ;(subtree? (get-node-r bt1) (pop-stack bt2 stack) null)))
      (else ;(and (node? bt1) (node? bt2)) ; if they are both nodes and their values are equal, make sure l/r subtrees are subtrees too
       (cond
         ((equal? (get-node-x bt1) (get-node-x bt2))
          ; need to do cases for one leaf on left and one leaf on right
          (if (and (leaf? (get-node-l bt2)) (leaf? (get-node-r bt2))) ; if bt2 has an equal value but doesn't have any more leaves, then it is a subtree of bt1
              ;#t ; TODO: remove this check, since i fixed the base case and no longer need to do it!
              (and 
               (subtree? (get-node-l bt1) (get-node-l bt2) (cons bt1 stack)) 
               (subtree? (get-node-r bt1) (get-node-r bt2) (cons bt2 stack)))
              (and 
               (subtree? (get-node-l bt1) (get-node-l bt2) (cons bt1 stack)) 
               (subtree? (get-node-r bt1) (get-node-r bt2) (cons bt2 stack)))))
         (else 
          (or 
           (subtree? (get-node-l bt1) (pop-stack bt2 stack) null)
           (subtree? (get-node-r bt1) (pop-stack bt2 stack) null)))))))
      ;(else #f)))
           ;(subtree? (cdr bt1) (pop-stack bt2 stack) null)))) ; reset the second list and reset the stack to null
           
  (subtree? bt1 bt2 null))

;; btree-subtree? tests
(define btree-subtree?-test01
  (list "btree-subtree?-test01"
        (list btree-ex1 btree-ex1)
        #t))
(define btree-subtree?-test02
  (list "btree-subtree?-test02"
        (list btree-ex1 btree-ex2)
        #f))
(define btree-subtree?-test03
  (list "btree-subtree?-test03"
        (list btree-ex1 btree-ex3)
        #f))
(define btree-subtree?-test04
  (list "btree-subtree?-test04"
        (list btree-ex1 btree-ex4)
        #f))
(define btree-subtree?-test05
  (list "btree-subtree?-test05"
        (list btree-ex1 btree-ex5)
        #f))
(define btree-subtree?-test06
  (list "btree-subtree?-test06"
        (list btree-ex1 btree-ex6)
        #f))
(define btree-subtree?-test07
  (list "btree-subtree?-test07"
        (list btree-ex2 btree-ex1)
        #t))
(define btree-subtree?-test08
  (list "btree-subtree?-test08"
        (list btree-ex2 btree-ex2)
        #t))
(define btree-subtree?-test09
  (list "btree-subtree?-test09"
        (list btree-ex2 btree-ex3)
        #f))
(define btree-subtree?-test10
  (list "btree-subtree?-test10"
        (list btree-ex2 btree-ex4)
        #f))
(define btree-subtree?-test11
  (list "btree-subtree?-test11"
        (list btree-ex2 btree-ex5)
        #f))
(define btree-subtree?-test12
  (list "btree-subtree?-test12"
        (list btree-ex2 btree-ex6)
        #f))
(define btree-subtree?-test13
  (list "btree-subtree?-test13"
        (list btree-ex3 btree-ex1)
        #t))
(define btree-subtree?-test14
  (list "btree-subtree?-test14"
        (list btree-ex3 btree-ex2)
        #t))
(define btree-subtree?-test15
  (list "btree-subtree?-test15"
        (list btree-ex3 btree-ex3)
        #t))
(define btree-subtree?-test16
  (list "btree-subtree?-test16"
        (list btree-ex3 btree-ex4)
        #f))
(define btree-subtree?-test17
  (list "btree-subtree?-test17"
        (list btree-ex3 btree-ex5)
        #f))
(define btree-subtree?-test18
  (list "btree-subtree?-test18"
        (list btree-ex3 btree-ex6)
        #f))
(define btree-subtree?-test19
  (list "btree-subtree?-test19"
        (list btree-ex4 btree-ex1)
        #t))
(define btree-subtree?-test20
  (list "btree-subtree?-test20"
        (list btree-ex4 btree-ex2)
        #t))
(define btree-subtree?-test21
  (list "btree-subtree?-test21"
        (list btree-ex4 btree-ex3)
        #f))
(define btree-subtree?-test22
  (list "btree-subtree?-test22"
        (list btree-ex4 btree-ex4)
        #t))
(define btree-subtree?-test23
  (list "btree-subtree?-test23"
        (list btree-ex4 btree-ex5)
        #f))
(define btree-subtree?-test24
  (list "btree-subtree?-test24"
        (list btree-ex4 btree-ex6)
        #f))
(define btree-subtree?-test25
  (list "btree-subtree?-test25"
        (list btree-ex5 btree-ex1)
        #t))
(define btree-subtree?-test26
  (list "btree-subtree?-test26"
        (list btree-ex5 btree-ex2)
        #t))
(define btree-subtree?-test27
  (list "btree-subtree?-test27"
        (list btree-ex5 btree-ex3)
        #f))
(define btree-subtree?-test28
  (list "btree-subtree?-test28"
        (list btree-ex5 btree-ex4)
        #t))
(define btree-subtree?-test29
  (list "btree-subtree?-test29"
        (list btree-ex5 btree-ex5)
        #t))
(define btree-subtree?-test30
  (list "btree-subtree?-test30"
        (list btree-ex5 btree-ex6)
        #f))
(define btree-subtree?-test31
  (list "btree-subtree?-test31"
        (list btree-ex6 btree-ex1)
        #t))
(define btree-subtree?-test32
  (list "btree-subtree?-test32"
        (list btree-ex6 btree-ex2)
        #t))
(define btree-subtree?-test33
  (list "btree-subtree?-test33"
        (list btree-ex6 btree-ex3)
        #f))
(define btree-subtree?-test34
  (list "btree-subtree?-test34"
        (list btree-ex6 btree-ex4)
        #t))
(define btree-subtree?-test35
  (list "btree-subtree?-test35"
        (list btree-ex6 btree-ex5)
        #t))
(define btree-subtree?-test36
  (list "btree-subtree?-test36"
        (list btree-ex6 btree-ex6)
        #t))
(define btree-subtree?-tests
  (list btree-subtree?-test01 btree-subtree?-test02 btree-subtree?-test03
        btree-subtree?-test04 btree-subtree?-test05 btree-subtree?-test06
        btree-subtree?-test07 btree-subtree?-test08 btree-subtree?-test09
        btree-subtree?-test10 btree-subtree?-test11 btree-subtree?-test12
        btree-subtree?-test13 btree-subtree?-test14 btree-subtree?-test15
        btree-subtree?-test16 btree-subtree?-test17 btree-subtree?-test18
        btree-subtree?-test19 btree-subtree?-test20 btree-subtree?-test21
        btree-subtree?-test22 btree-subtree?-test23 btree-subtree?-test24
        btree-subtree?-test25 btree-subtree?-test26 btree-subtree?-test27
        btree-subtree?-test28 btree-subtree?-test29 btree-subtree?-test30
        btree-subtree?-test31 btree-subtree?-test32 btree-subtree?-test33
        btree-subtree?-test34 btree-subtree?-test35 btree-subtree?-test36))
; Uncomment the following to test your btree-subtree? procedure.
(run-tests btree-subtree? equal? btree-subtree?-tests)


;; btree-subtrees
; DEFINE btree-subtrees HERE

;; btree-subtrees tests
(define btree-subtrees-test01
  (list "btree-subtrees-test01"
        (list btree-ex1)
        (list leaf)))
(define btree-subtrees-test02
  (list "btree-subtrees-test02"
        (list btree-ex2)
        (list btree-ex2 leaf)))
(define btree-subtrees-test03
  (list "btree-subtrees-test03"
        (list btree-ex3)
        (list btree-ex3 (node leaf 1 leaf) (node leaf 3 leaf) leaf)))
(define btree-subtrees-test04
  (list "btree-subtrees-test04"
        (list btree-ex4)
        (list btree-ex4 (node (node leaf 1 leaf) 2 leaf) (node leaf 1 leaf) (node (node leaf 4 leaf) 5 leaf) (node leaf 4 leaf) leaf)))
(define btree-subtrees-tests
  (list btree-subtrees-test01
        btree-subtrees-test02
        btree-subtrees-test03
        btree-subtrees-test04))
; Uncomment the following to test your btree-subtrees procedure.
; (run-tests btree-subtrees (lambda (l1 l2) (list-as-set-equal? equal? l1 l2)) btree-subtrees-tests)



;; Part 2b: Sorted Binary Trees

(define (btree-sorted? lt bt)
  (if (btree? bt)
      (if (btree-fold (lambda (l x r)
                        (let ((lo (cond
                                   ((equal? #t l) x)
                                   ((pair? l) (let ((llo (car l))
                                                    (lhi (cdr l)))
                                                (if (lt lhi x) llo #f)))
                                   ((equal? #f l) #f)))
                              (hi (cond
                                   ((equal? #t r) x)
                                   ((pair? r) (let ((rlo (car r))
                                                    (rhi (cdr r)))
                                                (if (lt x rlo) rhi #f)))
                                   ((equal? #f r) #f))))
                          (and lo hi (cons lo hi))))
                      #t
                      bt)
          #t #f)
      (error "btree-sorted?: expects type <btree> as 2nd argument")))

; A sorted binary tree is represented as a list with the symbol 'sbtree, a comparison
; (less-than) function, and a binary tree (with elements in order
; according to the comparison function).
(define sbtree-getlt get-2nd)
(define sbtree-getbtree get-3rd)
(define (sbtree? v)
  (and (list? v)
       (= (length v) 3)
       (eq? (car v) 'sbtree)
       (btree-sorted? (sbtree-getlt v) (sbtree-getbtree v))))

; Make an empty sorted binary tree by supplying a comparison
; (less-than) function.
(define (sbtree-empty lt) (list 'sbtree lt leaf))

; Some example sorted binary trees.
(define sbtree-ex1 (list 'sbtree < leaf))
(define sbtree-ex2 (list 'sbtree < (node leaf 1 leaf)))
(define sbtree-ex3 (list 'sbtree < (node (node leaf 1 leaf) 3 (node leaf 5 leaf))))
(define sbtree-ex4 (list 'sbtree < (node (node (node leaf 1 leaf) 3 leaf) 5 (node (node leaf 7 leaf) 9 leaf))))
(define sbtree-ex5 (list 'sbtree string<? leaf))
(define sbtree-ex6 (list 'sbtree string<? (node leaf "a" leaf)))
(define sbtree-ex7 (list 'sbtree string<? (node (node leaf "a" leaf) "c" (node leaf "e" leaf))))
(define sbtree-ex8 (list 'sbtree string<? (node (node (node leaf "a" leaf) "c" leaf) "e" (node (node leaf "g" leaf) "i" leaf))))



;; sbtree-find
; DEFINE sbtree-find HERE
(define (sbtree-find sbt e)
  (define (find bt comp e)
    (cond 
      ((null? bt) #f)
      ((leaf? bt) #f)
      (else 
       (if (equal? e (get-node-x bt)) 
            #t ; we found the element
            (if (comp e (get-node-x bt)) ; run the comparison and check the right branch
                (find (get-node-l bt) comp e)
                (find (get-node-r bt) comp e))))))
  (find (get-3rd sbt) (get-2nd sbt) e)) ; extract the comparison operator and tree and call the new find function
            

;; sbtree-find tests
(define sbtree-find-test01
  (list "sbtree-find-test01"
        (list sbtree-ex1 1)
        #f))
(define sbtree-find-test02
  (list "sbtree-find-test02"
        (list sbtree-ex1 99)
        #f))
(define sbtree-find-test03
  (list "sbtree-find-test03"
        (list sbtree-ex1 -99)
        #f))
(define sbtree-find-test04
  (list "sbtree-find-test04"
        (list sbtree-ex2 1)
        #t))
(define sbtree-find-test05
  (list "sbtree-find-test05"
        (list sbtree-ex2 99)
        #f))
(define sbtree-find-test06
  (list "sbtree-find-test06"
        (list sbtree-ex2 -99)
        #f))
(define sbtree-find-test07
  (list "sbtree-find-test07"
        (list sbtree-ex3 -99)
        #f))
(define sbtree-find-test08
  (list "sbtree-find-test08"
        (list sbtree-ex3 1)
        #t))
(define sbtree-find-test09
  (list "sbtree-find-test09"
        (list sbtree-ex3 2)
        #f))
(define sbtree-find-test10
  (list "sbtree-find-test10"
        (list sbtree-ex3 3)
        #t))
(define sbtree-find-test11
  (list "sbtree-find-test11"
        (list sbtree-ex3 4)
        #f))
(define sbtree-find-test12
  (list "sbtree-find-test12"
        (list sbtree-ex3 5)
        #t))
(define sbtree-find-test13
  (list "sbtree-find-test13"
        (list sbtree-ex3 99)
        #f))
(define sbtree-find-test14
  (list "sbtree-find-test14"
        (list sbtree-ex5 "a")
        #f))
(define sbtree-find-test15
  (list "sbtree-find-test15"
        (list sbtree-ex5 "zz")
        #f))
(define sbtree-find-test16
  (list "sbtree-find-test16"
        (list sbtree-ex5 "00")
        #f))
(define sbtree-find-test17
  (list "sbtree-find-test17"
        (list sbtree-ex6 "a")
        #t))
(define sbtree-find-test18
  (list "sbtree-find-test18"
        (list sbtree-ex6 "zz")
        #f))
(define sbtree-find-test19
  (list "sbtree-find-test19"
        (list sbtree-ex6 "0")
        #f))
(define sbtree-find-test20
  (list "sbtree-find-test20"
        (list sbtree-ex7 "0")
        #f))
(define sbtree-find-test21
  (list "sbtree-find-test21"
        (list sbtree-ex7 "a")
        #t))
(define sbtree-find-test22
  (list "sbtree-find-test22"
        (list sbtree-ex7 "b")
        #f))
(define sbtree-find-test23
  (list "sbtree-find-test23"
        (list sbtree-ex7 "c")
        #t))
(define sbtree-find-test24
  (list "sbtree-find-test24"
        (list sbtree-ex7 "d")
        #f))
(define sbtree-find-test25
  (list "sbtree-find-test25"
        (list sbtree-ex7 "e")
        #t))
(define sbtree-find-test26
  (list "sbtree-find-test26"
        (list sbtree-ex7 "zz")
        #f))
(define sbtree-find-tests
  (list sbtree-find-test01
        sbtree-find-test02
        sbtree-find-test03
        sbtree-find-test04
        sbtree-find-test05
        sbtree-find-test06
        sbtree-find-test07
        sbtree-find-test08
        sbtree-find-test09
        sbtree-find-test10
        sbtree-find-test11
        sbtree-find-test12
        sbtree-find-test13
        sbtree-find-test14
        sbtree-find-test15
        sbtree-find-test16
        sbtree-find-test17
        sbtree-find-test18
        sbtree-find-test19
        sbtree-find-test20
        sbtree-find-test21
        sbtree-find-test22
        sbtree-find-test23
        sbtree-find-test24
        sbtree-find-test25
        sbtree-find-test26))
; Uncomment the following to test your sbtree-find procedure.
(run-tests sbtree-find equal? sbtree-find-tests)


;; sbtree-insert
; DEFINE sbtree-insert HERE
(define (sbtree-insert sbt e)
  (define (insert bt comp e)
    (cond 
      ;((null? bt) #f)
      ((leaf? bt) (node leaf e leaf)) ; return the new leaf in the tree
      (else 
       (let 
           ((left (insert (get-node-l bt) comp e)) ; store the resulting btree
            (right (insert (get-node-r bt) comp e))) ; store the resulting btree
         (if (equal? e (get-node-x bt)) 
             bt ; we found a duplicate, so return a null element
             (if (comp e (get-node-x bt)) ; run the comparison and check the correct branch
                 ;(if (null? left)
                    ; (get-node-l bt) ; return original left hand side
                     (node left (get-node-x bt) (get-node-r bt))
                 ;(if (null? right)
                     ;(get-node-r bt) ; return original right hand side
                     (node (get-node-l bt) (get-node-x bt) right)))))))
                ;(node (insert (get-node-l bt) comp e) (get-node-x bt) (get-node-r bt))
                ;(node (get-node-l bt) (get-node-x bt) (insert (get-node-r bt) comp e)))))))
  (list 'sbtree (get-2nd sbt) (insert (get-3rd sbt) (get-2nd sbt) e))) ; extract the comparison operator and tree and call the new find function
  

;; sbtree-insert tests
(define sbtree-insert-test01
  (list "sbtree-insert-test01"
        (list sbtree-ex1 1)
        (list 'sbtree < (node leaf 1 leaf))))
(define sbtree-insert-test02
  (list "sbtree-insert-test02"
        (list sbtree-ex1 99)
        (list 'sbtree < (node leaf 99 leaf))))
(define sbtree-insert-test03
  (list "sbtree-insert-test03"
        (list sbtree-ex1 -99)
        (list 'sbtree < (node leaf -99 leaf))))
(define sbtree-insert-test04
  (list "sbtree-insert-test04"
        (list sbtree-ex2 1)
        (list 'sbtree < (node leaf 1 leaf))))
(define sbtree-insert-test05
  (list "sbtree-insert-test05"
        (list sbtree-ex2 99)
        (list 'sbtree < (node leaf 1 (node leaf 99 leaf)))))
(define sbtree-insert-test06
  (list "sbtree-insert-test06"
        (list sbtree-ex2 -99)
        (list 'sbtree < (node (node leaf -99 leaf) 1 leaf))))
(define sbtree-insert-test07
  (list "sbtree-insert-test07"
        (list sbtree-ex3 -99)
        (list 'sbtree < (node (node (node leaf -99 leaf) 1 leaf) 3 (node leaf 5 leaf)))))
(define sbtree-insert-test08
  (list "sbtree-insert-test08"
        (list sbtree-ex3 1)
        (list 'sbtree < (node (node leaf 1 leaf) 3 (node leaf 5 leaf)))))
(define sbtree-insert-test09
  (list "sbtree-insert-test09"
        (list sbtree-ex3 2)
        (list 'sbtree < (node (node leaf 1 (node leaf 2 leaf)) 3 (node leaf 5 leaf)))))
(define sbtree-insert-test10
  (list "sbtree-insert-test10"
        (list sbtree-ex3 3)
        (list 'sbtree < (node (node leaf 1 leaf) 3 (node leaf 5 leaf)))))
(define sbtree-insert-test11
  (list "sbtree-insert-test11"
        (list sbtree-ex3 4)
        (list 'sbtree < (node (node leaf 1 leaf) 3 (node (node leaf 4 leaf) 5 leaf)))))
(define sbtree-insert-test12
  (list "sbtree-insert-test12"
        (list sbtree-ex3 5)
        (list 'sbtree < (node (node leaf 1 leaf) 3 (node leaf 5 leaf)))))
(define sbtree-insert-test13
  (list "sbtree-insert-test13"
        (list sbtree-ex3 99)
        (list 'sbtree < (node (node leaf 1 leaf) 3 (node leaf 5 (node leaf 99 leaf))))))
(define sbtree-insert-test14
  (list "sbtree-insert-test14"
        (list sbtree-ex5 "a")
        (list 'sbtree string<? (node leaf "a" leaf))))
(define sbtree-insert-test15
  (list "sbtree-insert-test15"
        (list sbtree-ex5 "zz")
        (list 'sbtree string<? (node leaf "zz" leaf))))
(define sbtree-insert-test16
  (list "sbtree-insert-test16"
        (list sbtree-ex5 "00")
        (list 'sbtree string<? (node leaf "00" leaf))))
(define sbtree-insert-test17
  (list "sbtree-insert-test17"
        (list sbtree-ex6 "a")
        (list 'sbtree string<? (node leaf "a" leaf))))
(define sbtree-insert-test18
  (list "sbtree-insert-test18"
        (list sbtree-ex6 "zz")
        (list 'sbtree string<? (node leaf "a" (node leaf "zz" leaf)))))
(define sbtree-insert-test19
  (list "sbtree-insert-test19"
        (list sbtree-ex6 "00")
        (list 'sbtree string<? (node (node leaf "00" leaf) "a" leaf))))
(define sbtree-insert-test20
  (list "sbtree-insert-test20"
        (list sbtree-ex7 "00")
        (list 'sbtree string<? (node (node (node leaf "00" leaf) "a" leaf) "c" (node leaf "e" leaf)))))
(define sbtree-insert-test21
  (list "sbtree-insert-test21"
        (list sbtree-ex7 "a")
        (list 'sbtree string<? (node (node leaf "a" leaf) "c" (node leaf "e" leaf)))))
(define sbtree-insert-test22
  (list "sbtree-insert-test22"
        (list sbtree-ex7 "b")
        (list 'sbtree string<? (node (node leaf "a" (node leaf "b" leaf)) "c" (node leaf "e" leaf)))))
(define sbtree-insert-test23
  (list "sbtree-insert-test23"
        (list sbtree-ex7 "c")
        (list 'sbtree string<? (node (node leaf "a" leaf) "c" (node leaf "e" leaf)))))
(define sbtree-insert-test24
  (list "sbtree-insert-test24"
        (list sbtree-ex7 "d")
        (list 'sbtree string<? (node (node leaf "a" leaf) "c" (node (node leaf "d" leaf) "e" leaf)))))
(define sbtree-insert-test25
  (list "sbtree-insert-test25"
        (list sbtree-ex7 "e")
        (list 'sbtree string<? (node (node leaf "a" leaf) "c" (node leaf "e" leaf)))))
(define sbtree-insert-test26
  (list "sbtree-insert-test26"
        (list sbtree-ex7 "zz")
        (list 'sbtree string<? (node (node leaf "a" leaf) "c" (node leaf "e" (node leaf "zz" leaf))))))
(define sbtree-insert-tests
  (list sbtree-insert-test01
        sbtree-insert-test02
        sbtree-insert-test03
        sbtree-insert-test04
        sbtree-insert-test05
        sbtree-insert-test06
        sbtree-insert-test07
        sbtree-insert-test08
        sbtree-insert-test09
        sbtree-insert-test10
        sbtree-insert-test11
        sbtree-insert-test12
        sbtree-insert-test13
        sbtree-insert-test14
        sbtree-insert-test15
        sbtree-insert-test16
        sbtree-insert-test17
        sbtree-insert-test18
        sbtree-insert-test19
        sbtree-insert-test20
        sbtree-insert-test21
        sbtree-insert-test22
        sbtree-insert-test23
        sbtree-insert-test24
        sbtree-insert-test25
        sbtree-insert-test26))
; Uncomment the following to test your sbtree-insert procedure.
(run-tests sbtree-insert (lambda (sbt1 sbt2) (equal? (sbtree-getbtree sbt1) (sbtree-getbtree sbt2))) sbtree-insert-tests)
