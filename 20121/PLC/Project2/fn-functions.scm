#lang scheme

;; Utility functions
; function composition
(define (compose f g) (lambda (x) (f (g x))))
; convenience functions for getting list elements
(define get-1st car)
(define get-2nd (compose get-1st cdr))
(define get-3rd (compose get-2nd cdr))
(define get-4th (compose get-3rd cdr))

(define (list-map f l)
  (if (null? l) '()
      (cons (f (car l)) (list-map f (cdr l)))))
(define (list-unfold f b)
  (let ((z (f b)))
    (if z
        (cons (car z) (list-unfold f (cdr z)))
        null)))

;; Testing functions
(define (run-test proc check test)
  (let ((name (get-1st test))
        (input (get-2nd test))
        (output (get-3rd test)))
    (if (check (apply proc input) output)
        (display (string-append "Test " name " passed.\n"))
        (display (string-append "Test " name " failed.\n")))))
(define (run-tests proc check tests) (for-each (lambda (test) (run-test proc check test)) tests))

;; Part 3: Functions



;; fn-or
; DEFINE fn-or HERE
(define (fn-or f g)
  (lambda (x) (or (f x) (g x))))

;; fn-or tests
(define fn-or-test01
  (list "fn-or-test01"
        (list even? (lambda (x) (< x 5)) 10)
        #t))
(define fn-or-test02
  (list "fn-or-test02"
        (list even? (lambda (x) (< x 5)) 3)
        #t))
(define fn-or-test03
  (list "fn-or-test03"
        (list string? (lambda (x) (< x 5)) 10)
        #f))
(define fn-or-test04
  (list "fn-or-test04"
        (list string? (lambda (x) (< x 5)) 4)
        #t))
(define fn-or-test05
  (list "fn-or-test05"
        (list string? (lambda (x) (< x 5)) "10")
        #t))
(define fn-or-test06
  (list "fn-or-test06"
        (list string? (lambda (x) (< x 5)) "4")
        #t))
(define fn-or-tests
  (list fn-or-test01
        fn-or-test02
        fn-or-test03
        fn-or-test04
        fn-or-test05
        fn-or-test06))
; Uncomment the following to test your fn-or procedure.
(run-tests (lambda (f g x) ((fn-or f g) x)) equal? fn-or-tests)


;; fn-repeat
; DEFINE fn-repeat HERE
(define (fn-repeat f n)
  (lambda (x)
    (if (<= n 0)
        x ; f applied 0 times to x is just x 
        (f ((fn-repeat f (- n 1)) x)))))

;; fn-repeat tests
(define fn-repeat-test01
  (list "fn-repeat-test01"
        (list (lambda (x) (+ x 1)) 10 10)
        20))
(define fn-repeat-test02
  (list "fn-repeat-test02"
        (list (lambda (x) (+ x 1)) 5 10)
        15))
(define fn-repeat-test03
  (list "fn-repeat-test03"
        (list (lambda (x) (+ x 1)) 0 10)
        10))
(define fn-repeat-test04
  (list "fn-repeat-test04"
        (list (lambda (x) (/ x 2)) 10 10)
        5/512))
(define fn-repeat-test05
  (list "fn-repeat-test05"
        (list (lambda (x) (/ x 2)) 5 10)
        5/16))
(define fn-repeat-test06
  (list "fn-repeat-test06"
        (list (lambda (x) (/ x 2)) 0 10)
        10))
(define fn-repeat-test07
  (list "fn-repeat-test07"
        (list (lambda (x) (- x)) 10 10)
        10))
(define fn-repeat-test08
  (list "fn-repeat-test08"
        (list (lambda (x) (- x)) 5 10)
        -10))
(define fn-repeat-test09
  (list "fn-repeat-test09"
        (list (lambda (x) (- x)) 0 10)
        10))
(define fn-repeat-test10
  (list "fn-repeat-test10"
        (list (lambda (x) (string-append "*" x "*")) 10 "X")
        "**********X**********"))
(define fn-repeat-test11
  (list "fn-repeat-test11"
        (list (lambda (x) (string-append "*" x "*")) 5 "X")
        "*****X*****"))
(define fn-repeat-test12
  (list "fn-repeat-test12"
        (list (lambda (x) (string-append "*" x "*")) 0 "X")
        "X"))
(define fn-repeat-tests
  (list fn-repeat-test01
        fn-repeat-test02
        fn-repeat-test03
        fn-repeat-test04
        fn-repeat-test05
        fn-repeat-test06
        fn-repeat-test07
        fn-repeat-test08
        fn-repeat-test09
        fn-repeat-test10
        fn-repeat-test11
        fn-repeat-test12))
; Uncomment the following to test your fn-repeat procedure.
(run-tests (lambda (f n x) ((fn-repeat f n) x)) equal? fn-repeat-tests)


;; fn-clamp
; DEFINE fn-clamp HERE
(define (fn-clamp f low high)
  (lambda (x)
    (let
        ((fVal (f x)))
      (cond
        ((< fVal low) low)
        ((> fVal high) high)
        (else fVal)))))

;; fn-clamp tests
(define fn-ex1 (lambda (x) (+ x 1)))
(define fn-ex2 (lambda (x) (+ (* x x) x 1)))
(define fn-ex3 (lambda (x y) (- x y)))
(define fn-ex4 (lambda (x y) (+ (* x x) y)))
(define first #t)
(define fn-ex5 (lambda (x) (if first (begin (set! first #f) x) (error "fn-ex5 called twice"))))
(define fn-clamp-test01
  (list "fn-clamp-test01"
        (list fn-ex1 0 5 1)
        2))
(define fn-clamp-test02
  (list "fn-clamp-test02"
        (list fn-ex1 0 5 -1)
        0))
(define fn-clamp-test03
  (list "fn-clamp-test03"
        (list fn-ex1 0 5 99)
        5))
(define fn-clamp-test04
  (list "fn-clamp-test04"
        (list fn-ex1 0 5 -99)
        0))
(define fn-clamp-test05
  (list "fn-clamp-test05"
        (list fn-ex2 0 5 1)
        3))
(define fn-clamp-test06
  (list "fn-clamp-test06"
        (list fn-ex2 0 5 -1)
        1))
(define fn-clamp-test07
  (list "fn-clamp-test07"
        (list fn-ex2 0 5 99)
        5))
(define fn-clamp-test08
  (list "fn-clamp-test08"
        (list fn-ex2 0 5 -99)
        5))
(define fn-clamp-test09
  (list "fn-clamp-test09" 
        (list fn-ex5 0 5 2)
        2))
(define fn-clamp-tests
  (list fn-clamp-test01
        fn-clamp-test02
        fn-clamp-test03
        fn-clamp-test04
        fn-clamp-test05
        fn-clamp-test06
        fn-clamp-test07
        fn-clamp-test08
        fn-clamp-test09))
; Uncomment the following to test your fn-clamp procedure.
(run-tests (lambda (f low high x) ((fn-clamp f low high) x)) equal? fn-clamp-tests)


;; fn-arg-swap
; DEFINE fn-arg-swap HERE
(define (fn-arg-swap f)
  (lambda (x y)
    (f y x)))

;; fn-arg-swap tests
(define fn-arg-swap-test01
  (list "fn-arg-swap-test01"
        (list string-append "foo" "bar")
        "barfoo"))
(define fn-arg-swap-test02
  (list "fn-arg-swap-test02"
        (list fn-ex3 3 5)
        2))
(define fn-arg-swap-test03
  (list "fn-arg-swap-test03"
        (list fn-ex4 3 5)
        28))
(define fn-arg-swap-tests
  (list fn-arg-swap-test01
        fn-arg-swap-test02
        fn-arg-swap-test03))
; Uncomment the following to test your fn-arg-swap procedure.
(run-tests (lambda (f x y) ((fn-arg-swap f) x y)) equal? fn-arg-swap-tests)


;; fn-arg-rev
; DEFINE fn-arg-rev HERE
(define (fn-arg-rev f)
  ; Same function defined in list-functions.scm
  (define (list-reverse l)  
    (define (list-reverse-aux l1 l2)
      (if (null? l1) l2
          (list-reverse-aux (cdr l1) (cons (car l1) l2))))
    (list-reverse-aux l '()))
  
  ; Apply the reverse of the argument list
  (lambda vars (apply f (list-reverse vars))))

;; fn-arg-rev tests
(define fn-arg-rev-test01
  (list "fn-arg-rev-test01"
        (list string-append "foo")
        "foo"))
(define fn-arg-rev-test02
  (list "fn-arg-rev-test02"
        (list string-append "foo" "bar")
        "barfoo"))
(define fn-arg-rev-test03
  (list "fn-arg-rev-test03"
        (list string-append "foo" "bar" "qux")
        "quxbarfoo"))
(define fn-arg-rev-test04
  (list "fn-arg-rev-test04"
        (list string-append "foo" "bar" "qux" "plugh")
        "plughquxbarfoo"))
(define fn-arg-rev-test05
  (list "fn-arg-rev-test05"
        (cons string-append (list-map number->string (list-unfold (lambda (n) (if (positive? n) (cons n (- n 1)) #f)) 9)))
        "123456789"))
(define fn-arg-rev-test06
  (list "fn-arg-rev-test06"
        (cons - (list-unfold (lambda (n) (if (positive? n) (cons n (- n 1)) #f)) 9))
        -43))
(define fn-arg-rev-test07
  (list "fn-arg-rev-test07"
        (cons string-append '())
        ""))
(define fn-arg-rev-test08
  (list "fn-arg-rev-test08"
        (cons (lambda a (car (reverse a))) (list-unfold (lambda (n) (if (positive? n) (cons n (- n 1)) #f)) 9))
        9))
(define fn-arg-rev-test09
  (list "fn-arg-rev-test09"
        (list (lambda a (length a)) 0 1 2 3 4 5)
        6))
(define fn-arg-rev-tests
  (list fn-arg-rev-test01
        fn-arg-rev-test02
        fn-arg-rev-test03
        fn-arg-rev-test04
        fn-arg-rev-test05
        fn-arg-rev-test06
        fn-arg-rev-test07
        fn-arg-rev-test08
        fn-arg-rev-test09))
; Uncomment the following to test your fn-arg-rev procedure.
(run-tests (lambda (f . z) (apply (fn-arg-rev f) z)) equal? fn-arg-rev-tests)


;; mk-cr-fn
; DEFINE mk-cr-fn HERE
(define (mk-cr-fn s)
  ; Helper function that appends the right amount of car/cdr calls based on the passed in list of characters
  (define (mk-cr-fn-list l)
    (lambda (x)
      (cond
        ((equal? (car l) #\c) ((mk-cr-fn-list (cdr l)) x))
        ((equal? (car l) #\a) (car ((mk-cr-fn-list (cdr l)) x))) 
        ((equal? (car l) #\d) (cdr ((mk-cr-fn-list (cdr l)) x)))
        (else x))))
  
  ; Convert the string into a list and then call the helper function
  (mk-cr-fn-list (string->list s)))

; mk-cr-fn tests
(define mk-cr-fn-test01
  (list "mk-cr-fn-test01"
        (list "cr" '(1 2 (3 4 5) 6 7))
        '(1 2 (3 4 5) 6 7)))
(define mk-cr-fn-test02
  (list "mk-cr-fn-test02"
        (list "car" '(1 2 (3 4 5) 6 7))
        1))
(define mk-cr-fn-test03
  (list "mk-cr-fn-test03"
        (list "cdr" '(1 2 (3 4 5) 6 7))
        '(2 (3 4 5) 6 7)))
(define mk-cr-fn-test04
  (list "mk-cr-fn-test04"
        (list "cadr" '(1 2 (3 4 5) 6 7))
        '2))
(define mk-cr-fn-test05
  (list "mk-cr-fn-test05"
        (list "cddr" '(1 2 (3 4 5) 6 7))
        '((3 4 5) 6 7)))
(define mk-cr-fn-test06
  (list "mk-cr-fn-test06"
        (list "caddr" '(1 2 (3 4 5) 6 7))
        '(3 4 5)))
(define mk-cr-fn-test07
  (list "mk-cr-fn-test07"
        (list "caaddr" '(1 2 (3 4 5) 6 7))
        '3))
(define mk-cr-fn-test08
  (list "mk-cr-fn-test08"
        (list "cdaddr" '(1 2 (3 4 5) 6 7))
        '(4 5)))
(define mk-cr-fn-test09
  (list "mk-cr-fn-test09"
        (list "cadaddr" '(1 2 (3 4 5) 6 7))
        '4))
(define mk-cr-fn-test10
  (list "mk-cr-fn-test10"
        (list "cddaddr" '(1 2 (3 4 5) 6 7))
        '(5)))
(define mk-cr-fn-test11
  (list "mk-cr-fn-test11"
        (list "caddaddr" '(1 2 (3 4 5) 6 7))
        '5))
(define mk-cr-fn-test12
  (list "mk-cr-fn-test12"
        (list "cdddaddr" '(1 2 (3 4 5) 6 7))
        '()))
(define mk-cr-fn-test13
  (list "mk-cr-fn-test13"
        (list "cdddr" '(1 2 (3 4 5) 6 7))
        '(6 7)))
(define mk-cr-fn-test14
  (list "mk-cr-fn-test14"
        (list "cadddr" '(1 2 (3 4 5) 6 7))
        '6))
(define mk-cr-fn-test15
  (list "mk-cr-fn-test15"
        (list "cddddr" '(1 2 (3 4 5) 6 7))
        '(7)))
(define mk-cr-fn-test16
  (list "mk-cr-fn-test16"
        (list "caddddr" '(1 2 (3 4 5) 6 7))
        '7))
(define mk-cr-fn-test17
  (list "mk-cr-fn-test17"
        (list "cdddddr" '(1 2 (3 4 5) 6 7))
        '()))
(define mk-cr-fn-tests
  (list mk-cr-fn-test01
        mk-cr-fn-test02
        mk-cr-fn-test03
        mk-cr-fn-test04
        mk-cr-fn-test05
        mk-cr-fn-test06
        mk-cr-fn-test07
        mk-cr-fn-test08
        mk-cr-fn-test09
        mk-cr-fn-test10
        mk-cr-fn-test11
        mk-cr-fn-test12
        mk-cr-fn-test13
        mk-cr-fn-test14
        mk-cr-fn-test15
        mk-cr-fn-test16
        mk-cr-fn-test17))
; Uncomment the following to test your fn-arg-rev procedure.
(run-tests (lambda (s l) ((mk-cr-fn s) l)) equal? mk-cr-fn-tests)
