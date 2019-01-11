NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

RLOG=: '~temp/jd/rlog/'

NB. use of J file handles means a Jd task can have only 1 user of RLOG,'rlog'

testerrors=: 3 : 0
jdadmin 0
jddeletefolder_jd_ jddeletefolderok_jd_ RLOG
'should not be any open handles' assert 0=#1!:20''
jddeletefolder_jd_ RLOG
jdcreatefolder_jd_ RLOG
h=: 1!:21 <jpath RLOG,'rlog'

jdadminnew'jnk'
'replicate'jdadmae_jd_ jdrepsrc_jd_ etx RLOG
'replicate'jdadmae_jd_ jdrepsnk_jd_ etx RLOG
1!:22 h

jdadminnew'jnk'
jdrepsrc_jd_ RLOG
jdadmin 0
h=: 1!:21 <jpath RLOG,'rlog'
'replicate handle error'assert 1-:jdadmin :: 1: 'jnk'
1!:22 h
)

insdata=: 3 : 0
d=. y?10000
'a';d;'b';d;'c';d;'d';d;'e';d;'f';d;'g';d;'h';d
)

NB. 200 addsrc 60*60*24
addsrc=: 4 : 0
jdaccess'src'
for. i.y do.
 jd'insert t';insdata x
end. 
)

rd=: 3 : 0
jdaccess y
jd'reads count a from t'
)

setsrc=: 3 : 0
jd'createtable t'
jd'createcol t a int'
jd'createcol t b int'
jd'createcol t c int'
jd'createcol t d int'
jd'createcol t e int'
jd'createcol t f int'
jd'createcol t g int'
jd'createcol t h int'
)

testsrc=: 3 : 0
jdadminnew'src'
jdrepsrc_jd_ RLOG
)

NB. testsnk
testsnk=: 3 : 0
jdadminnew'snk'
jdrepsnk_jd_ RLOG
)

NB. empty db
test0=: 3 : 0
jdadmin 0 NB. clean slate
jddeletefolder_jd_ jddeletefolderok_jd_ RLOG
testsrc''
a=. jd'info summary'
jdadmin 0 NB. so reader can use rlog
testsnk''
assert a-:jd'info summary'
)

NB. db with 1 table and no rows
test1=: 3 : 0
jdadmin 0
jddeletefolder_jd_ jddeletefolderok_jd_ RLOG
testsrc''
setsrc''
a=. jd'info summary'
jdadmin 0 NB. so reader can use rlog
testsnk''
assert a-:jd'info summary'
)

NB. db with 1 table and some rows
test2=: 3 : 0
jdadmin 0
jddeletefolder_jd_ jddeletefolderok_jd_ RLOG
testsrc''
setsrc''
2 addsrc 3
a=. jd'reads from t'
jdadmin 0 NB. so reader can use rlog
testsnk''
assert a-:jd'reads from t'
)

NB. db repsrc with data 
NB. need to save copy of db in rlog and use it in repupdate
test3=: 3 : 0
jdadmin 0
jddeletefolder_jd_ jddeletefolderok_jd_ RLOG
jdadminnew'src'
setsrc''
2 addsrc 3
jdrepsrc_jd_ RLOG
2 addsrc 3
a=. jd'reads from t'
jdadmin 0 NB. so reader can use rlog
testsnk''
assert a-:jd'reads from t'
)

testerrors''
test0''
test1''
test2''
test3''
