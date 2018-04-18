#lang racket

(require peg/peg)
(require "nand-parser.rkt")

(provide nand->scheme)

(define (print p) (pretty-print p) (newline))

(define (nand->scheme prg)
  (match prg
    (`(program . ,funcs)
     `(begin . ,(map nand->scheme:func funcs)))))
(define (nand->scheme:func f)
  (match f
    (`(func (name . ,nm) (args . ,args-in) (args . ,args-out) . ,body)
     (let* ((outs (map nand->scheme:name args-out))
            (out-binds (map (lambda (v) (list v 0)) outs)))
       `(define (,(string->symbol nm) args)
          (apply (lambda ,(map nand->scheme:name args-in)
             (let ,out-binds
               . ,(append (map nand->scheme:stmt body)
                          (list `(list . ,outs)))))
           args))))
    (`(func (name . ,nm) . ,body)
     (nand->scheme:func `(func (name . ,nm) (args . ()) (args . ()) . ,body)))))
(define (nand->scheme:stmt stmt)
  (match stmt
    (`(assign_stmt (args . ,args) (expr . ,nexpr))
     `(set!-values ,(map nand->scheme:name args) (list->values ,(nand->scheme:nand-expr nexpr))))
    (`(decl_stmt (assign_stmt (args . ,args) (expr . ,nexpr)))
     `(define-values ,(map nand->scheme:name args) (list->values ,(nand->scheme:nand-expr nexpr))))
    (`(if_stmt ,exp . ,body)
     `(when (equal? '(1) ,(nand->scheme:exp exp))
        . ,(map nand->scheme:stmt body)))
    (`(while_stmt ,exp . ,body)
     `(while ,(nand->scheme:exp exp)
             . ,(map nand->scheme:stmt body)))
    (else `(error 'unknown ',stmt))))

(define (nand->scheme:name nm)
  (match nm
    (`(name . ,e)
     (string->symbol e))))

(define (nand->scheme:nand-expr nexpr)
  (match nexpr
    (`(,a (NAND) . ,as)
     `(nand (append ,(nand->scheme:exp a) ,(nand->scheme:nand-expr as))))
    (`(,a)
     (nand->scheme:exp a))))

(define (nand->scheme:exp e)
  (match e
    (`(expr . ,nexpr)
     (nand->scheme:nand-expr nexpr))
    (`(var_expr name . ,nm)
     `(list ,(string->symbol nm)))
    (`(const_expr . "0")
     `(list 0))
    (`(const_expr . "1")
     `(list 1))
    (`(funcall_expr (name . ,f) . ,args)
     `(,(string->symbol f) (append . ,(map nand->scheme:exp args))))))

;(print (nand->scheme (peg program t1)))
