NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. join examples from wikepedia - sql join
NB. see join section in user.html

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

jd'reads from et,et-dt' NB. innner
jd'reads from et,et>dt' NB. left
jd'reads from et,et<dt' NB. right
jd'reads from et,et=dt' NB. outer
jd'reads from et,et.dt' NB. left1

jd'reference dt depid et depid'

jd'reads from dt,dt-et' NB. innnr
jd'reads from dt,dt>et' NB. left
jd'reads from dt,dt<et' NB. right
jd'reads from dt,dt=et' NB. outer
jd'reads from dt,dt.et' NB. left1

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

jd'reads from ext'
jd'reads from dxt'
jd'reads from ext,ext=dxt' NB. outer
jd'reads from ext,ext-dxt' NB. inner
jd'reads from ext,ext>dxt' NB. left
jd'reads from ext,ext<dxt' NB. right
jd'reads from ext,ext.dxt' NB. left1

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

NB. join tables with a two column ref
jdadminx'test'
ct1=: 'createtable t1 one int , two int'
ct2=: 'createtable t2 one int , two int'
jd ct1,' , three int'
jd'insert t1';'one';23 24 25;'two';102 101 100;'three';6 7 8
jd ct2,' , extra byte 4'
jd'insert t2';'one';25 24 23;'two';100 101 102;'extra';3 4$'aaaabbbbcccc'
jd'reference t1 one two t2 one two'
jd'reads from t1'
jd'reads from t2'
jd'reads from t1,t1.t2'
jd'info schema'
jd'info schema t2'

NB. readers should experiment further with 
NB.  A join B, B join C
NB.  A join B, A join C
