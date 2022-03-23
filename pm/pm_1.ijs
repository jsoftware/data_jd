NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

man=: 0 : 0
   bld rows,cols  NB. cols , rows
   
   bench_insert'' NB. insert ops per second
   bench_read''   NB. read ops per second
   
   
   faster ''      NB. current bench'' is x % faster that original

   runpm''        NB. run test under perfmon
   show''         NB. show perfmon results
   
   record'        NB. record last perfmon results in benchfile
   seerecord''    NB. show last record in benchfile
   seerecord 3    NB. show benchfile record 3 

   
jpm - j performance monitor - run in jconsole or Jqt
   showtotal_jpm_''
   showdetail_jpm_'jdx'
)

require'jfiles'
require'jpm'

old=: 0.00152047 NB. time from before project started


reload=: 3 : 0
load JDP,'pm/pm_1.ijs'
)

std_benchfile=: 'std_bench.txt'

bld=: 3 : 0
'rows cols'=: y
'new'jdadmin'ins1'
d=. i.rows
jd'createtable f'
for_n. i.cols do.
 jd('createcol f ',('c',":n),' int');d
end.
newdata=: ,('c',each":each<"0 i.cols),.<23
i.0 0
)


NB. datetime,insert 10 cols, read 10 cols, insert 1000 cols, read 1000 cols
std_bench=: 3 : 0
r=. 1000 100 100 100 100 100#.<.6{.6!:0''
bld 10 10
jd'read from f'
r=. r,(bench_insert''),bench_read''
bld 10 1000
jd'reads from f'
r=. r,(bench_insert''),bench_read''
<.r
)

std_record=: 3 : 0
if. -.fexist std_benchfile do. '' fwrite std_benchfile end.
((":std_bench''),LF) fappend std_benchfile
)


NB. return ops per second
NB. 500 bench 'jd''insert f'';newdata'
NB. 500 bench 'jd''read from f where jdindex=1'''
bench=: 4 : 0
%x timex y
)

bench_insert=: 3 : 0
500 bench 'jd''insert f'';newdata'
)

bench_read=: 3 : 0
500 bench 'jd''read from f where jdindex=1'''
)

old=: 0.00152047 NB. bld 50 300000

faster=: 3 : '(old-bench'''')%old' NB. faster bench''

runpm_insert=: 3 : 0
start_jpm_''
jd'insert f';newdata
show''
)

runpm_read=: 3 : 0
start_jpm_''
jd'read from f where jdindex=1'
show''
)


show=: 3 : 0
0 1 showtotal_jpm_''
)

record=: 3 : 0
if. -.fexist benchfile do. jcreate benchfile end.
(<(isotimestamp 6!:0'');<show'') jappend benchfile
)

seerecord=: 3 : 0
if. y-:'' do. y=. <:1{jsize benchfile end.
't d'=. >jread benchfile;y
echo t
d
)
