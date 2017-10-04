#lang racket

(require "scanner.rkt" "parser.rkt")

(define (read-syntax path in)
  (define tokenizer (make-tokenizer in))
  (define ast (parse path tokenizer))
  (datum->syntax #f
                 `(module bf-mod brainfuck/expander
                    ,ast)))
(provide read-syntax)