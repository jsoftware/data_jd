NB. Copyright 2018, Jsoftware Inc.  All rights reserved.
NB. from join_tut with assert added
NB. join examples from wikipedia - sql join
NB. join section in admin.html

NB. tests left1 join
NB. see joinx_test for left join tests

NB.  sort col data - sort colums and rows - easier to compare
scd=: 3 : 0
h=. {.y
d=. {:y
s=. /:h
h=. s{h
d=. s{d
s=. /:rebox d
d=. (<s){each d
h,:d
) 

rebox=: 3 : 0 NB. must be slick way to do this
t=. ;"1 <"1 each y
|: ((#y),(#t)%#y)$t
)

debox=: 3 : 0 NB. must be slicker way to do this
r=. '' 
for_a. y do. r=. r,<>a end.
r
)

less=: 4 : 0
ax=. rebox {:scd x
ay=. rebox {:scd y
({.x),:debox |:ax-.ay
)

jdadminx'wj'

etc=: 0 : 0
name  byte 12
depid int
)

a=: 12{."1>;:'Rafferty Jones Steinberg Robinson Smith John Rafferty'
b=: 31 33 33 34 34 36 33

jd'createtable';'et';etc
jd'insert';'et';'name';a;'depid';b

dtc=: 0 : 0
depid int
dname byte 12
)

a=: 12{."1>;:'Sales Engineering Clerical Marketing'
b=: 31 33 34 35
jd'createtable';'dt';dtc
jd'insert';'dt';'depid';b;'dname';a

jd'ref et depid dt depid'

[et=: jd'reads from et'
[dt=: jd'reads from dt'

NB. scd sorts reads result by column and data - easier compares

[etleft1=: scd jd'reads from et,et.dt' NB. left1

jd'ref dt depid et depid'

[dtleft1=: scd jd'reads from dt,dt.et' NB. left1

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'et' NB. delete and reinsert rows
jdshuffle_jd_^:3 'dt' NB. delete and reinsert rows
assert etleft1-: scd jd'reads from et,et.dt'

NB. multiple reference columns
ext=: 0 : 0
name  byte 12
state int
city  int
)

a=: 12{."1>;:'Rafferty Jones Steinberg Robinson Smith John'
b=: 1 1 2 2 3 0
c=: 1 2 1 2 4 0
jd'createtable';'ext';ext
jd'insert';'ext';'name';a;'state';b;'city';c

dxt=: 0 : 0
dname byte 12
state int
city  int
)

a=: 12{."1>;:'Sales Engineering Clerical Marketing'
b=: 2 2 3 1 
c=: 1 2 4 1
jd'createtable';'dxt';dxt
jd'insert';'dxt';'dname';a;'state';b;'city';c

jd'ref ext state city dxt state city'

[a=. scd jd'reads from ext'
[b=. scd jd'reads from dxt'
[g=. scd jd'reads from ext,ext.dxt' NB. left1

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'ext'
jdshuffle_jd_^:# 'dxt'
assert a-: scd jd'reads from ext'
assert b-: scd jd'reads from dxt'
assert g-: scd jd'reads from ext,ext.dxt' NB. left1

NB. multiple references between tables
jd'dropdb'
jd'createdb'
jd'createtable';'T';'id int',LF,'aid int'
jd'insert';'T';'id';(i.3);'aid';|.i.3
jd'createtable';'U';'id int',LF,'nme int'
jd'insert';'U';'id';(|.i.3);'nme';10+i.3
jd'ref T id U id'
jd'ref T aid U id'
jd'reads from T'
jd'reads from U'
jd'info ref'
NB. reference name is used to select which join to use
NB. [a=. jd'reads T.id,jdref_aid_U_id.nme from T,T.jdref_aid_U_id'
NB. assert 10 11 12-:,>{:{:a
NB. [b=. jd'reads T.id,jdref_id_U_id.nme from T,T.jdref_id_U_id'
NB. assert 12 11 10-:,>{:{:b

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'T'
jdshuffle_jd_^:3 'U'
NB. assert (scd a)-:scd jd'reads T.id,jdref_aid_U_id.nme from T,T.jdref_aid_U_id'
NB. assert (scd b)-:scd jd'reads T.id,jdref_id_U_id.nme from T,T.jdref_id_U_id'

NB. join tables with a two column ref
jdadminx'test'
ct1=: 'createtable t1 one int , two int'
ct2=: 'createtable t2 one int , two int'
jd ct1,' , three int'
jd'insert t1';'one';23 24 25;'two';102 101 100;'three';6 7 8
jd ct2,' , extra byte 4'
jd'insert t2';'one';25 24 23;'two';100 101 102;'extra';3 4$'aaaabbbbcccc'
jd'ref t1 one two t2 one two'
[a=. scd jd'reads from t1'
[b=. scd jd'reads from t2'
[c=. scd jd'reads from t1,t1.t2'
jd'info schema'
jd'info schema t2'

NB. validate same results after table shuffles
jdshuffle_jd_^:3 't1'
jdshuffle_jd_^:3 't2'
assert a-: scd jd'reads from t1'
assert b-: scd jd'reads from t2'
assert c-: scd jd'reads from t1,t1.t2'
jd'close'

NB. tutorial should be extended to cover
NB.  A join B, B join C
NB.  A join B, A join C


NB. join with empty tables

jdadminx'test'
aa=.2 1;2 1;2 4;2 1;2 1;2 1;2 6;2 1;2 1;2 1;2 4;2 1;2 1;2 1;2 0;2 1

jd'gen test two 2'
jd'gen test zero 0'

NB. empty table as target
NB. ref empty table as target fails - reference had kludge to fix this
jd'ref two int zero int'


r=. jd'reads from two,two.zero'
assert aa=$each {:scd r

NB. empty table as root
jd'dropcol two jdref_int_zero_int'
jd'ref zero int two int'

r=. jd'reads from zero,zero.two'
assert 0=;#each {:scd r

NB. tests after bugs were found in /left joins
NB. bugs were that where clauses did not work with /left joins

jdadminx'test'

bld=: 3 : 0
jd'createtable f j byte,b byte'
jd'insert f';'j';'zyxxy';'b';'abcde'
jd'createtable g k byte,c byte'
jd'insert g';'k';'yxy';'c';'qwe'
)

ref=: 3 : 0
jd'ref /left f j g k'
)

setc=: 3 : 0
c=: jdgl_jd_'f jdref_j_g_k'
i.0 0
)

bld''
ref''
jd'read from f'
jd'read from g'

[a=.jd'read f.j,g.k from f,f.g'
assert 'zyxxy'-:'f.j'jdfrom_jd_ a
assert ' yxxy'-:'g.k'jdfrom_jd_ a

[a=.jd'read f.j,g.k from f,f>g'
assert 'zyyxxyy'-:'f.j'jdfrom_jd_ a
assert ' yyxxyy'-:'g.k'jdfrom_jd_ a

[a=. jd'read f.j,g.k from f,f.g where f.j="y"' 
assert 'yy'-:'f.j'jdfrom_jd_ a
assert 'yy'-:'g.k'jdfrom_jd_ a

[a=. jd'read f.j,g.k from f,f>g where f.j="y"' 
assert 'yyyy'-:'f.j'jdfrom_jd_ a
assert 'yyyy'-:'g.k'jdfrom_jd_ a

[a=. jd'read f.j,g.k from f,f>g where f.j="y" or f.j="z"' 
assert 'zyyyy'-:'f.j'jdfrom_jd_ a
assert ' yyyy'-:'g.k'jdfrom_jd_ a

NB. inner join
[a=. jd'read f.j,g.k from f,f-g where f.j="y" or f.j="z"' 
assert 'yyyy'-:'f.j'jdfrom_jd_ a
assert 'yyyy'-:'g.k'jdfrom_jd_ a

NB. test /left join series of joins
jd'createtable h'
jd'createcol h w byte';'ew'
jd'ref /left g c h w'
[a=. jd'read from f,f.g,g.h'
assert 'zyxxy'-:'f.j'jdfrom_jd_ a
assert ' yxxy'-:'g.k'jdfrom_jd_ a
assert '  ww '-:'h.w'jdfrom_jd_ a

[a=. jd'read from f,f>g,g>h'
assert 'zyyxxyy'-:'f.j'jdfrom_jd_ a
assert ' yyxxyy'-:'g.k'jdfrom_jd_ a
assert '  eww e'-:'h.w'jdfrom_jd_ a

[a=. jd'read from f,f-g,g-h'
assert 'yxxy'-:'f.j'jdfrom_jd_ a
assert 'yxxy'-:'g.k'jdfrom_jd_ a
assert 'ewwe'-:'h.w'jdfrom_jd_ a
