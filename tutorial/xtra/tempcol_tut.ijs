NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

0 : 0
temp col(s) can be created before a read statement is run
a temp col can be used just like any other col
in particular a temp col can be used in select/by/where

a temp col is the set by a J expression that can use data
from any other database col

one use of a temp col is to allow aggregations with a by expression

columns are refered to as table_column
foo_jd_ is allowed
". is not allowed

the J sentence is in the jdtc clause
)

jdadminx'test'
jd'gen ref2 a 10 0 b 5'
jd'reads from a,a.b'

jd'readtc new1,adata from a jdtc a_new1=:a_adata>4'

[r=. jd'readtc /lr new1,adata from a jdtc a_new1=:a_adata>4' NB. /lr for labeled rows
assert (0 0 0 0 0 1 1 1 1 1;0 1 2 3 4 5 6 7 8 9)-:{:"1 r

jd'readtc new1,adata,new2,akey from a jdtc a_new2=:3|a_akey[a_new1=:a_adata>4'

[r=. jd'readtc adata sum:sum adata,bref avg:avg b.bref by cat:new1 from a,a.b jdtc a_new1=:a_adata>4'
assert 0 10 2 1 35 2-:,,./>{: r

[r=. jd'readtc adata sum:sum adata,bref avg:avg b.bref by new2 from a,a.b jdtc a_new2=:3|a_akey'
assert 0 18 2 1 12 2 2 15 1-:<.,,./>{: r

[r=. jd'readtc sum adata by z from a jdtc a_z=:(a_akey<5){>''foo'';''bar'''
assert r-:2 2$(,'z');('adata');(2 3$'barfoo');,.10 35

[r=. jd'readtc z,* from b jdtc b_z=:4 5 6{"1 b_bb12'
assert 'defc dabcefa de'-:,;{.{:r

jd'gen test f 10'

[r=. jd'readtc sum int:sum int,cnt int:count int by yyyy from f order by yyyy jdtc f_yyyy=:<.f_datetime%10000000000'
assert ({:r)-:(<,.1994 1997 1999 2005 2007 2008),(<,.109 316 100 207 209 104),<,.1 3 1 2 2 1
