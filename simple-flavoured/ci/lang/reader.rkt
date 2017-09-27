#lang racket

(require simple/lang/reader)

(define read-syntax (make-read-syntax #rx"(?i:(simple\\.)?)"))
(provide read-syntax)