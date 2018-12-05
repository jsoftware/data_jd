NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

de=: 'db marked as damaged'
dm=: 'db damaged'

NB. verify no logsenteces failed
chk=: 3 : 0
a=. jdlogijfshow_jd_ y
b=. {:"1 a 
'logsentences failed'assert 0=+/;(<'failed:')-:each 7{.each (0=;L.each b)#b
>a
)

bld=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f a int _';i.3
p=: jdpath_jd_''
plog=: p,'log.txt'
)

bld''

FEER_jd_=: 'logijf test'
0 logijf_jd_ 'fubar'
assert 1=#jdlogijfshow_jd_''
a=. chk 0
assert 'fubar'-:;{:{.a
assert 'logijf test'-:;{:(({."1 a)i.<'FEER'){a
assert ''-:;;{:{:a
assert +./'logijf' E. fread plog


0 logijf_jd_ 'fubar';'asdf'
a=. chk 1
assert 'asdf'-:;;{:{:a

0 logijf_jd_ 'fubar';'asdf';123
a=. chk 2
assert (<'asdf';123)-:{:{:a

assert 'assertion failure'-:logijfdamage_jd_ etx 'fubar'
assert de-:(#de){.}.13!:12''

NB. logtxt
LOGOPS_jd_=: 1
jdadminx'test'
jd'createtable f'
jd'createcol f a int'
assert 2=+/LF=fread plog

'fubar'logtxt_jd_ 'adsf';i.3 4
jd'insert f a';i.20000
assert 7=+/LF=fread plog
LOGOPS_jd_=: 0

bld''
c=. jdgl_jd_'f a'
abc=: dat__c NB. bump refcount
NB. 'failed'jdae'reads from f'
erase'abc' NB. kill the refs time bomb
NB. assert +./'refs' E. fread plog
jd'reads from f' NB. logtxt but not damaged

bld''
'assertion failure'-:jddamage_jd_ etx'really messed up'
ferase p,'jddamage'
assert +./'really messed up' E. fread plog
