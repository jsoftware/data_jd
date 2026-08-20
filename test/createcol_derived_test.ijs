NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

der=: EDERIVED_jd_

custom=: 0 : 0 rplc'RPAREN';')'
derived_va=: 3 : 0
1000+jd_get'f a'
RPAREN

derived_vb4=: 3 : 0
3{."1 jd_get'f b4'
RPAREN

derived_vedt=: 3 : 0 NB. just the year
efs 10{."1 sfe jd_get'f edt'
RPAREN

)

jdadminnew'test'

custom fappend jdpath_jd_'custom.ijs'
jdloadcustom_jd_'' NB. load changes
jd'createtable f'
jd'createcol f a int';2 3 4
jd'createcol f b4 byte 4';3 4$'abcdabcdabcd'
jd'createcol f edt edatetime';'2014-01-02T03:04:05','2015-02-03T03:04:05',:'2016-03-04T03:04:05'

jd'createcol /derived f b  int    va' 
jd'createcol /derived f b3 byte 3 vb4'
jd'createcol /derived f y  edate  vedt'
jd'reads from f'

NB. verify that info schema and derived to not derive derived cols
jd'close'
getdb_jd_''
t=. jdgl_jd_'f'
c=. getlocx__t'b3'
jd'info schema'
jd'info derived'
assert _1=nc<'dat__c'

CSVFOLDER=: '~temp/jd/csv'
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert (jd'reads from f')-:jd'reads from g'

'b b3y '-:,;1{ {:jd'info derived'

bc=:  jdgl_jd_ 'f b'
b3c=: jdgl_jd_ 'f b3'
yc=:  jdgl_jd_ 'f y'

chkd=: 3 : 0 NB. check derived marked dirty
assert _1=nc 'dat_bc';'dat_b3c';'dat_yc'
)

chkv=: 3 : 0 NB. check derived values
'a b4 edt b b3 y'=. 6{.{:"1 jd'read /e from f'
assert b=1000+a
assert b3=3{."1 b4
assert y= efs_jd_ 10{."1 sfe_jd_ edt
)

jd'insert f';'a';23;'b4';'zxcv';'edt';'2017-03-04T03:04:05'
chkd''
chkv''

der jdae'insert f';'a';23;'b4';'zxcv';'edt';'2017-03-04T03:04:05';'b';123
der jdae'intx f b int2'
der jdae'byten f b3 2'
der jdae'set f b';i.3
der jdae'update f';'a=3';'b';200

jd'update f';3;'a';9
chkd''
chkv''

jd'update f';'a=9';'a';11
chkd''
chkv''

jd'update f';'b=1002';'a';666
chkd''
chkv''

jd'update f';'b';'a';777;'b';1003
chkd''
chkv''

jd'createcol f d int'
jd'upsert f';'a';'a';666 999;'d';777 888;'b4';(2 4$'asdf');'edt';2#efs_jd_ '2014-01-02T03:04:05'
chkd''
chkv''

jd'delete f';'a=666'
chkd''
chkv''

jd'sort f a desc' 
chkd''
chkv''


NB. check how derive verb errors are handled
d=. dbl_jd_
derived_va__d
derived_va__d=: 3 : '}.1000+jd_get''f a'''
c=. jdgl_jd_'f b'
setderiveddirty__c''
'count'jdae'read from f'

derived_va__d=: 3 : 'i.(#jd_get''f a''),2'
setderiveddirty__c''
'shape'jdae'read from f'

derived_va__d=: 3 : '1.5+jd_get''f a'''
setderiveddirty__c''
'bad int'jdae'read from f'

derived_va__d=: 3 : 'i.a.'
setderiveddirty__c''
'domain error'jdae'read from f'

erase'derived_va__d'
setderiveddirty__c''
'value error'jdae'read from f'

jd'dropcol f b' NB. drop is allowed- even if derive verb is bad
jd'reads from f'

NB. other tests and then ref
jdadminnew'test'
jd'createtable f'
jd'createcol f a int'
jd'createptable f a'
'ptable'jdae'createcol /derived f b int dverb'
'found' jdae'createcol /derived w b int dverb'

NB. assert tab ref is dirty
ardirty=: 3 : 0
c=. jdgl_jd_'f jdref_d_g_',y
assert 1=dirty__c
)

NB. ref derived col to normal col
jdadminnew'test'

custom=: 0 : 0 rplc'RPAREN';')'
derived_dverb=: 3 : 0
3|jd_get'f a'
RPAREN

derived_g_d=: 3 : 0
3|jd_get'g a'
RPAREN
)
custom fappend jdpath_jd_'custom.ijs'
jdloadcustom_jd_''
jd'createtable f'
jd'createcol f a int'
jd'createcol /derived f d int dverb'
jd'insert f';'a';i.6
jd'reads from f'
assert 0 1 2 0 1 2=>{:{:jd'read d from f'

jd'createtable g'
jd'createcol g b int'
jd'createcol g c int'
jd'insert g';'b';0 1 2;'c';666 777 888
jd'reads from g'

jd'ref f d g b'
ardirty'b'
jd'reads from f,f.g'
assert 666 777 888 666 777 888=>{:{:jd'read g.c from f,f.g'

jd'insert f';'a';999
ardirty'b'

assert 666 777 888 666 777 888 666='g.c'jdfrom_jd_ jd'read from f,f.g'

NB. ref derived col to derived col
jd'dropcol f jdref_d_g_b'
jd'droptable g'

jd'createtable g'
jd'createcol g a int'
jd'createcol /derived g d int g_d'
jd'insert g';'a';|.100+i.3
jd'reads from f'
jd'reads from g'
assert 0 2 1='d'jdfrom_jd_ jd'read from g'

jd'ref f d g d'
ardirty'd'
jd'reads from f,f.g'
assert 0 1 2 0 1 2 0='g.d'jdfrom_jd_ jd'read from f,f.g'

jd'update g';'d=0';'a';22
ardirty'd'
jd'reads from f,f.g'
assert 0 1 2 0 1 2 0='g.d'jdfrom_jd_ jd'read from f,f.g'
   
jd'insert f';'a';123
ardirty'd'
jd'reads from f,f.g'

assert 0 1 2 0 1 2 0 0='g.d'jdfrom_jd_ jd'read from f,f.g'
