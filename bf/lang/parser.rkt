#lang brag

program : ( instruction | loop )*
instruction : "+" | "-" | "<" | ">" | "," | "."
loop : /"[" @program /"]"