NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

require'jfiles'
require'jpm'

benchfile=: 'bench.ijf'

0 : 0
run standard benchmark over time and versions
provide base for measuring performance improvements
)

build=: 3 : 0
jdadminnew'bench'
d=. i.100000
jd'createtable f'
jd'createcol f a int';d
jd'createcol f b int';d
jd'createcol f c int';d
jd'createcol f d int';d
jd'createcol f e int';d
)

a=. 23
pairs1=:    'a';a;'b';a;'c';a;'d';a;'e';a
a=. i.1000
pairs1000=: 'a';a;'b';a;'c';a;'d';a;'e';a

tests=: <;._2 [ 0 : 0
list          > 'list version'
read a        > 'read from f where a=50000'
read a b      > 'read from f where a=50000 and b<50002'
read 2000     > 'read from f where a<2000'
reads 2000    > 'reads from f where a<2000'
insert 1      > 'insert f';pairs1
insert 1000   > 'insert f';pairs1000
)

ops=: (<'jd'),each (>:;tests i. each'>')}.each tests

labs=: deb each(tests i. each'>'){.each tests

benchdo=: 3 : 0
build''          NB. clean slate
1 timex each ops NB. warm up
r=. <"0[100%~ <.100 * 1000 *;100 timex each ops
LAST=: (,.'date-version';(4 3 3":3{.6!:0''),' ',jd'list version'),.labs,:r
)

recordlast=: 3 : 0
if. -.fexist benchfile do. jcreate benchfile end.
(<LAST) jappend benchfile
)

0 : 0
jpm - j performance monitor
should be run in jconsole

   showtotal_jpm_''
   showdetail_jpm_'jdx'
)

pmdo=: 3 : 0
start_jpm_''
a=. 0[jd'read from f where a<2000'
)
