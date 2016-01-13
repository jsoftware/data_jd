NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

0 : 0
custom.ijs can define datatune - applied to all insert/update/modify data
custom.ijs can also define db ops (see custom tutorial)

insert/update/modify calls db datatune_table
x is list of names:  'jdn'          ;provided value names
y is list of values: (all col names);provided values
datatune_table returns values for all col names (in same order)
)

custom=: 0 : 0 rplc 'RPAREN';')'

datatune_fff=: 4 : 0
(x)=. y NB. local names assigned with valuse
'datatune f aaa>0'assert *./aaa>0
bbb=. >:aaa
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

0 : 'spx hr'
NB. datatune insert
jd'droptable fff'
jd'createtable';'fff';'aaa int,bbb int'
jd'insert';'fff';'aaa';23
jd'insert';'fff';'aaa';24 25
({."1 d)=. {:"1 d=. jd'read from fff'
assert aaa-:23 24 25
assert bbb-:24 25 26

0 : 'spx hr'
NB. datatune update
jd'update';'fff';'aaa=23';'aaa';66
({."1 d)=. {:"1 d=. jd'read from fff'
assert aaa-:24 25 66
assert bbb-:25 26 67

0 : 'spx hr'
NB. datatune modify
jd'modify fff';'aaa=25';'aaa';999
({."1 d)=. {:"1 d=. jd'read from fff'
assert aaa-:24 999 66
assert bbb-:25 1000 67
'aaa>0'jdae'insert';'fff';'aaa';0 NB. error thrown for bad aaa

0 : 0
debugging datatune verbs can be difficult
datatune op makes it easier and works under dbr
)
jd'datatune fff';'aaa';23 24 25
'aaa>0'jdae'datatune fff';'aaa';1 2 3 0 4

0 : 0
datatune verb can be complicated
the arg is the data provided to the op by the user
and the result is used in the op (insert/update/modify)
)

0 : 'spx hr'
jd'droptable g'
jd'createtable';'g';'v varbyte,b byte 2'
jd'insert';'g';'v';<'abc';'qewr'
({."1 d)=. {:"1 d=. jd'read from g'
assert b-:2 2$'abqe'

0 : 'spx hr'
NB. c int 2 col derived by combining a b int cols - c used as unique
jd'droptable h'
jd'createtable';'h';'a int,b int,c int 2'
jd'insert';'h';'a';2 3 4;'b';6 7 8
jd'insert';'h';'a';4 5;'b';6 7
({."1 d)=. {:"1 d=. jd'read from h'
assert a-:2 3 4 4 5
assert b-:6 7 8 6 7

0 : 'spx hr'
NB. y m d int cols derived from ymd date
jd'droptable i'
jd'createtable i y int, m int, d int, ymd date'
jd'insert i ymd';19900325 19230514
assert 1990 1923-:;{:{:jd'read y from i'
assert 3 5-:;{:{:jd'read m from i'
assert 25 14-:;{:{:jd'read d from i'
assert 19900325 19230514-:;{:{:jd'read ymd from i'
