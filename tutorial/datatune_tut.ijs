NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. custom.ijs can define datatune - applied to all insert/update data
NB. custom.ijs can also define db ops (see custom tutorial)

NB. insert/update calls db datatune_table
NB. x is list of names:  'jdn'      ;value names
NB. y is list of values: (col names);values

custom=: 0 : 0 rplc 'RPAREN';')'

datatune_f=: 4 : 0
(x)=. y NB. local names assigned with valuse
assert *./a>0['datatune f a>0'
b=. >:a
".each jdn NB. return values for col names
RPAREN

datatune_g=: 4 : 0
(x)=. y
b=: >2{.each v
".each jdn
RPAREN

datatune_h=: 4 : 0
(x)=. y
c=. a,.,b
".each jdn
RPAREN

datatune_i=: 4 : 0
(x)=. y
'y m d'=. |:10000 100 100 #:ymd
".each jdn
RPAREN
)

jdadminx'test'
custom fwrite '~temp/jd/test/custom.ijs'
jd'loadcustom'

asserterror=: 3 : 'assert y-:(#y){.;1{jdlast'

jd'droptable f'
jd'createtable';'f';'a int,b int'
jd'insert';'f';'a';23
jd'insert';'f';'a';24 25
jd'update';'f';'a=23';'a';66
({."1 d)=. {:"1 d=. jd'read from f'
assert a=24 25 66
assert b=25 26 67
jd etx 'insert';'f';'a';0 NB. error thrown for bad b

jd'droptable g'
jd'createtable';'g';'v varbyte,b byte 2'
jd'insert';'g';'v';<'abc';'qewr'
({."1 d)=. {:"1 d=. jd'read from g'
assert b-:2 2$'abqe'

NB. c int 2 col derived by combining a b int cols - c used as unique
jd'droptable h'
jd'createtable';'h';'a int,b int,c int 2'
jd'insert';'h';'a';2 3 4;'b';6 7 8
jd'insert';'h';'a';4 5;'b';6 7
({."1 d)=. {:"1 d=. jd'read from h'
assert a-:2 3 4 4 5
assert b-:6 7 8 6 7

NB. y m d int cols derived from ymd date
jd'droptable i'
jd'createtable i y int, m int, d int, ymd date'
jd'insert i ymd';19900325 19230514
assert (25 14;3 5;1990 1923;19900325 19230514)-:{:"1 jd'read from i'

