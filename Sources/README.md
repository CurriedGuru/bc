Lexical tokens
--------------

keywords: for, while, break, continue, halt, return, if, else, define

variables: [a-z][a-z0-9_]*

special variables: scale, ibase, obase, last

comment start: /*
comment end: */
single-line comment start: #

operators:
+    add
-    subtract
++   pre-increment
++   post-increment
--   pre-decrement
--   post-decrement
*    multiply
/    divide
^    to the power of
(    open brace
)    close brace
=    assign
>    greater
<    lesser
<=   lesser than or equal to
>=   greater than or equal to
==   equal to
!=   not equal to
!    not
&&   and
||   or
;    semicolon

number: [0-9]*\.?[0-9]*

string: \"[.]*\"

Observations:
------------
By default, every unassigned var has a value of 0.
-----
puskulka : ~/bc/Sources/bc >  echo "s" | bc
0
puskulka : ~/bc/Sources/bc >  echo "s+1" | bc
1
puskulka : ~/bc/Sources/bc >  echo "s+19.12121" | bc
19.12121
puskulka : ~/bc/Sources/bc >  echo "s+k" | bc
0
-----

----
puskulka : ~/bc/Sources/bc >  echo "a=[1,2,3]" | bc
puskulka : ~/bc/Sources/bc >  vi README.md 
puskulka : ~/bc/Sources/bc >  echo "A=1" | bc
(standard_in) 1: parse error
puskulka : ~/bc/Sources/bc >  echo "a=1" | bc
puskulka : ~/bc/Sources/bc >  ls
Lexer.swift README.md   main.swift
puskulka : ~/bc/Sources/bc >  vi README.md 
puskulka : ~/bc/Sources/bc >  echo "a_9=1" | bc
puskulka : ~/bc/Sources/bc >  echo "_a9=1" | bc
(standard_in) 1: illegal character: _
puskulka : ~/bc/Sources/bc >  echo "a_=1" | bc
puskulka : ~/bc/Sources/bc >  echo "_a=1" | bc
(standard_in) 1: illegal character: _
puskulka : ~/bc/Sources/bc > 
----


