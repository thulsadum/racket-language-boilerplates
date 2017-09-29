#lang racket

(provide #%module-begin #%app #%datum #%top #%top-interaction)


(define (exprs . results)
  (for-each displayln results))
(provide exprs)

(define (num str)
  (with-input-from-string str read))
(provide num)

(define (add . es) (apply + es))
(provide add)

(define (mul . es) (apply * es))
(provide mul)