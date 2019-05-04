f=: 3 : 0
t=. i.2
jdadminnew'test'
jd'createtable f'
jd'createcol f b01 boolean';1 0
jd'createcol f i int';t+<.2^33
jd'createcol f i1 int1';t
jd'createcol f i2 int2';t+256
jd'createcol f i4 int4';t+65536
jd'createcol f fl float';t+0.5
jd'createcol f b byte';'ab'
jd'createcol f b2 byte 2';2 2$'zxcv'
jd'createcol f v varbyte';<'111';'6'
jd'createcol f d date';19900102 20040203
jd'createcol f dt datetime';19900102121212 20040203131313
jd'createcol f ed edate';2 4$'20122013'
jd'createcol f edt edatetime';2 4$'20122013'
jd'createcol f edtm edatetimem';2 4$'20122013'
jd'createcol f edtn edatetimen';2 4$'20122013'

jd'createtable g'
jd'createcol g aaa int';t+<.2^33
jd'createcol g bbb int';23 24
jd'createcol g ccc edate';2 4$'20202021'

jd'ref f i g aaa'
)

f''

NB. types
gettypes=: 3 : 0
t=. {."1 y
}.each}:each(t i:each'(')}.each t
)
r=: jd'read /types from f'
assert 0=#TYPES_jd_-.gettypes r

r=: jd'read /types count i,count d,count ed,first i, first d,first ed by i from f'
assert (;:'int int int int int date edate')-:gettypes r 

r=: jd'read /types max ed,min ed,first ed,last ed by i from f'
assert (;:'int edate edate edate edate')-:gettypes r 

r=: jd'read /types count ed, countunique ed, sum ed, avg ed by i from f'
assert (;:'int int int int float')-:gettypes r

assert ('2012-01-01';'2013-01-01';'2013-01-01';'2012-01-01')-:,each{:"1 jd'read first ed, last ed, max ed, min ed from f'
assert 378691200000000000 410313600000000000 410313600000000000 378691200000000000=;{:"1 jd'read /e first ed, last ed, max ed, min ed from f'

assert ('int';'edate')-:gettypes jd'read /types max g.aaa,max g.ccc from f,f.g'

NB. /table option - implies /lr /types
'invalid name'jdae'read /types /table abc/abcfrom f'
i=. dbrow_jd_ DBOPS_jd_
DBOPS_jd_=: (<'read reads createtable')(<i;1)}DBOPS_jd_
jd'read  /types /table abc from f'
DBOPS_jd_=: (<'read reads')(<i;1)}DBOPS_jd_
'createtable'jdae'read  /types /table abc from f'
DBOPS_jd_=: (<'*')(<i;1)}DBOPS_jd_

assert (i.0 0)-:jd'read  /table abc from f'
assert (i.0 0)-:jd'reads /table def from f'
a=. jd'read from f'
assert a-:jd'read from abc'
assert a-:jd'read from def'

NB. f.b01 vs f__b01
assert (i.0 0)-:jd'read  /table abc from f,f.g'
assert (i.0 0)-:jd'reads /table def from f,f.g'
a=. {:"1 jd'read from f,f.g'
assert a-:{:"1 jd'read from abc'
assert a-:{:"1 jd'read from def'

NB. /file option
p=. jdpath_jd_'jdfile/'
assert (i.0 0)-:jd'read /file foo from f'
assert (jd'read from f')-:3!:2 fread p,'foo'

assert (i.0 0)-:jd'read /file "foo boo" from f,f.g'
assert (jd'read from f,f.g')-:3!:2 fread p,'foo boo'





