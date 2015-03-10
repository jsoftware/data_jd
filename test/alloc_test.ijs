NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. tests for mapped file allocatoins

getms=: 3 : 0
'dat'getms y
:
a=. jdgl_jd_ y
getmsize_jmf_ x,Cloc__a
)

jdadminx'test'
jd'createtable f 4 1 1'[jd'droptable f'
assert 4=getms'f jdactive'


jd'createtable f 4 1 1 a int'[jd'droptable f'
assert 4=getms'f jdactive'
assert 32=getms'f a'



jd'createtable f 4 1 1 a int,b int'[jd'droptable f'
assert 4=getms'f jdactive'
assert 32=getms'f a'
assert 32=getms'f b'


jd'createtable f 4 1 1';'a int'[jd'droptable f'
assert 4=getms'f jdactive'
assert 32=getms'f a'


jd'createtable f 4 2 3';'a int';'b int'[jd'droptable f'
assert 4=getms'f jdactive'
assert 32=getms'f a'
assert 32=getms'f b'

assert 'domain error'-:jd etx 'createtable f 1 1 1'[jd'droptable f'
assert 'domain error'-:jd etx 'createtable f 1'[jd'droptable f'
assert 'domain error'-:jd etx 'createtable f 1 a int'[jd'droptable f'
assert 'domain error'-:jd etx 'createtable f 1 2 -3 a int'[jd'droptable f'

jd'createtable f'[jd'droptable f'
t=. jdgl_jd_'f'
assert ROWSMIN_jdtable_=ROWSMIN__t
assert ROWSMULT_jdtable_=ROWSMULT__t
assert ROWSXTRA_jdtable_=ROWSXTRA__t

jd'createtable f 100 1.5 50'[jd'droptable f'
t=. jdgl_jd_'f'
assert 100=getms'f jdactive'
assert 100=ROWSMIN__t
assert 1.5=ROWSMULT__t
assert 50=ROWSXTRA__t
jd'createcol f a int'
assert 800=getms'f a'
jd'insert f a';i.100
assert 100=getms'f jdactive'
assert 800=getms'f a'
jd'insert f a';1
assert (  >.1.5*101+50)=getms'f jdactive'
assert (8*>.1.5*101+50)=getms'f a'

jd'createtable f 4 1 1 a int'[jd'droptable f'[jd'dropdynamic'
jd'createhash f a'
assert 88='hash'getms'f jdhash_a'
assert 32='link'getms'f jdhash_a'

jd'createtable f 4 1 1 a int'[jd'droptable f'[jd'dropdynamic'
jd'insert f a';i.100
jd'createhash f a'
assert (8*4 p: +:101)='hash'getms'f jdhash_a'
assert 808='link'getms'f jdhash_a'
jd'insert f a';i.10
assert 111=getms'f jdactive'
assert (8*4 p: +:101)='hash'getms'f jdhash_a'
assert 888='link'getms'f jdhash_a'




