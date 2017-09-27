#lang racket

;; we define a read-syntax maker, so we can easily derive the flavour simple/ci
(define (make-read-syntax (re #rx"(simple\\.)?"))
  (λ (path in)
    (define lines (port->lines in))
    (define match? (λ (it) (regexp-match-exact? re it)))
    (if (andmap match? lines)
        #'(module simple-mod racket (displayln "This is     simple."))
        #'(module simple-mod racket (displayln "This is NOT simple.")))))
(provide make-read-syntax)

(define read-syntax (make-read-syntax))
(provide read-syntax)