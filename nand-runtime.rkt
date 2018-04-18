#lang racket

(provide nand
         while
         puti8
         putc
         endl
         list->values)

(define (nand args)
  (match args
    (`(0 0) '(1))
    (`(1 0) '(1))
    (`(0 1) '(1))
    (`(1 1) '(0))))

(define (list->values lst) (apply values lst))
(define (single-value lst) (unless (= 1 (length lst)) (error 'value-not-single)) (car lst))

(define-syntax while
  (syntax-rules ()
    ((while <exp> <stmts> ...)
     (let loop ()
       (when (= 1 (single-value <exp>))
         <stmts> ... (loop))
       '()))))

(define (binary->number lst)
  (foldr (lambda (x y) (+ (* y 2) x)) 0 lst))

(define (puti8 args)
  (apply (lambda (i1 i2 i3 i4 i5 i6 i7 i8)
           (display (binary->number (reverse (list i1 i2 i3 i4 i5 i6 i7 i8))))
           '(0))
         args))

(define (putc args)
  (apply (lambda (i1 i2 i3 i4 i5 i6 i7 i8)
           (display (integer->char (binary->number (reverse (list i1 i2 i3 i4 i5 i6 i7 i8)))))
           '(0))
         args))

(define (endl args) (newline) '(0))
