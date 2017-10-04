#lang racket

(provide #%app #%top)
(provide #%datum)

(struct state (left right) #:transparent)

(define empty-state (state empty empty))
(provide empty-state)

(define (load st)
  (if (empty? (state-right st))
      0
      (car (state-right st))))
(provide load)

(define (store st x)
  (let ([x (modulo x 256)])
    (if (empty? (state-right st))
        (state (state-left st)
               (list x))
        (state (state-left st)
               (cons x (cdr (state-right st)))))))
(provide store)

(define (right st)
  (if (empty? (state-right st))
      (state (cons 0 (state-left st))
             empty)
      (state (cons (car (state-right st)) (state-left st))
             (cdr (state-right st)))))
(provide right)

(define (left st)
  (if (empty? (state-left st))
      (state empty
             (cons 0 (state-right st)))
      (state (cdr (state-left st))
             (cons (car (state-left st)) (state-right st)))))
(provide left)

(define (id x) x)
(provide id)

(define comp->
  (case-lambda
    [(f g)
     (λ (x)
       (g (f x)))]
    [funcs (foldr comp-> id funcs)]))
(provide comp->)


(define-syntax (program stx)
  (syntax-case stx ()
    [(_) #'(id)]
    [(_ EXPRS ...)
     #'(λ (st)
         ((comp-> EXPRS ...) st))]))
(provide program)

(define-syntax (loop stx)
  (syntax-case stx ()
    [(_) #'(λ (st)
             (define (-loop st) (if (not (= 0 (load st)))
                                    (-loop st)
                                    st))
             (-loop st))]
    [(_ EXPRS ...)
     #'(λ (st)
         (define (-loop st) (if (not (= 0 (load st)))
                                (-loop ((comp-> EXPRS ...) st))
                                st))
         (-loop st))]))
(provide loop)

(define-syntax (instruction stx)
  (syntax-case stx ()
    [(_ "+") #'(λ (st) (store st (add1 (load st))))]
    [(_ "-") #'(λ (st) (store st (sub1 (load st))))]
    [(_ ".") #'(λ (st) (write-byte (load st)) st)]
    [(_ ",") #'(λ (st) (store (read-byte)))]
    [(_ ">") #'right]
    [(_ "<") #'left]))
(provide instruction)


(define-syntax-rule (bf-mb AST ...)
  (#%module-begin
   (AST ... empty-state)))
(provide (rename-out [bf-mb #%module-begin]))