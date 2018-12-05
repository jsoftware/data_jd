NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

RLOG=: '~temp/jd/rlog/'

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
jd'repsrc ',RLOG
)

NB. testsnk
testsnk=: 3 : 0
jdadminnew'snk'
jd'repsnk ',RLOG
)

NB. empty db
test0=: 3 : 0
testsrc''
a=. jd'info summary'
testsnk''
assert a-:jd'info summary'
)

NB. db with 1 table and no rows
test1=: 3 : 0
testsrc''
setsrc''
a=. jd'info summary'
testsnk''
jd'repupdate'
assert a-:jd'info summary'
)

NB. db with 1 table and some rows
test2=: 3 : 0
testsrc''
setsrc''
2 addsrc 3
a=. jd'reads from t'
testsnk''
jd'repupdate'
assert a-:jd'reads from t'
)

NB. db repsrc with data 
NB. need to save copy of db in rlog and use it in repupdate
test3=: 3 : 0
jdadminnew'src'
setsrc''
2 addsrc 3
jd'repsrc ',RLOG
2 addsrc 3
a=. jd'reads from t'
testsnk''
jd'repupdate'
assert a-:jd'reads from t'
)

test0''
test1''
test2''
test3''
