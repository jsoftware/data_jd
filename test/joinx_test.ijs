NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. from join_tut with assert added
NB. join examples from wikipedia - sql join
NB. join section in admin.html

NB. left (derived left1 inner_ join

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

jd'ref /left et depid dt depid'

[et=: jd'reads from et'
[dt=: jd'reads from dt'

NB. scd sorts reads result by column and data - easier compares

[etinner=: scd jd'reads from et,et-dt' NB. innner
[etleft=:  scd jd'reads from et,et>dt' NB. left
[etleft1=: scd jd'reads from et,et.dt' NB. left1

jd'ref /left dt depid et depid'

[dtinner=: scd jd'reads from dt,dt-et' NB. inner
[dtleft=:  scd jd'reads from dt,dt>et' NB. left
[dtleft1=: scd jd'reads from dt,dt.et' NB. left1

assert etinner -: dtinner

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'et' NB. delete and reinsert rows
jdshuffle_jd_^:3 'dt' NB. delete and reinsert rows
assert etinner-: scd jd'reads from et,et-dt'
assert etleft-:  scd jd'reads from et,et>dt'
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

jd'ref /left ext state city dxt state city'

[a=. scd jd'reads from ext'
[b=. scd jd'reads from dxt'
[d=. scd jd'reads from ext,ext-dxt' NB. inner
[e=. scd jd'reads from ext,ext>dxt' NB. left
[g=. scd jd'reads from ext,ext.dxt' NB. left1

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'ext'
jdshuffle_jd_^:# 'dxt'
assert a-: scd jd'reads from ext'
assert b-: scd jd'reads from dxt'
assert d-: scd jd'reads from ext,ext-dxt' NB. inner
assert e-: scd jd'reads from ext,ext>dxt' NB. left
assert g-: scd jd'reads from ext,ext.dxt' NB. left1

NB. multiple references between tables
jd'dropdb'
jd'createdb'
jd'createtable';'T';'id int',LF,'aid int'
jd'insert';'T';'id';(i.3);'aid';|.i.3
jd'createtable';'U';'id int',LF,'nme int'
jd'insert';'U';'id';(|.i.3);'nme';10+i.3
jd'ref /left T id U id'
jd'ref /left T aid U id'
jd'reads from T'
jd'reads from U'
jd'info ref'
NB. reference name is used to select which join to use
[a=. jd'reads T.id,jdref_aid_U_id.nme from T,T.jdref_aid_U_id'
assert 10 11 12-:,>{:{:a
[b=. jd'reads T.id,jdref_id_U_id.nme from T,T.jdref_id_U_id'
assert 12 11 10-:,>{:{:b

NB. validate same results after table shuffles
jdshuffle_jd_^:3 'T'
jdshuffle_jd_^:3 'U'
assert (scd a)-:scd jd'reads T.id,jdref_aid_U_id.nme from T,T.jdref_aid_U_id'
assert (scd b)-:scd jd'reads T.id,jdref_id_U_id.nme from T,T.jdref_id_U_id'

NB. join tables with a two column ref
jdadminx'test'
ct1=: 'createtable t1 one int , two int'
ct2=: 'createtable t2 one int , two int'
jd ct1,' , three int'
jd'insert t1';'one';23 24 25;'two';102 101 100;'three';6 7 8
jd ct2,' , extra byte 4'
jd'insert t2';'one';25 24 23;'two';100 101 102;'extra';3 4$'aaaabbbbcccc'
jd'ref /left t1 one two t2 one two'
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

NB. join with empty tables
jdadminx'test'
aa=.2 1;2 1;2 4;2 1;2 1;2 1;2 6;2 1;2 1;2 1;2 4;2 1;2 1;2 1;2 0;2 1

jd'gen test two 2'
jd'gen test zero 0'

NB. empty table as target
jd'ref /left two int zero int'

r=. jd'reads from two,two>zero'
assert aa=$each {:scd r

r=. jd'reads from two,two-zero'
assert 0=;#each {:scd r

r=. jd'reads from two,two>zero'
assert aa=$each {:scd r

r=. jd'reads from two,two.zero'
assert aa=$each {:scd r

NB. empty table as root
jd'dropcol two jdref_int_zero_int'
jd'ref /left zero int two int'

r=. jd'reads from zero,zero-two'
assert 0=;#each {:scd r

r=. jd'reads from zero,zero>two'
assert 0=;#each {:scd r

r=. jd'reads from zero,zero.two'
assert 0=;#each {:scd r


NB. from joinorder_test

tc=: 4 : 0
jd'droptable';x
jd'createtable';x;'a int'
jd'insert';x;'a';y
)

NB. y is a list of boxed integer lists.
NB. For each make a table with the list in column a, and link them in order.
NB. Table names are f,g,...
tcs =: 4 : 0
jdadminx'test'
getname =. a.{~ (a.i.'f')&+
for_i. i.#y do.
  (getname i) tc i{::y
  if. i>0 do. jd ('ref ',x,' '),;:^:_1 , (getname&.> (,~<:)i),.<'a' end.
end.
)

'' tcs 3#<2#i.5
jd'reads from f,f.g,g.h'

'/left' tcs 3#<2#i.5
jd'reads from f,f.g'
jd'reads from g,g.h'
jd'reads from f,f-g'
jd'reads from g,g-h'
jd'reads from f,f>g'
jd'reads from g,g>h'

NB. fixed - problems with ref /left1 with more than 1 join
a=. jd'reads from f,f.g,g.h'
b=. jd'reads from f,f-g,g-h'
c=. jd'reads from f,f>g,g>h'

NB. catch bug where mapped noun was changed because of missing forcecopy
assert a-:jd'reads from f,f.g,g.h'
assert b-:jd'reads from f,f-g,g-h'
assert c-:jd'reads from f,f>g,g>h'
