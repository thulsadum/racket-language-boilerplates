#lang racket

(require brag/support)


(define-tokens OPERANDS [NUMBER])
(define-empty-tokens OPERATORS [PLUS MINUS TIMES BY
                                     LPAR RPAR NL])

(define (make-infix-tokenizer in)
  (port-count-lines! in)
  (define (next-token)
    (define infix-lexer
      (lexer-srcloc
       [(eof) eof]
       [#\newline (token-NL)]
       [(:+ whitespace) (return-without-srcloc (next-token))] ; skip white spaces
       [(:: #\; (:* (:~ #\newline))) (return-without-srcloc (next-token))] ; skip comments
       [(:+ numeric) (token-NUMBER lexeme)]
       [#\+ (token-PLUS)]
       [#\- (token-MINUS)]
       [#\* (token-TIMES)]
       [#\/ (token-BY)]
       [#\( (token-LPAR)]
       [#\) (token-RPAR)]))
    (infix-lexer in))
  next-token)
(provide make-infix-tokenizer)

