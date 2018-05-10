NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

'new'jdadmin'test'
jd'createtable f'
jd'createcol f a int';2 3 4

cfile=: '~temp/jd/test/custom.ijs'

custom=: 0 : 0 rplc 'RPAREN';')'
jdderived_b=: 3 : 0
c=. jdgl NAME__PARENT;'a'
dat__c+100
RPAREN

jdderived_c=: 3 : 0
c=. jdgl NAME__PARENT;'a'
dat__c+1000
RPAREN
)

custom fwrite cfile
jdadmin'test'[jdadmin 0 NB. kludge to get custom.ijs loaded


jd'createdcol f b int b' 
jd'createdcol f c int c'

'bc'-:,;1{{:jd'info derived'

bc=: jdgl_jd_ 'f b'
cc=: jdgl_jd_ 'f c'


NB. check derived marked dirty
chkd=: 3 : 0
assert _1=nc<'dat__bc'
assert _1=nc<'dat__cc'
)

NB. check derived values
chkv=: 3 : 0
'a b c'=. 3{.{:"1 jd'read from f'
assert b=100+a
assert c=1000+a
)

''jdae'insert f';'a';23 24 25;'b';1 2 3;'c';3 4 5

jd'insert f';'a';23 24 25
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

jd'update f';'b=102';'a';666
chkd''
chkv''

jd'update f';'b';'a';777;'b';103
chkd''
chkv''

jd'createcol f d int';i.Tlen__cc
jd'upsert f';'a';'a';666 999;'d';777 888
chkd''
chkv''

jd'delete f';'a=666'
chkd''
chkv''

jd'sort /desc f a' 
chkd''
chkv''

'' fwrite cfile
jdadmin'test'[jdadmin 0 NB. kludge to get custom.ijs loaded
'not defined'jdae'read from f'

t=. 0 : 0
jdderived_b=: 3 : 0
c=. jdgl NAME__PARENT;'a'
}.dat__c+100 NB. bad Tlen
)

t fwrite cfile
jdadmin'test'[jdadmin 0 NB. kludge to get custom.ijs loaded
'count'jdae'read from f'

t=. 0 : 0
jdderived_b=: 3 : 0
c=. jdgl NAME__PARENT;'a'
i.Tlen,2
)

t fwrite cfile
jdadmin'test'[jdadmin 0 NB. kludge to get custom.ijs loaded
'shape'jdae'read from f'

t=. 0 : 0
jdderived_b=: 3 : 0
c=. jdgl NAME__PARENT;'a'
1.5+i.Tlen
)

t fwrite cfile
jdadmin'test'[jdadmin 0 NB. kludge to get custom.ijs loaded
'type'jdae'read from f'

t=. 0 : 0
jdderived_b=: 3 : 0
c=. jdgl NAME__PARENT;'a'
'a'+23
)

t fwrite cfile
jdadmin'test'[jdadmin 0 NB. kludge to get custom.ijs loaded
'domain'jdae'read from f'




NB.! need ptable tests for derived cols
