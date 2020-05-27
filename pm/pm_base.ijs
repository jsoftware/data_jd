NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

reload=: 3 : 0
load JDP,'pm/pm_base.ijs'
)

man=: 0 : 0

   init''     NB. create pm db with various size tables
   runall''   NB. run all tests against all tables

   runpm''    NB. run test under perfmon
   runshow''  NB. show perfmon results
   runrecord' NB. record last perfmon results in bench file

   jsize benchfile
   jread benchfile;0
   
jpm - j performance monitor - run in jconsole or Jqt
   showtotal_jpm_''
   showdetail_jpm_'jdx'
)

require'jfiles'
require'jpm'

benchfile=: 'bench.ijf'

msize=:  8   NB. size for big table
mrorws=: 100 NB. rows for result 

tnames=: ('a0');(<'a1e'),each ":each <"0 i.msize
counts=: 0,10^i.<:#tnames

gen=: 3 : 0
'tcount ncount value'=. y
value ((ncount<.tcount)?.tcount)}tcount#2
)

NB. tname bld tcount,ncount,value
bld=: 4 : 0
n=. x
jd'createtable ',n
jd'createcol ',n,' a int'
jd'createcol ',n,' b int'
jd'createcol ',n,' c int'
jd'createcol ',n,' d int'
p=. 'a';(gen y,23);'b';(gen y,24);'c';(gen y,25);'d';(gen y,26)
jd('insert ',n);p
)

init=: 3 : 0
'new'jdadmin'pm'
tnames bld each (<"0 counts),each 1000
jd'info summary'
)

tests=: <;._2 [ 0 : 0
jd'insert D';'a';3;'b';3;'c';3;'d';3
jd'read count a from D where  a=23'
jd'read count a from D where  a=23 or b=24'
jd'read count a from D where  a=23 or b=24 or c=25'
jd'read count a from D where  a=23 or b=24 or c=25 or d=26'
jd'read count a from D where (a=23 or b=24 or c=25) and d=26'
jd'read count a from D where (a=23 or b=24 or c=25) and (a=23 or d=26)'
)

run=: 3 : 0
d=. tests rplc each <'D';y
r=. ''
for_t. d do.
 t=. ;t
 ".t NB. run once
 r=. r,10 timex t
end.
)

NB. picoseconds - 100000
runall=: 3 : 0
r=. run each tnames
r=. <.each 1000000*each r
r=. (,.each r),<>tests
(tnames,<'tests'),:r
)

runpm=: 3 : 0
start_jpm_''
jd'read count a from a1e3 where  a=23'
a=. <runshow''
start_jpm_''
jd'insert a1e3';'a';3;'b';3;'c';3;'d';3
a,<runshow''
)

runpm=: 3 : 0
start_jpm_''
".y
a=. y,LF,showtotal_jpm_''
)


runrecord=: 3 : 0
if. -.fexist benchfile do. jcreate benchfile end.
all=. <runall''
a=. <runpm'jd''read count a from a1e3 where a=23'''
b=. <runpm 'jd''insert a1e1'';''a'';3;''b'';3;''c'';3;''d'';3'

d=. <(<isotimestamp 6!:0''),(<jd'list version'),all,a,b
d jappend benchfile
)

seerecord=: 3 : 0
'ts ver all rd ins'=:>jread benchfile;y
'ts ver all rd ins'
)



