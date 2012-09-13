#lang scheme

; usage: (fact N)
(define (fact n)
  (if (<= n 0) 1 (* n (fact (- n 1)))))

; cons == construct(build up ordered pairs in proper lists)
; append l1 to l2

;;;;;
; plc-append is O(n), where n is hte length of l1
; plc-append builds a new list
; the argument lists l1 and l2 are unchanged // no mutable state in scheme
;;;;;
(define (plc-append l1 l2)
  (cond
    ((null? l1) l2)
    ((null? l2) l1)
    (else (cons (car l1)
                (plc-append(cdr l1) l2))))) ; recursively strip off elements from l1 and drop them on to l2 with cons 

;;;;;
; plc-reverse is O(n^2)
; plc-reverse builds a new list
; the argument list l is unchanged
;;;;;
(define (plc-reverse l) ; what kind of list do we have? first question to ask...
  (if (null? l)
      null
      (plc-append (plc-reverse (cdr l)) (list (car l))))) ; append the reverse of (cdr l) onto 
; ex: (1 2 3) -> ((2 3) 1) -> ((3 2) 1) -> (3 2 1)
; you can use list 1 2 3 4... or '(1 2 3 4)...

; let's imrpove performance by keeping a secondary list handy to improve performance 
; linear time in length of l1

;;;;;
; plc-reverse-aux is O(n)
; plc-reverse-aux builds a new list
; the argument list l is unchanged
;;;;;
; NOTE: we can define plc-reverse-aux within body of plc-reverse and then call it explicitly as interface...
(define (plc-reverse-aux l rl)
  (if (null? l)
      rl ; return rl if l is null
      (plc-reverse-aux (cdr l) (cons (car l) rl))))


;;;;;;;;;;;;;;;;
; These below have the exact same structure, except for the function applied to the lis

; increment every list element by 1
#|
(define (plc-inc-list l)
  (if (null? l)
      null
      (cons (+ (car l) 1) (plc-inc-list (cdr l))))) ; 1 + cdr of list recursively

; square every element in the list
(define (plc-sqr-list l)
  (if (null? l)
      null
      (cons (* (car l) (car l)) (plc-sqr-list (cdr l)))))
|#

; Solution: apply higher order functions to pass one as an argument to apply to the list!
(define (plc-map f l)
  (if (null? l)
      null
      (cons (f (car l)) ( plc-map f (cdr l)))))
; now we just define the functions to be passed into the map
(define (plc-inc-list l) (plc-map (lambda (x) (+ 1 x)) l))
(define (plc-sqr-list l) (plc-map (lambda (x) (* x x)) l))

; define syntax is (define id expr) or (define (head param-list) body)
; Usage: (plc-filter (lambda (x) (> x 0)) '(-2 -1 0 1 2))
; Usage: (plc-filter odd? '(-2 -1 0 1 2))
(define (plc-filter f l)
  (if (null? l)
      null
      (if (f (car l))
          (cons (car l) (plc-filter f (cdr l)))
          (plc-filter f (cdr l)))))

; Usage: (plc-sum-list '(1 2 3 4 5))
#|
(define (plc-sum-list l)
  (if (null? l)
      0
      (+ (car l) (plc-sum-list (cdr l)))))
  
(define (plc-prod-list l)
  (if (null? l)
      1
      (* (car l) (plc-prod-list (cdr l)))))
|#

; The operator and base case changed here! Let's make it better...

; Signature (for a fold): operator, base case, list as parameters
(define (plc-foldr f b l)
  (if (null? l)
      b
      (f (car l) (plc-foldr f b (cdr l)))))
(define (plc-sum-list l) (plc-foldr (lambda (x y) (+ x y)) 0 l))
(define (plc-prod-list l) (plc-foldr * 1 l))

(define (swap-args f)
  (lambda (x y) (f y x)))
;(define (swap-args f x y) (f y x)) ; not useful, since calling this assumes we already have the functions at hand so why even call this?
; partial application: (lambda (l) (plc-foldr * l))

(define (plc-foldl f b l)
  (if (null? l)
      b
      (plc-foldl f (f (car l) b) (cdr l)))) ; we replace the base case! and pass it up recursively...

(define (compose f g)
  (lambda (x) (f (g x))))
; (define (compose f g x) ... ) -> not useful! same reason for swap

;;;

; enables good separation of concerns
(define (mk-point x y z) (cons x (cons y z)))
(define (get-x pt) (car pt))
(define (get-y pt) (car (cdr pt)))
(define (get-z pt) (cdr (cdr pt)))

; Let's make a bibtex file! See how we build up the data structures and then access based on the type
(define (mk-book author title) (list 'book author title))
(define (mk-article author title journal) (list 'article journal author title))
(define (mk-thesis author title institution) (list 'thesis author title institution))

(define (get-kind w) (car w))
(define (get-author w) 
  (let ((kind (get-kind w)))
    (cond
      ((equal? kind 'book) (car (cdr w)))
      ((equal? kind 'article) (car (cdr (cdr w))))
      ((equal? kind 'thesis) (car (cdr w))))))
      
(define (get-title w)
  (let ((kind (get-kind w)))
    (cond
      ((equal? kind 'book) (car (cdr (cdr w))))
      ((equal? kind 'article) (car (cdr (cdr (cdr w)))))
      ((equal? kind 'thesis) (car (cdr (cdr w)))))))

;; Binary trees
(define leaf (list 'leaf))
(define (node l x r) (list 'node l x r))
(define (get-node-l n) (cadr n))
(define (get-node-x n) (caddr n))
(define (get-node-r n) (cadddr n))
(define (leaf? x) (equal? x (list 'leaf))) ; using equal? (car x) 'list won't work because 1) x might not be a const and 2) might be a list of longer than 1 element!
(define (node? x) (and (list? x)
                       (equal? (length x) 4)
                       (equal? (car x) 'node)))
(define (btree? x)
  (or (leaf? x) 
      (and (node? x)
          (and (btree? (get-node-l x))
               (btree? (get-node-r x))))))

(define (btree->list bt) 
  (if (leaf? bt)
      null ; leaf has no elements
      (append (btree->list (get-node-l bt)) 
              (list (get-node-x bt)) 
              (btree->list (get-node-r bt)))))

(define (btree->map f bt) 
  (if (leaf? bt)
      leaf
      (node (btree->map f (get-node-l bt))
            (f (get-node-x bt))
            (btree->map f (get-node-r bt)))))
    
(define (btree->fold f b bt) ; see notes for the fold purpose...
  (if (leaf? bt)
      b
      (f (btree->fold f b (get-node-l bt))
         (f (get-node-x bt))
         (btree->fold f b (get-node-r bt)))))
    
; how can we check sorted using fold? function hands back two pieces of data