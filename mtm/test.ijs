NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. mtm test DB and jobs

NB. rows rocreate range
mtm_test_create=: 3 : 0
rows=: y
range=: <.y%100
jdadmin 0
jdadminx'ro'
jd'createtable f'
jd'createcol f a int'
jd'createcol f b int'
jd'createcol f c int'
d=. ?.rows$range
jd'insert f';'a';d;'b';d;'c';d

jd'createtable g'
jd'createcol g a int'
jd'createcol g b int'
jd'createcol g c int'
d=: ?.rows$range
jd'insert g';'a';d;'b';d;'c';d
jdadmin 0
jdadminro_jd_'ro'
)

NB. rows rocreate range
mtm_test_simple=: 3 : 0
jdadminx'mtm'
jd'createtable f'
jd'createcol f a int'
jd'createcol f b int'
d=. i.3
jd'insert f';'a';d;'b';d
jd'createtable g'
jd'createcol g a int'
jd'createcol g b int'
d=. i.3
jd'insert g';'a';d;'b';d
)

tests=: 2}.each <;._2 [ 0 : 0
0 jd'reads from f where a=0'
1 jd'reads from f where b=0'
2 jd'reads from f where c=0'
3 jd'reads from f where b=0 or b=1 or b=2 or c=0 or b=0 or c=0 or b=0 or c=0 or b=0 or c=0'
4 6!:3[10
5 6!:3[0.001
6 jd'reads from f where a=0'
7 jd'reads from g where a=0'
8 spinner 0.17
9 spinner 0.5
)

test=: 3 : ';y{tests'

NB. seconds to run test 
NB. seconds rorate test
rorate=: 4 : 0
jdadmin 0
jdadminro'ro'
t=. ;y{tests
echo t
cnt=. 0
s=: 6!:1''
while. (6!:1'')<s+x do.
 ".t
 cnt=. >:cnt
end.
cnt%x
)

spinner=: 3 : 0
s=. 6!:1''
while. y>s-~6!:1'' do. end.
)
