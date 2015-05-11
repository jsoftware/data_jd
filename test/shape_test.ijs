NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. shape tests for insert/update/modify

ED=: 'domain error'

rd=:3 : 0
jd'reads from ',T
)

ins=: 3 : 0
jd'insert';T;,N,.y
:
try.
 jd'insert';T;,N,.y
 assert 0
catch.
 assert (<x)e.;:>;1{jdlast
end.
)

mod1=: 3 : 0
jd 'modify';T;'w=0';,N,.y
:
try.
 jd'modify';T;'w=0';,N,.y
 assert 0
catch.
 assert (<x)e.;:>;1{jdlast
end.
)

mod2=: 3 : 0
jd 'modify';T;'w in (1,2)';,N,.y
:
try.
 jd'modify';T;'w in (1,2)';,N,.y
 assert 0
catch.
 assert (<x)e.;:>;1{jdlast
end.
)

foo=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f w  int'
jd'createcol f i  int'
jd'createcol f i2 int  2'
jd'createcol f b  byte'
jd'createcol f b2 byte 2'
)

T=: 'f'
N=: 'w';'i';'i2';'b';'b2'

NB. insert
NB. count and shape rules are the same for insert and update
NB. insert does not extend items
NB. count of all column data must be the same
NB. current implementaton limit and might be relaxed in the future

foo''
ins 0;23;(1 2$23 23);'a';1 2$'a' 
ins 1 2;6 6;(2 2$6);'xx';2 2$'x'
'count' ins 1 2;6 6;(3 2$6);'xx';2 2$'x'
'shape' ins 1 2;6 6;(2 3$6);'xx';2 2$'x'

foo''
ins 0;23;(1 2$23 23);'a';1 2$'a' 
ins 1 2;6 6;(2 2$6);'xx';2 1$'x' NB. {. byte 2

NB. modify
NB. modify shape rules similar to insert but allow item to extend

mod1 0;24;(1 2$23 23);'b';1 2$'a'
mod2 1 2;7 7;(2 2$7);'ww';2 2$'w'
mod2 1 2;8;9 9;'w';'yy'           NB. item extends
mod2 1 2;6 6;(2 2$6);'mm';2 1$'g' NB. {. byte 2
'count' mod1 1 2;6 6;(3 2$6);'xx';2 2$'x'
'shape' mod2 1 2;6 6;(2 3$6);'xx';2 2$'x'

foo=: 3 : 0
jdadminx'test'
jd'createtable f w int, i int,i1 int 1, i2 int 2'
)
foo''
N=: 'w';'i';'i1';'i2'

ins   0  ; a    ; (1 1$a) ; 1 2$a=. 1
ins  1 2 ; (2$a) ; (2 1$a) ; 2 2$a=. 2
mod1 0      ; a     ; (1 1$a) ; 1 2$a=. 3
mod2 1 2 ; (2$a) ; (2 1$a) ; 2 2$a=. 4

foo=: 3 : 0
jdadminx'test'
jd'createtable f w int, i int,i1 int 1, i2 int 2, b byte, b1 byte 1, b2 byte 2'
)
foo''
N=: 'w';'i';'i1';'i2';'b';'b1';'b2'

ins  0   ;1   ; (,2)      ; (1 2$3 4)     ; 'a'  ; (,'b')    ; 1 2$'cd'
ins  1 2 ;2 3 ; (2 1$3 4) ; (2 2$5 6 7 8) ; 'ab' ; (2 1$'c') ; 2 2$'e'
mod1 0   ;6   ; (,6)      ; (1 2$6)       ; 'k'  ; (,'k')    ; 1 2$'k'
mod2 1 2 ;2 3 ; (2 1$3 4) ; (2 2$5 6 7 8) ; 'ab' ; (2 1$'c') ; 2 2$'e'
