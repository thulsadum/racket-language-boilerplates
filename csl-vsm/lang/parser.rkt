#lang brag

program : ( definition | resolve | call | instruction | pushi )*

definition : DEFINE
resolve : RESOLVE
call : CALL

@instruction : NOP | ADD | SUB | AND | OR | XOR | NOT |
              IN | OUT | LOAD | STOR | JMP | JZ | PUSH |
              DUP | SWAP | ROL3 | OUTNUM | JNZ | DROP |
              PUSHIP | POPIP | DROPIP | COMPL | HALT

pushi : NUMLIT