NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

bld=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f a int _';i.3
jd'createcol f b int _';i.3
i.0 0
)

damage=: 3 : 0
c=: jdgl_jd_'f a'
dat__c=: ;i.<:Tlen__c
i.0 0
)

NB. verify no logsenteces failed
chkijf=: 3 : 0
a=. jdlogijfshow_jd_ y
b=. {:"1 a 
'logsentences failed'assert 0=+/;(<'failed:')-:each 7{.each (0=;L.each b)#b
'db damaged'jdae'reads from f'
i.0 0
)

0 : 0 NB. validate not done so checks are invalid


vfb=: 'validate failed before'
vfa=: 'validate failed after'

NB. validate insert
bld''
damage 1
vfb jdae'insert f';'a';23;'b';24
chkijf 0

bld''
FORCEVALIDATEAFTER_jd_=: 1
vfa jdae'insert f';'a';23;'b';24
chkijf 0

NB. validate update
bld''
damage 1
vfb jdae'update f';'a=2';'a';2;'b';25
chkijf 0

bld''
FORCEVALIDATEAFTER_jd_=: 1
vfa jdae'update f';'a=2';'a';2;'b';25
chkijf 0

NB. validate update
bld''
damage 1
vfb jdae'update f';'a=2';'b';25
chkijf 0

bld''
FORCEVALIDATEAFTER_jd_=: 1
vfa jdae'update f';'a=2';'b';25
chkijf 0

NB. validate delete
bld''
damage 1
vfb jdae'delete f';'a=2'
chkijf 0

bld''
FORCEVALIDATEAFTER_jd_=: 1
vfa jdae'delete f';'a=2'
chkijf 0

)

vf=:  'validate failed'
vft=: 'validate table failed'

bld=: 3 : 0
jdadminx'test'
jd'gen ref2 f 3 2 g 2'
jd'createcol f v varbyte'
jd'createtable h'
jd'createcol h href int _';i.3
jd'ref f aref h href'
d=: getdb_jd_''
t=: getloc__d'f'
c=: getloc__t'aref'
)

bld''
jd'validate'

assert 3=Tlen__t
setTlen__t 2 NB. damage the table
vf jdae'validate'

bld''
dat__c=: dat__c,1
vf jdae'validate'

NB. bld''
NB. dat__c=: 'abc' NB. bad type
NB. vf jdae'validate'

NB. bld''
NB. g=. jdgl_jd_'g bref'
NB. dat__g=: 'ab' NB. bad type
NB. vf jdae'validate'

bld''
'abc'fappend PATH__c,'dat' NB. bad fsize
vf jdae'validate'

bld''
e=: getloc__t'jdref_aref_h_href'
assert 1=dirty__e NB. ref starts dirty
jd'reads from f,f.h'
assert 0=dirty__e NB. made clean
assert dat__c-:0 1 0
jd'insert h href';23
assert 1=dirty__e
jd'validate' NB. with dirty 1
jd'reads from f,f.h' NB. setdat
jd'validate' NB. with dirty 0


bld''
jd'validate'
jd'ref f aref g bref'
jd'validate'
jd'reads from f,f.g'
jd'validate'

