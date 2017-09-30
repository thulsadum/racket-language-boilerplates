#lang racket

;; lexer for the csl-vsm assembly language

(require brag/support)
(require br-parser-tools/lex)

(module+ test
  (require rackunit)

  (define-syntax-rule (tst S)
    (map srcloc-token-token 
         (apply-tokenizer-maker make-tokenizer S))))

;; a quick convenience alias
(define-syntax-rule (skip-srcloc NAME)
  (return-without-srcloc (NAME input-port)))


;; some empty programs
(module+ test
  (check-equal? (tst "")
                empty)
  (check-equal? (tst "\t  \n")
                empty)
  (check-equal? (tst "  \n; a comment without linebreak!")
                empty))


(define-empty-tokens insructions (NOP ADD SUB AND OR XOR NOT IN
                                      OUT LOAD STOR JMP JZ PUSH
                                      DUP SWAP ROL3 OUTNUM JNZ
                                      DROP PUSHIP POPIP DROPIP
                                      COMPL HALT))

(module+ test
  ;; test instructions
  (check-equal? (tst (string-append "nop add sub and or xor not in out load stor jmp jz push dup\n"
                                    " swap rol3 outnum jnz drop puship popip dropip compl halt"))
                '(NOP ADD SUB AND OR XOR NOT IN OUT LOAD STOR JMP JZ PUSH DUP
                      SWAP ROL3 OUTNUM JNZ DROP PUSHIP POPIP DROPIP COMPL HALT)))

;; TODO add HEX, OCT, BIN or even p-adic literals?
(define-tokens literals (NUMLIT))

(module+ test
  ;; test literals
  (check-equal? (map token-name (tst "1234 'f' 'o' 'o' '\n'"))
                '(NUMLIT NUMLIT NUMLIT NUMLIT NUMLIT))
  (check-equal? (map token-value (tst "1234 'f' 'o' 'o' '\n' '\r'"))
                '(1234 102 111 111 10 13)))

(define-tokens label-operations (RESOLVE DEFINE CALL))

(define-lex-abbrev identifier (:+ (:~ whitespace #\:)))

(define csl-vsm-lexer
  (lexer-srcloc
   [(eof) eof]
   [(:+ whitespace) (skip-srcloc csl-vsm-lexer)]
   [(:: #\; (:* (:~ #\newline))) (skip-srcloc csl-vsm-lexer)]
   ["nop" (token-NOP)]
   ["add" (token-ADD)]
   ["sub" (token-SUB)]
   ["and" (token-AND)]
   ["or"  (token-OR)]
   ["xor" (token-XOR)]
   ["not" (token-NOT)]
   ["in" (token-IN)]
   ["out" (token-OUT)]
   ["load" (token-LOAD)]
   ["stor" (token-STOR)]
   ["jmp" (token-JMP)]
   ["jz" (token-JZ)]
   ["push" (token-PUSH)]
   ["dup" (token-DUP)]
   ["swap" (token-SWAP)]
   ["rol3" (token-ROL3)]
   ["outnum" (token-OUTNUM)]
   ["jnz" (token-JNZ)]
   ["drop" (token-DROP)]
   ["puship" (token-PUSHIP)]
   ["popip" (token-POPIP)]
   ["dropip" (token-DROPIP)]
   ["compl" (token-COMPL)]
   ["halt" (token-HALT)]
   [(from/to #\' #\') (handle-char-lit (trim-ends "'" lexeme "'"))]
   [(:+ numeric) (token-NUMLIT (with-input-from-string lexeme read))]
   [(:: #\& identifier) (token-RESOLVE (substring lexeme 1))]
   [(:: identifier #\:) (token-DEFINE (substring lexeme 0 (sub1 (string-length lexeme))))]
   [identifier (token-CALL lexeme)]))

(define (handle-char-lit val)
  (token-NUMLIT
   (char->integer
    (if (equal? (string-ref val 0) #\\)
        (match (string-ref val 1)
          [#\n #\newline]
          [#\r #\return]
          [#\t #\tab]
          [_ (string-ref val 1)])
        (string-ref val 0)))))

(module+ test
  (define hello #<<EOD
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
EOD
    )
  (check-equal? (map (λ (it) (cons (token-name it) (token-value it))) (tst hello))
                '((DEFINE . "main")
                  (NUMLIT . 72) (OUT . #f)
                  (NUMLIT . 101) (OUT . #f)
                  (NUMLIT . 108) (DUP . #f) (OUT . #f) (OUT . #f)
                  (NUMLIT . 111) (OUT . #f)
                  (NUMLIT . 33) (OUT . #f)
                  (NUMLIT . 10) (OUT . #f)
                  (NUMLIT . 42) (OUTNUM . #f)
                  (NUMLIT . 10) (OUT . #f)
                  (HALT . #f))))

(define (make-tokenizer in)
  (port-count-lines! in)
  (λ () (csl-vsm-lexer in)))
(provide make-tokenizer)