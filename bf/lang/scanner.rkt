#lang racket

(require brag/support)

(module+ test
  (println (apply-tokenizer-maker make-tokenizer " + - < > [ \n ] . , weg")))

(define bf-lexer
  (lexer-srcloc
   [(eof) eof]
   [(char-set "+-<>[].,") lexeme]
   [any-char (return-without-srcloc (bf-lexer input-port))]))

(define (make-tokenizer in)
  (port-count-lines! in)
  (λ () (bf-lexer in)))
(provide make-tokenizer)