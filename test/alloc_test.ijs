NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. tests for mapped file allocations

NB. mapping msize/fisze set so that it is PAD_jmf_ less than a page boundary
NB. this allows overfetch without a crash and larger overfetch with better peformance

getms=: 3 : 0
'dat'getms y
:
a=. jdgl_jd_ y
getmsize_jmf_ x,Cloc__a
)

'new'jdadmin'test'
jd'createtable f'
jd'createcol f a int'
jd'createcol f b byte'
jd'createcol f v varbyte'
jd'insert f';'a';23;'b';'x';'v';<'asdf';'1341234124134';'abc'


chksize_jd_''

'new'jdadmin'test'
jd'gen test f 1'
chksize_jd_''

'new'jdadmin'test'
jd'gen test f 3000'
chksize_jd_''

'new'jdadmin'test'
jd'gen test f 10000'
chksize_jd_''

jdcsvfolder_jd_''
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert (jd'read from f')-:jd'read from g'
chksize_jd_''

'new'jdadmin'test'
jd'gen test f 2000'

NB. running under jdtests the table allocations are small
NB. we want larger allocations for the next test
t=. jdgl_jd_'f'
ROWSMIN__t=: 2000
ROWSMULT__t=: 4
jd'insert f';,jd'read from f'
d=. jd'dropfilesize'
old=. ,'old'jdfroms_jd_ d
new=. ,'new'jdfroms_jd_ d
assert new<old
d=. jd'read from f'
d=. jd'dropfilesize'
old=. ,'old'jdfroms_jd_ d
new=. ,'new'jdfroms_jd_ d
assert new=old






jdadminx'test'

jd'createtable /a 4 1 1 f a int,b int'[jd'droptable f'
assert 3432=getms'f a'
assert 3432=getms'f b'
chksize_jd_''

jd'createtable /a 1 1 1 f'[jd'droptable f'
assert 'domain error'-:jd etx 'createtable f /a 1'[jd'droptable f'
assert 'domain error'-:jd etx 'createtable f /a 1 a int'[jd'droptable f'
assert 'domain error'-:jd etx 'createtable f /a 1 2 -3 a int'[jd'droptable f'

jd'createtable f'[jd'droptable f'
t=. jdgl_jd_'f'
assert ROWSMIN_jdtable_=ROWSMIN__t
assert ROWSMULT_jdtable_=ROWSMULT__t
assert ROWSXTRA_jdtable_=ROWSXTRA__t

jd'createtable /a 100 1.5 50 f'[jd'droptable f'
t=. jdgl_jd_'f'
assert 100=ROWSMIN__t
assert 1.5=ROWSMULT__t
assert 50=ROWSXTRA__t
jd'createcol f a int'
assert 3432=getms'f a'
chksize_jd_''
jd'insert f a';i.10000
assert 122216=getms'f a'
chksize_jd_''
jd'insert f a';i.10000
assert 241000=getms'f a'
chksize_jd_''
