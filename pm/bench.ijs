NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

require'jfiles'
require'jpm'

benchfile=: 'bench.ijf'

man=: 0 : 0
run standard benchmark over time and versions - provide base for measuring performance

   show''   NB. numbered and tests
   run 2    NB. run test 2
   runall'' NB. run all tests (with jd version and timestamp)
   runpm 2  NB. run performance monitor on test 2 
   LAST     NB. result of last runall
   record'' NB. append LAST to benchfile
   jsize benchfile
   jread benchfile;0
   
jpm - j performance monitor - run in jconsole or Jqt
   showtotal_jpm_''
   showdetail_jpm_'jdx'
)

FROWS=: 100000 NB. rows in big table
GROWS=: 1000   NB. rows in join table

NB. build all tables and read everything so it is all in ram 
build=: 3 : 0
'new'jdadmin'bench'

jd'createtable e'
jd'createcol e a int'

d=. i.FROWS
jd'createtable f'
jd'createcol   f a int';d
jd'createcol   f b int';d
jd'createcol   f c int';d
jd'createcol   f d int';d
jd'createcol   f e int';FROWS$i.GROWS NB. used for ref to table g

jd'createtable g'
jd'createcol   g m int';i.GROWS
jd'createcol   g n byte 4';(GROWS,4)$'abcdefghi'

jd'ref f e g m'

jd'read from e'
jd'read from f,f.g'
i.0 0 
)

a=. 23
pairs1=:    'a';a;'b';a;'c';a;'d';a;'e';a
a=. i.1000
pairs1000=: 'a';a;'b';a;'c';a;'d';a;'e';a

tests=: <;._2 [ 0 : 0
jd'read from e'
jd'read from f where a=-1'
jd'read from f where a=50000'
jd'read from f where a<2000'
jd'reads from f where a<2000'
jd'read from f where a<2000 or b=50002'
jd'read from f where a=50000 and b<50002'
jd'reads from f,f.g where a=-1'
jd'reads from f,f.g where a=-1'
jd'insert f';pairs1
jd'insert f';pairs1000
)

show=: 3 : 0
;LF,~each(3":each <"0 i.#tests),each' ',each tests
)

NB. y is test number to run
run=: 3 : 0
build''
s=. ;y{tests
s;~6":<.1e6*timex s
)

runall=: 3 : 0
LAST=:    ((jd'list version');(isotimestamp 6!:0'')),>run1 each i.#tests
)

record=: 3 : 0
if. -.fexist benchfile do. jcreate benchfile end.
(<LAST) jappend benchfile
)

NB. y is test number to run
runpm=: 3 : 0
s=. y
if. 4=3!:0 s do. s=. ;y{tests end.
echo s
build''
start_jpm_''
a=. 0[".s
)
