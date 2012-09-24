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



;; Part 1: List Functions

; list length
;  * empty list has length 0
;  * non-empyt list has length 1 + length of cdr of list
(define (list-length l)
  (if (null? l) 0
      (+ 1 (list-length (cdr l)))))

; list reverse with accumulator
(define (list-reverse l)
  (define (list-reverse-aux l1 l2)
    (if (null? l1) l2
        (list-reverse-aux (cdr l1) (cons (car l1) l2))))
    (list-reverse-aux l '()))

; list append (using reverse)
(define (list-append l1 l2)
  (define (list-append-aux l1 l2)
    (if (null? l1) l2
        (list-append-aux (cdr l1) (cons (car l1) l2))))
  (list-append-aux (list-reverse l1) l2))

; list map
(define (list-map f l)
  (if (null? l) '()
      (cons (f (car l)) (list-map f (cdr l)))))

; list filter
(define (list-filter p l)
  (if (null? l) '()
      (if (p (car l))
          (cons (car l) (list-filter p (cdr l)))
          (list-filter p (cdr l)))))

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

; list foldl (left-to-right)
(define (list-foldl f b l)
  (if (null? l) b
      (list-foldl f (f (car l) b) (cdr l))))

; list foldr (right-to-left)
(define (list-foldr f b l)
  (if (null? l) b
      (f (car l) (list-foldr f b (cdr l)))))



;; list-uniquify
; DEFINE list-uniquify HERE
(define (list-uniquify l)
  (if (null? l) null
      (cons 
       (car l) 
       (list-filter 
        (lambda (x) (not (equal? x (car l)))) 
        (list-uniquify (cdr l))))))

;; list-uniquify tests
(define list-uniquify-test01
  (list "list-uniquify-test01"
        '((1 2 3))
        '(1 2 3)))
(define list-uniquify-test02
  (list "list-uniquify-test02"
        '((1 2 3 1))
        '(1 2 3)))
(define list-uniquify-test03
  (list "list-uniquify-test03"
        '((1 2 3 2))
        '(1 2 3)))
(define list-uniquify-test04
  (list "list-uniquify-test04"
        '((1 2 3 3))
        '(1 2 3)))
(define list-uniquify-test05
  (list "list-uniquify-test05"
        '(())
        '()))
(define list-uniquify-test06
  (list "list-uniquify-test06"
        '((a b c))
        '(a b c)))
(define list-uniquify-test07
  (list "list-uniquify-test07"
        '((a b c a))
        '(a b c)))
(define list-uniquify-test08
  (list "list-uniquify-test08"
        '((a b c b))
        '(a b c)))
(define list-uniquify-test09
  (list "list-uniquify-test09"
        '((a b c c))
        '(a b c)))
(define list-uniquify-test10
  (list "list-uniquify-test10"
        '((a a a b b b c c c a b c c b a))
        '(a b c)))
(define list-uniquify-test11
  (list "list-uniquify-test11"
        '((3 2 2 3 3 2 2 3 2 2 2 1 2 2 3 2 1 2 3 2))
        '(3 2 1)))
(define list-uniquify-tests
  (list list-uniquify-test01
        list-uniquify-test02
        list-uniquify-test03
        list-uniquify-test04
        list-uniquify-test05
        list-uniquify-test06
        list-uniquify-test07
        list-uniquify-test08
        list-uniquify-test09
        list-uniquify-test10
        list-uniquify-test11))
; Uncomment the following to test your list-uniquify procedure.
(run-tests list-uniquify equal? list-uniquify-tests)


;; list-swizzle
; DEFINE list-swizzle HERE
(define (list-swizzle l1 l2)
  (cond
    ((and (null? l1) (null? l2)) null)
    ((null? l1) (cons (car l2) (list-swizzle l1 (cdr l2))))
    ((null? l2) (cons (car l1) (list-swizzle l2 (cdr l1))))
    (else (cons (car l1) (cons (car l2) (list-swizzle (cdr l1) (cdr l2)))))))

;; list-swizzle tests
(define list-swizzle-test01
  (list "list-swizzle-test01"
        '((a b c) (d e f))
        '(a d b e c f)))
(define list-swizzle-test02
  (list "list-swizzle-test02"
        '((a b c d) (e f))
        '(a e b f c d)))
(define list-swizzle-test03
  (list "list-swizzle-test03"
        '((a b) (c d e f))
        '(a c b d e f)))
(define list-swizzle-test04
  (list "list-swizzle-test04"
        '(() ())
        '()))
(define list-swizzle-test05
  (list "list-swizzle-test05"
        '((a b) ())
        '(a b)))
(define list-swizzle-test06
  (list "list-swizzle-test06"
        '(() (d e))
        '(d e)))
(define list-swizzle-test07
  (list "list-swizzle-test07"
        '((1 2 3 4 5) (a b c d e))
        '(1 a 2 b 3 c 4 d 5 e)))
(define list-swizzle-tests
  (list list-swizzle-test01
        list-swizzle-test02
        list-swizzle-test03
        list-swizzle-test04
        list-swizzle-test05
        list-swizzle-test06
        list-swizzle-test07))
; Uncomment the following to test your list-swizzle procedure.
(run-tests list-swizzle equal? list-swizzle-tests)


;; list-sublist?
; DEFINE list-sublist? HERE
(define (list-sublist? l1 l2)
  (define (pop-stack-helper l stack) ; function to pop the stack state off onto the second list parameter
    (if (null? stack)
        l ; return the end result
        (pop-stack-helper (cons (car stack) l) (cdr stack))))
  (define (sublist-helper l1 l2 stack) ; function to perform list-sublist? but maintain state so we can roll back if matches don't occur
    (cond
      ((null? l2) #t)
      ((null? l1) #f)
      ((equal? (car l1) (car l2))
       (sublist-helper (cdr l1) (cdr l2) (cons (car l1) stack))) ; pop off the front of each list and continue searching
      (else 
       (sublist-helper (cdr l1) (pop-stack-helper l2 stack) null)))) ; reset the second list to its original state the stack to null
  (sublist-helper l1 l2 null)) ; invoke the helper

;; list-sublist? tests
(define list-sublist?-test01
  (list "list-sublist?-test01"
        '((a b c d e) (c d))
        #t))
(define list-sublist?-test02
  (list "list-sublist?-test02"
        '((a b c d e) (b d))
        #f))
(define list-sublist?-test03
  (list "list-sublist?-test03"
        '((1 2 3) (1 2 3))
        #t))
(define list-sublist?-test04
  (list "list-sublist?-test04"
        '((1 2 3) (1 2))
        #t))
(define list-sublist?-test05
  (list "list-sublist?-test05"
        '((1 2 3) (2 3))
        #t))
(define list-sublist?-test06
  (list "list-sublist?-test06"
        '((1 2 3) (1))
        #t))
(define list-sublist?-test07
  (list "list-sublist?-test07"
        '((1 2 3) (2))
        #t))
(define list-sublist?-test08
  (list "list-sublist?-test08"
        '((1 2 3) (3))
        #t))
(define list-sublist?-test09
  (list "list-sublist?-test09"
        '((1 2 3) ())
        #t))
(define list-sublist?-test10
  (list "list-sublist?-test10"
        '((1 2 3) (1 3))
        #f))
(define list-sublist?-test11
  (list "list-sublist?-test11"
        '((1 2 3) (1 2 3 4))
        #f))
(define list-sublist?-test12
  (list "list-sublist?-test12"
        '((1 2 3) (4 1 2 3))
        #f))
(define list-sublist?-test13
  (list "list-sublist?-test13"
        '((1 2 3) (0 1 12 2 23 3 4))
        #f))
(define list-sublist?-test14
  (list "list-sublist?-test14"
        '(() ())
        #t))
(define list-sublist?-test15
  (list "list-sublist?-test15"
        '(() (1))
        #f))
(define list-sublist?-tests
  (list list-sublist?-test01
        list-sublist?-test02
        list-sublist?-test03
        list-sublist?-test04
        list-sublist?-test05
        list-sublist?-test06
        list-sublist?-test07
        list-sublist?-test08
        list-sublist?-test09
        list-sublist?-test10
        list-sublist?-test11
        list-sublist?-test12
        list-sublist?-test13
        list-sublist?-test14
        list-sublist?-test15))
; Uncomment the following to test your list-sublist? procedure.
(run-tests list-sublist? equal? list-sublist?-tests)


;; list-permutation?
; DEFINE list-permutation? HERE
(define (list-permutation? l1 l2)
  (cond
    ((not (equal? (length l1) (length l2))) #f)
    ((and (null? l1) (null? l2)) #t)
    (else 
     (list-permutation? 
      (cdr l1) 
      (list-filter (lambda (x) (not (equal? x (car l1)))) l2))))) 

;; list-permutation? tests
(define list-permutation?-test01
  (list "list-permutation?-test01"
        '((1 2 3) (1 2 3))
        #t))
(define list-permutation?-test02
  (list "list-permutation?-test02"
        '((1 2 3) (1 3 2))
        #t))
(define list-permutation?-test03
  (list "list-permutation?-test03"
        '((1 2 3) (2 1 3))
        #t))
(define list-permutation?-test04
  (list "list-permutation?-test04"
        '((1 2 3) (2 3 1))
        #t))
(define list-permutation?-test05
  (list "list-permutation?-test05"
        '((1 2 3) (3 1 2))
        #t))
(define list-permutation?-test06
  (list "list-permutation?-test06"
        '((1 2 3) (3 2 1))
        #t))
(define list-permutation?-test07
  (list "list-permutation?-test07"
        '((1 2 3) (1 2))
        #f))
(define list-permutation?-test08
  (list "list-permutation?-test08"
        '((1 2 3) (2 3))
        #f))
(define list-permutation?-test09
  (list "list-permutation?-test09"
        '((1 2 3) (1 2 3 4))
        #f))
(define list-permutation?-test10
  (list "list-permutation?-test10"
        '((1 2 3) (4 3 2 1))
        #f))
(define list-permutation?-test11
  (list "list-permutation?-test11"
        '((1 2 3) ())
        #f))
(define list-permutation?-test12
  (list "list-permutation?-test12"
        '((1) (1))
        #t))
(define list-permutation?-test13
  (list "list-permutation?-test13"
        '((1) ())
        #f))
(define list-permutation?-test14
  (list "list-permutation?-test14"
        '((1) (2 1))
        #f))
(define list-permutation?-test15
  (list "list-permutation?-test15"
        '(() ())
        #t))
(define list-permutation?-test16
  (list "list-permutation?-test16"
        '(() (a))
        #f))
(define list-permutation?-tests
  (list list-permutation?-test01
        list-permutation?-test02
        list-permutation?-test03
        list-permutation?-test04
        list-permutation?-test05
        list-permutation?-test06
        list-permutation?-test07
        list-permutation?-test08
        list-permutation?-test09
        list-permutation?-test10
        list-permutation?-test11
        list-permutation?-test12
        list-permutation?-test13
        list-permutation?-test14
        list-permutation?-test15
        list-permutation?-test16))
; Uncomment the following to test your list-permutation? procedure.
(run-tests list-permutation? equal? list-permutation?-tests)


(define (list-rotate orig used)
      (if (null? used)
        null
        (cons 
         (cons 
          (car used) 
          (list-filter 
           (lambda (x) (not (equal? x (car used)))) 
           orig))
         (list-rotate orig (cdr used)))))

(define (list-merge l)
  ; assumes list is of the form (root (children))
  (define (merge-all l l1)
    ;(display 'here!)
    (if (null? l1)
        null
        (cons 
         (merge l (car l1))
         (merge-all l (cdr l1)))))
         ;(merge l (car l1)))))
  (define (merge l1 l2)
    ;(display '--)
    ;(display l1)
    ;(display ': )
    ;(display l2)
    (cond 
      ((null? l2) (cons l1 null))
      ;((equal? (length l2) 1) (cons l1 l2)) 
      (else
        (cons l1 (merge (car l2) (cdr l2))))))
  ;(display 'merging )
  ;(display l)
  (cond  
    ;((number? (cdr l)) (cons (car l) (cdr l)))
    ((number? (cdr l)) (cons (cdr l) null))
    ((number? (car (cdr l))) 
     (cons (car l) (cdr l)))
    (else 
     ;(display 'casetwo) 
     (merge-all (car l) (cdr l)))))

(define (merge-subsublists master children)
    (if (null? children)
        master
        (cons (cons master (car children)) (merge-subsublists master (cdr children)))))
 
(define (list-merge-sublists l)
  ; assume l is of the form l = ((l1)(l2)), we want (l1 l2)
  (define (merge-sublists master children)
    ;(display '--)
    ;(display master)
    ;(display ':)
    ;(display children)
    (if (null? children)
        master
        (cons master (merge-sublists (car children) (cdr children)))))
  
  ;(display (merge-sublists (car l) (cdr l)))
  ;(display '<-result)
  (display 'merging)
  (display l)
  (if (number? (car (car l)))
      l
      ;(merge-sublists (car (car l)) (cdr l))))
      (merge-sublists (merge-subsublists (car (car l)) (cdr (car l))) (cdr l))))

;(((1 2 3) (1 3 2)) ((2 1 3) (2 3 1)) ((3 1 2) (3 2 1)))

(define (list-permutations-merge base children)
  (display '--)
  (display base)
  (display children)
  (cond 
    ((null? children) null)
    ;((number? children) (list base children))
    (else 
      (cons (list base (car children)) (list-permutations-merge base (cdr children))))))
      ;(list-permutations-merge (cons base (car children)) (cdr children))))

;; list-permutations
; DEFINE list-permutations HERE
(define (list-permutations l)
  ; Function to generate all rotations for a given list
  ;TODO: put here
  
  ; Function to recursively invoke the permutations function on sublists
  #|(define (list-permutations-helper l)
    (cond 
      ((equal? (length l) 1) (list l))
      ;((null? l) l)
      (else 
       (list-map (lambda (x) (cons (car l) x)) (list-permutations (cdr l))))))
       ;(list-permutations-merge (car l) (list-permutations (cdr l))))))
  (cond
    ((null? l) null)
    (else 
     (list-map list-permutations-helper (list-rotate l l)))))|#
  ; Helper function that inserts an element elem into every spot in the list l
  ; TODO: write my own insert everywhere function (to replace this one)
  (define (permutations-insert elem l)
    (define (permutations-insert-helper elem l1 l2) 
      (if (null? l2) 
          (cons (list-append l1 (cons elem null)) null) 
          (cons (list-append l1 (cons elem l2)) 
                (permutations-insert-helper elem (list-append l1 (cons (car l2) null)) (cdr l2)))))
    (permutations-insert-helper elem null l))
  
  ; Function that is designed to invoke the insert routine for every element in list l and 
  ; return a list of the results
  (define (permutations-helper elem l)
    (if (null? l) 
        null
        (list-append (permutations-insert elem (car l)) (permutations-helper elem (cdr l))))) ; Build up the list of permutations
  
  ; Run the permutations helper function
  (if (null? l)
      '(()) ; short-circuit here so we avoid error with car/cdr later
      (permutations-helper (car l) (list-permutations (cdr l)))))
  
;(list-permutations '(1 2 3))

;; list-permutations tests
(define list-permutations-test01
  (list "list-permutations-test01"
        '((1 2 3))
        '((1 2 3) (2 1 3) (2 3 1) (1 3 2) (3 1 2) (3 2 1))))
(define list-permutations-test02
  (list "list-permutations-test02"
        '((1))
        '((1))))
(define list-permutations-test03
  (list "list-permutations-test03"
        '(())
        '(())))
(define list-permutations-test04
  (list "list-permutations-test04"
        '((a b))
        '((a b) (b a))))
(define list-permutations-test05
  (list "list-permutations-test05"
        '((a b c d))
        '((a b c d)
          (b a c d)
          (b c a d)
          (b c d a)
          (a c b d)
          (c a b d)
          (c b a d)
          (c b d a)
          (a c d b)
          (c a d b)
          (c d a b)
          (c d b a)
          (a b d c)
          (b a d c)
          (b d a c)
          (b d c a)
          (a d b c)
          (d a b c)
          (d b a c)
          (d b c a)
          (a d c b)
          (d a c b)
          (d c a b)
          (d c b a))))
(define list-permutations-tests
  (list list-permutations-test01
        list-permutations-test02
        list-permutations-test03
        list-permutations-test04
        list-permutations-test05))
; Uncomment the following to test your list-permutations procedure.
(run-tests list-permutations (lambda (l1 l2) (list-as-set-equal? equal? l1 l2)) list-permutations-tests)


;; list-argmin
; DEFINE list-argmin HERE
(define (list-argmin f l)
  (if (null? l) 
      #f ; the input list is empty, so return false
      (if (equal? #f (list-argmin f (cdr l)))
          (car l) ; pick the last element in the list by default
          (let*   ; perform a comparison if the list is longer than one element
              ((arg1 (car l))
               (arg2 (list-argmin f (cdr l)))
               (val1 (f arg1))
               (val2 (f arg2)))
            (if (<= val1 val2)
                arg1
                arg2)))))

;; list-argmin tests
(define list-argmin-test01
  (list "list-argmin-test01"
        (list (lambda (x) (* (+ x 3) (+ x 3))) '(-5 -4 -3 -2 -1 0 1 2 3 4 5))
        -3))
(define list-argmin-test02
  (list "list-argmin-test02"
        (list string-length '("zero" "one" "two" "three" "four" "five"))
        "one"))
(define list-argmin-test03
  (list "list-argmin-test03"
        (list (compose - string-length) '("zero" "one" "two" "three" "four" "five"))
        "three"))
(define list-argmin-test04
  (list "list-argmin-test04"
        (list (lambda (x) (+ x 1)) '())
        #f))
(define list-argmin-test05
  (list "list-argmin-test05"
        (list (lambda (x) (if x -1 1)) '())
        #f))
(define list-argmin-test06
  (list "list-argmin-test06"
        (list (lambda (x) (if x -1 1)) '(#f #t #f #t #f))
        #t))
(define list-argmin-test07
  (list "list-argmin-test07"
        (list sin '(-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6))
        5))
(define list-argmin-tests
  (list list-argmin-test01
        list-argmin-test02
        list-argmin-test03
        list-argmin-test04
        list-argmin-test05
        list-argmin-test06
        list-argmin-test07))
; Uncomment the following to test your list-argmin procedure.
(run-tests list-argmin equal? list-argmin-tests)
