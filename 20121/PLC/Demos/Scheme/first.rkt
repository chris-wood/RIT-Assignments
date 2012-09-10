#lang scheme

; use: (fact N)
(define (fact n)
  (if (<= n 0) 1 (* n (fact (- n 1)))))

; cons == construct(build up ordered pairs in proper lists)
; append l1 to l2
(define (plc-append l1 l2)
  (cond
    ((null? l1) l2)
    ((null? l2) l1)
    (else (cons (car l1)
                (plc-append(cdr l1) l2))))) ; recursively strip off elements from l1 and drop them on to l2 with cons 

(define (plc-reverse l) ; what kind of list do we have? first question to ask...
  (if (null? l)
      null
      (plc-append (plc-reverse (cdr l)) (list (car l))))) ; append the reverse of (cdr l) onto 
; ex: (1 2 3) -> ((2 3) 1) -> ((3 2) 1) -> (3 2 1)
; you can use list 1 2 3 4... or '(1 2 3 4)...

; let's imrpove performance by keeping a secondary list handy to improve performance 
(define (plc-reverse-aux l rl)
  (if (null? l)
      rl ; return rl if l is null
      (plc-reverse-aux (cdr l) (cons (car l) rl))))