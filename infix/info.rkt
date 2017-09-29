#lang info

(define collection "infix")
(define version "0.1")
(define pkg-desc (string-append
                  "A simple infix arithmetic expression evaluator"
                  " using brag (beautiful racket AST (abstract syntax"
                  " tree) generator) and a lexer."))
(define deps '("base"
               "br-parser-tools-lib"
               "brag"))
