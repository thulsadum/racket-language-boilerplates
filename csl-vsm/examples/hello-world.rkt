#lang csl-vsm
; Labels are written as a name without whitespace
; and a colon at the end.

main:
   72 out          ; "H"
  101 out          ; "e"
  108 dup out out  ; "ll"
  111 out          ; "o"
   33 out          ; "!"

  ; newline
  '\n' out

  42 outnum     ; print a number
  '\n' out      ; and newline

  ; stop program
  halt