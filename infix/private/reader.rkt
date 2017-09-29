#lang racket

(require "../scanner.rkt")
(require "parser.rkt")

(define (read-syntax path in)
  (define tokenizer (make-infix-tokenizer in))
  (define ast (parse path tokenizer))
  (datum->syntax #f
                 `(module infix-mod infix/expander
                    ,ast)))
(provide read-syntax)