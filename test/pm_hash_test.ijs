NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. tests for where hash performance

foo=: 3 : 0
jdadminx'test'
d=. i.y
jd'createtable f'
jd'createcol f a int'
jd'createcol f b int'
jd'createcol f c int'
jd'insert f';'a';d;'b';d;'c';d
jd'createhash f b'
jd'createunique f c'
)

foo 20e6

footm=: 3 : 0
t=. 1.5 NB. factor between = and hash - normally higher but 1.5 avoids false asserts
a=. timex 'jd''reads a from f where a=100''' NB. J =
b=. timex 'jd''reads a from f where b=100'''   NB. hash
c=. timex 'jd''reads a from f where c=100'''   NB. unique
bcl=. jdgl_jd_'f b'
assert 'lookup'=6{.5!:5 <'qequal__bcl' NB. verify hashed col has lookup
ccl=. jdgl_jd_'f b'
assert 'lookup'=6{.5!:5 <'qequal__ccl' NB. verify hashed col has lookup
assert a>t*b NB. hash should be much faster
assert a>t*c NB. unique should be much faster
aa=. timex 'jd''reads a from f where a in (100,1000)''' NB. J =
bb=. timex 'jd''reads a from f where b in (100,1000)''' NB. hash
cc=. timex 'jd''reads a from f where c in (100,1000)''' NB. unique
assert aa>t*bb NB. hash should be much faster
assert aa>t*cc NB. unique should be much faster
(a%b,c),aa%bb,cc
)

footm''

jdadmin 0
jdadmin'test'
footm''

jd'close'
footm''