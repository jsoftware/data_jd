NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. from join_tut with assert added
NB. join examples from wikepedia - sql join
NB. join section in admin.html

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

jd'reference et depid dt depid'

[et=: jd'reads from et'
[dt=: jd'reads from dt'

NB. scd sorts reads result by column and data - easier compares

[etinner=: scd jd'reads from et,et-dt' NB. innner
[etleft=:  scd jd'reads from et,et>dt' NB. left
[etright=: scd jd'reads from et,et<dt' NB. right
[etouter=: scd jd'reads from et,et=dt' NB. outer
[etleft1=: scd jd'reads from et,et.dt' NB. left1

jd'reference dt depid et depid'

[dtinner=: scd jd'reads from dt,dt-et' NB. innnr
[dtleft=:  scd jd'reads from dt,dt>et' NB. left
[dtright=: scd jd'reads from dt,dt<et' NB. right
[dtouter=: scd jd'reads from dt,dt=et' NB. outer
[dtleft1=: scd jd'reads from dt,dt.et' NB. left1

assert etinner -: dtinner
assert etleft  -: dtright
assert etright -: dtleft
assert etouter -: dtouter

etouter less etinner
etouter less etleft
etouter less etright

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'et' NB. delete and reinsert rows
jdshuffle_jd_^:3 'dt' NB. delete and reinsert rows
assert etinner-: scd jd'reads from et,et-dt'
assert etleft-:  scd jd'reads from et,et>dt'
assert etright-: scd jd'reads from et,et<dt'
assert etouter-: scd jd'reads from et,et=dt'
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

jd'reference ext state city dxt state city'

[a=. scd jd'reads from ext'
[b=. scd jd'reads from dxt'
[c=. scd jd'reads from ext,ext=dxt' NB. outer
[d=. scd jd'reads from ext,ext-dxt' NB. inner
[e=. scd jd'reads from ext,ext>dxt' NB. left
[f=. scd jd'reads from ext,ext<dxt' NB. right
[g=. scd jd'reads from ext,ext.dxt' NB. left1

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'ext'
jdshuffle_jd_^:# 'dxt'
assert a-: scd jd'reads from ext'
assert b-: scd jd'reads from dxt'
assert c-: scd jd'reads from ext,ext=dxt' NB. outer
assert d-: scd jd'reads from ext,ext-dxt' NB. inner
assert e-: scd jd'reads from ext,ext>dxt' NB. left
assert f-: scd jd'reads from ext,ext<dxt' NB. right
assert g-: scd jd'reads from ext,ext.dxt' NB. left1

NB. multiple references between tables
jd'dropdb'
jd'createdb'
jd'createtable';'T';'id int',LF,'aid int'
jd'insert';'T';'id';(i.3);'aid';|.i.3
jd'createtable';'U';'id int',LF,'nme int'
jd'insert';'U';'id';(|.i.3);'nme';10+i.3
jd'reference T id U id'
jd'reference T aid U id'
jd'reads from T'
jd'reads from U'
jd'info reference'
NB. reference name is used to select which join to use
[a=. jd'reads T.id,jdreference_aid_U_id.nme from T,T.jdreference_aid_U_id'
assert 10 11 12-:,>{:{:a
[b=. jd'reads T.id,jdreference_id_U_id.nme from T,T.jdreference_id_U_id'
assert 12 11 10-:,>{:{:b

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'T'
jdshuffle_jd_^:3 'U'
assert (scd a)-:scd jd'reads T.id,jdreference_aid_U_id.nme from T,T.jdreference_aid_U_id'
assert (scd b)-:scd jd'reads T.id,jdreference_id_U_id.nme from T,T.jdreference_id_U_id'

NB. join tables with a two column ref
jdadminx'test'
ct1=: 'createtable t1 one int , two int'
ct2=: 'createtable t2 one int , two int'
jd ct1,' , three int'
jd'insert t1';'one';23 24 25;'two';102 101 100;'three';6 7 8
jd ct2,' , extra byte 4'
jd'insert t2';'one';25 24 23;'two';100 101 102;'extra';3 4$'aaaabbbbcccc'
jd'reference t1 one two t2 one two'
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

NB. tutorial should be extended to cover
NB.  A join B, B join C
NB.  A join B, A join C

