NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

0 : 0
temp col(s) can be created at the start of a read statement
a temp col can be used just like any other col
in particular a temp col can be use in select/by/where

a temp col is the result of a J expression that can use data from any other database col

one use of a temp col is to allow aggregations with a by expressioin
)

jdadminx'test'
jd'gen ref2 a 10 0 b 5'
jd'reads from a,a.b'

jd'readtc :::a_new1=:a_adata>4::: new1,adata from a'

[r=. jd'readtc /lr :::a_new1=:a_adata>4::: new1,adata from a' NB. /lr for labeled rows
assert (0 0 0 0 0 1 1 1 1 1;0 1 2 3 4 5 6 7 8 9)-:{:"1 r

jd'readtc :::a_new2=:3|a_akey[a_new1=:a_adata>4::: new1,adata,new2,akey from a'

[r=. jd'readtc :::a_new1=:a_adata>4::: adata sum:sum adata,bref avg:avg b.bref by cat:new1 from a,a.b'
assert 0 10 2 1 35 2-:,,./>{: r

[r=. jd'readtc :::a_new2=:3|a_akey::: adata sum:sum adata,bref avg:avg b.bref by new2 from a,a.b'
assert 0 18 2 1 12 2 2 15 1-:<.,,./>{: r

[r=. jd'readtc :::a_z=:(a_akey<5){>''foo'';''bar''::: sum adata by z from a'
assert r-:2 2$(,'z');('adata');(2 3$'barfoo');,.10 35

[r=. jd'readtc :::b_z=:4 5 6{"1 b_bb12::: z,* from b'
assert 'defc dabcefa de'-:,;{.{:r

jd'gen test f 10'

[r=. jd'readtc :::f_yyyy=:<.f_datetime%10000000000::: sum int:sum int,cnt int:count int by yyyy from f order by yyyy'
assert ({:r)-:(<,.1994 1997 1999 2005 2007 2008),(<,.109 316 100 207 209 104),<,.1 3 1 2 2 1