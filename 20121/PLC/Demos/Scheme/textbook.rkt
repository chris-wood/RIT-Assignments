#lang scheme

; lambda creates arbitrary/anonymous functions, let and define allow you to specify a name...

; let defines some small scope (think of each pair as symbol => expression/value)
(let ((a 3)
      (b 4)
      (square (lambda (x) (* x x)))
      (plus +))
  (sqrt (plus (square a) (square b)))
  (plus (square a) (square b))) ; only the last expression is evaluated and displayed...

