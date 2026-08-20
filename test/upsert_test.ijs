bld=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f a int';i.5
jd'createcol f b int';i.5
jd'createcol f c int';i.5
jd'createcol f d byte';'abcde'
jd'createcol f e byte 2';5 2$'aabbccddee'
jd'reads from f'
)

NB. int key
bld''
[newdata=: 'a';2 5 1 6;'b';1000 1001 1002 1003;'c';2000 2001 2002 2003;'d';'x';'e';'y'
jd'upsert f';'a';newdata
[d=. jd'reads from f' NB. updated 2 rows and inserted 2 rows
assert 7=>{:jd'reads count a from f'
assert 0 1002 1000 3 4 1001 1003= >{:{.jd'read b from f'

NB. same as previous but with byte key col
bld''
[newdata=: 'a';2 5 1 6;'b';1000 1001 1002 1003;'c';2000 2001 2002 2003;'d';'crbt';'e';'y'
jd'upsert f';'d';newdata
[d=. jd'reads from f' NB. updated 2 rows and inserted 2 rows
assert 7=>{:jd'reads count a from f'
assert 0 1002 1000 3 4 1001 1003= >{:{.jd'read b from f'

NB. same as previous but with byteN key col
bld''
[newdata=: 'a';2 5 1 6;'b';1000 1001 1002 1003;'c';2000 2001 2002 2003;'d';'x';'e';4 2$'ccxxbbqq'
jd'upsert f';'e';newdata
[d=. jd'reads from f' NB. updated 2 rows and inserted 2 rows
assert 7=>{:jd'reads count a from f'
assert 0 1002 1000 3 4 1001 1003= >{:{.jd'read b from f'

bld''
[newdata=: 'a';2 1;'b';1000 1002;'c';2000 2002;'d';'x';'e';2 2$'ccbb'
jd'upsert f';'a';newdata NB. update 2 rows
[newdata=: 'a';5 6;'b';1001 1003;'c';2001 2003;'d';'x';'e';2 2$'xxqq'
jd'upsert f';'a';newdata NB. insert 2 rows
jd'reads from f'
assert d-:jd'reads from f'


NB. multiple keys
bld''
newdata=: 'a';2 5 1 6;'b';2 1001 1 1003;'c';2000 2001 2002 2003;'d';'w';'e';'q'
[d=. jd'upsert f';'a b';newdata
assert 7=>{:jd'reads count a from f'
assert 0 1 2 3 4 1001 1003= >{:{.jd'read b from f'

NB. multiple keys int,byte
bld''
[a=. jd'upsert f';'a d';newdata
assert a-:d

NB. multiple keys byte,byteN
bld''
[a=. jd'upsert f';'a d';newdata
assert a-:d
