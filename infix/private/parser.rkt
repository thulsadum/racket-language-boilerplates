#lang brag

exprs   : ( expr /NL )*
@expr   : term | ( add|minus )+
add     : term /PLUS expr
minus   : term /MINUS expr
@term   : factor | ( mul|div )+
mul     : factor /TIMES term
div     : factor /BY term
@factor : /LPAR expr /RPAR | num
num     : NUMBER