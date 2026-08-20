
0 : 0
probably more tests to verify correct behavior than a tutorial
some join examples from wikipedia - sql join
)

bld=: 3 : 0
jdadminx'wj'
jd'createtable a id int,name byte'
jd'insert a';'id';1 2 3 4 1 2 3;'name';'abcdefg'
jd'createtable b id int,name byte'
jd'insert b';'id';2 1 3 1 2;'name';'qwert'
)

bld''

jd'reads from a'
jd'reads from b'

jd'ref a id b id'
[t1=. jd'reads from a,a.b' NB. left 1 - only first of matching rows
assert 'wqe wqe'-:,'b.name'jdfroms_jd_ t1

assert 'ww'-:,'b.name'jdfroms_jd_ t=. jd'reads from a,a.b where b.id=1'
assert 0=#>{.{:t=. jd'reads from a,a.b where b.id=23'

jd'dropcol a jdref_id_b_id'
jd'ref /left a id b id'
[t2=. jd'reads from a,a>b' NB. left outer - all matching rows
assert 'wrqte wrqte'-:,'b.name'jdfroms_jd_ t2

[t=. jd'reads from a,a>b where b.id=1'
assert 'wrwr'-:,'b.name'jdfroms_jd_ t

[t=. jd'reads from a,a>b where b.id=23'
assert 0=#>{.{:t

NB. left1 derived from left
[t2=. jd'reads from a,a.b'
assert t1-:t2 NB. left1 same as left1 derived from left
assert 'ww'-:,'b.name'jdfroms_jd_ t=. jd'reads from a,a.b where b.id=1'

assert 0=#>{.{:t=. jd'reads from a,a.b where b.id=23'

NB. inner dervied from left
[t3=. jd'reads from a,a-b'
assert 'wrqtewrqte'-:,'b.name'jdfroms_jd_ t3

bld1=: 3 : 0
jdadminx'wj'
a=. 12{."1>;:'Rafferty Jones Steinberg Robinson Smith John Rafferty'
b=. 31 33 33 34 34 36 33

jd'createtable et name byte 12,depid int'
jd'insert';'et';'name';a;'depid';b

a=. 12{."1>;:'Sales Engineering Clerical Marketing'
b=. 31 33 34 35
jd'createtable dt depid int,dname byte 12'
jd'insert';'dt';'depid';b;'dname';a
)

NB. first part deals with left1 join

bld1''

jd'reads from et'
jd'reads from dt'

NB. ref /left command allows left1, left, and inner joins
jd'ref /left et depid dt depid'
jd'reads from et,et.dt' NB. left1
jd'reads from et,et-dt' NB. inner
jd'reads from et,et>dt' NB. left

jd'ref /left dt depid et depid'
jd'reads from dt,dt.et' NB. left1
jd'reads from dt,dt-et' NB. innner
jd'reads from dt,dt>et' NB. left

NB. multiple ref columns
bld2=: 3 : 0
jdadminx'wj'
ext=. 'name  byte 12,state int,city  int'
a=. 12{."1>;:'Rafferty Jones Steinberg Robinson Smith John'
b=. 1 1 2 2 3 0
c=. 1 2 1 2 4 0
jd'createtable';'ext';ext
jd'insert';'ext';'name';a;'state';b;'city';c
dxt=. 'dname byte 12,state int,city  int'
a=. 12{."1>;:'Sales Engineering Clerical Marketing'
b=. 2 2 3 1 
c=. 1 2 4 1
jd'createtable';'dxt';dxt
jd'insert';'dxt';'dname';a;'state';b;'city';c
)

bld2''
jd'reads from ext'
jd'reads from dxt'
jd'ref ext state city dxt state city'
[t1=. jd'reads from ext,ext.dxt' NB. left1
 assert'MarketingSalesEngineeringClerical'-:' '-.~,'dxt.dname'jdfroms_jd_ t1

NB. verify left is correct
jd'dropcol ext jdref_state_city_dxt_state_city'
jd'ref /left ext state city dxt state city'
[t2=. jd'reads from ext,ext>dxt'
assert t1-:t2 NB. no dups so > is same as left1
assert 6=#'ext.name'jdfroms_jd_ t1

[t2=. jd'reads from ext,ext.dxt' NB. left1 derived from left
assert t1-:t2

NB. verify inner derived from left is correct
[t=. jd'reads from ext,ext-dxt'
assert 4=#'ext.name'jdfroms_jd_ t

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
'Ambiguous'jdae'reads from T,T.U' NB. don't know which ref to use
jd'info ref'
jd'reads from T,T.jdref_id_U_id'
jd'reads from T,T.jdref_aid_U_id'

NB. join tables with a two column ref
jdadminx'test'
ct1=: 'createtable t1 one int , two int'
ct2=: 'createtable t2 one int , two int'
jd ct1,' , three int'
jd'insert t1';'one';23 24 25;'two';102 101 100;'three';6 7 8
jd ct2,' , extra byte 4'
jd'insert t2';'one';25 24 23;'two';100 101 102;'extra';3 4$'aaaabbbbcccc'
jd'ref t1 one two t2 one two'
jd'reads from t1'
jd'reads from t2'
jd'reads from t1,t1.t2'
jd'info schema'
jd'info schema t2'


jdadminx'wj'
jd'createtable a an byte 4'
jd'insert a an';5 4$'abcdefjhkkkkijklnnnn'
jd'createtable b bn byte 4'
jd'insert b bn';1|.5 4$'abcdefjhkkkkijklnnnn'
jd'reads from a'
jd'reads from b'
jd'ref a an b bn'
[t=. jd'reads a.jdindex,b.jdindex,a.an,b.bn from a,a.b'
assert ('a.an'jdfroms_jd_ t)-:'b.bn'jdfroms_jd_ t
jd'dropcol a jdref_an_b_bn'
jd'ref /left a an b bn'
[t=. jd'reads a.jdindex,b.jdindex,a.an,b.bn from a,a.b'
assert ('a.an'jdfroms_jd_ t)-:'b.bn'jdfroms_jd_ t

NB. readers should experiment further with 
NB.  A join B, B join C
NB.  A join B, A join C
