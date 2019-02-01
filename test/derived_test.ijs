NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

jdadminnew'test'
jd'createtable f'
jd'createcol f a int';2 3 4
jd'createcol f b4 byte 4';3 4$'abcdabcdabcd'
jd'createcol f edt edatetime';'2014-01-02T03:04:05','2015-02-03T03:04:05',:'2016-03-04T03:04:05'

jd'createdcol f b int' 
jd'createdcol f c int'
jd'createdcol f b4x byte 3'
jd'createdcol f ex edate'

jd'reads from f' NB. default derived is fill

bfile=:   '~temp/jd/test/f/b/derive.ijs'
cfile=:   '~temp/jd/test/f/c/derive.ijs'
b4xfile=: '~temp/jd/test/f/b4x/derive.ijs'
exfile=:  '~temp/jd/test/f/ex/derive.ijs'

bfile fwrite~ 0 : 0 ,')'
derive=: 3 : 0
dat__c+1000[c=. jdgl NAME__PARENT;'a'
)

cfile fwrite~ 0 : 0 ,')'
derive=: 3 : 0
dat__c+2000[c=. jdgl NAME__PARENT;'a'
)

b4xfile fwrite~ 0 : 0 ,')'
derive=: 3 : 0
3{."1 dat__c[c=. jdgl NAME__PARENT;'b4'
)

exfile fwrite~ 0 : 0 ,')'
derive=: 3 : 0 NB. just the year
efs 4{."1 sfe dat__c[c=. jdgl NAME__PARENT;'edt'
)

jd'close' NB. close so open will load new defns

jd'reads from f'

'b  c  b4xex '-:,;1{{:jd'info derived'

bc=:   jdgl_jd_ 'f b'
cc=:   jdgl_jd_ 'f c'
b4xc=: jdgl_jd_ 'f b4x'
exc=:  jdgl_jd_ 'f ex'

chkd=: 3 : 0 NB. check derived marked dirty
assert _1=nc 'dat_bc';'dat_cc';'dat_b4xc';'dat_exc'
)

chkv=: 3 : 0 NB. check derived values
'a b4 edt b c b4x ex'=. 7{.{:"1 jd'read /e from f'
assert b=1000+a
assert c=2000+a
assert b4x=3{."1 b4
assert ex= efs_jd_ 4{."1 sfe_jd_ edt
)

''jdae'insert f';'a';23 24 25;'b';1 2 3;'c';3 4 5

jd'insert f';'a';23;'b4';'abcd';'edt';'2014-01-02T03:04:05'
chkd''
chkv''

''jdae'update f';3    ;'a';100;'b';200;'c';300
''jdae'update f';'a=3';'a';100;'b';200;'c';300
''jdae'update f';'a'  ;'a';23 ;'b';200;'c';300
''jdae'update f';'b'  ;'a';100;'b';102;'c';300

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

jd'createcol f d int';i.Tlen__cc
jd'upsert f';'a';'a';666 999;'d';777 888;'b4';(2 4$'asdf');'edt';2#efs_jd_ '2014-01-02T03:04:05'
chkd''
chkv''

jd'delete f';'a=666'
chkd''
chkv''

jd'sort f a desc' 
chkd''
chkv''

'derive=: 3 : ''i.Tlen-1'''fwrite bfile
jd'close'

'count'jdae'read from f'

'derive=: 3 : ''i.Tlen,2'''fwrite bfile
jd'close'

'shape'jdae'read from f'

'derive=: 3 : ''1.5+i.Tlen'''fwrite bfile
jd'close'

'type'jdae'read from f'

'derive=: 3 : ''i.a.'''fwrite bfile
jd'close'

'domain error'jdae'read from f'

jdadminnew'test'
jd'createtable f'
jd'createcol f a int'
jd'createptable f a'
'ptable'jdae'createdcol f b int'
'found'jdae'createdcol w b int'
