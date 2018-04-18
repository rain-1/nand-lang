#lang racket

(module reader racket
  (require syntax/strip-context)
  
  (require peg/peg)
  (require nand-lang/nand-parser)
  (require nand-lang/nand-transform)
  
  (provide (rename-out [literal-read read]
                       [literal-read-syntax read-syntax]))
  
  (define (nand-lang->scheme in)
    (nand->scheme (car (peg (and program (! (any-char))) (port->string in)))))
  
  (define (literal-read in)
    (syntax->datum
     (literal-read-syntax #f in)))
  
  (define (literal-read-syntax src in)
    (with-syntax ([body (nand-lang->scheme in)])
      (strip-context
       #'(module anything racket
           (provide (all-defined-out))
           (require nand-lang/nand-runtime)
           body
           (main '())))))

  )
