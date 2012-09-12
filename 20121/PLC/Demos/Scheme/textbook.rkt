#lang scheme

; lambda creates arbitrary/anonymous functions, let and define allow you to specify a name...

; let defines some small scope (think of each pair as symbol => expression/value)
(let ((a 3)
      (b 4)
      (square (lambda (x) (* x x)))
      (plus +))
  (sqrt (plus (square a) (square b)))
  (plus (square a) (square b))) ; only the last expression is evaluated and displayed...

(define x (+ 2 2))

(let ((x 2)
      (l '(a b)))
  (set! x 3))
  ;(set-car! l '(1 2 3))
  ;(set-cdr! l '(c)))

(define compose 
  (lambda (f g) ; compose is a function that takes f and g as inputs
    (lambda (x) (f (g x))))) ; returns a function that takes x as an input, and then does f(g(x)) -> composition

(define compose2
  (lambda (f g)
    (eval (list 'lambda '(x) (list f(list g 'x))))))
          ;(scheme-report-environment 5)))) ; invalid?!

; DFA from the book! page 520
(define simulate
  (lambda (dfa input)
    (cons (current-state dfa)
          (if (null? input)
              (if (infinal? dfa) '(accept) '(reject))
              (simulate (move dfa (car input)) (cdr input))))))

;; access functions for machine description
(define current-state car)
(define transition-function cadr)
(define final-states caddr)
(define infinal?
  (lambda (dfa)
    (memq (current-state dfa) (final-states dfa))))

(define move 
  (lambda (dfa symbol)
    (let ((cs (current-state dfa)) (trans (transition-function dfa)))
      (list
       (if (eq? cs 'error)
           'error
           (let ((pair (assoc (list cs symbol) trans)))
             (if pair (cadr pair) 'error))) ; new start state
       trans ; same transition function
       (final-states dfa))))) ; same final states

(define zero-one-even-dfa
  '(q0
  (((q0 0) q1) ((q0 1) q1) ((q1 0) q3) ((q1 1) q0) ((q2 0) q0) ((q2 1) q3) ((q3 0) q1) ((q3 1) q2))
  (q0)))

; sample call...
;(simulate 
   ;zero-one-even-dfa
   ;'(0 1 1 0 1))
