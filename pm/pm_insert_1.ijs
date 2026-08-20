NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

man=: 0 : 0
   bld rows,cols NB. cols , rows
   faster ''     NB. current bench'' is x % faster that original

   runpm''       NB. run test under perfmon
   show''        NB. show perfmon results
   
   record'       NB. record last perfmon results in benchfile
   seerecord''   NB. show last record in benchfile
   seerecord 3   NB. show benchfile record 3 

   
jpm - j performance monitor - run in jconsole or Jqt
   showtotal_jpm_''
   showdetail_jpm_'jdx'
)

require'jfiles'
require'jpm'

old=: 0.00152047 NB. time from before project started


reload=: 3 : 0
load JDP,'pm/pm_insert_1.ijs'
)

benchfile=: 'bench.ijf'

bld=: 3 : 0
'cols rows'=: y
'new'jdadmin'ins1'
d=. i.rows
jd'createtable f'
for_n. i.cols do.
 jd('createcol f ',('c',":n),' int');d
end.
newdata=: ,('c',each":each<"0 i.cols),.<23
i.0 0
)

bench=: 3 : 0
y timex 'jd''insert f'';newdata'
)

old=: 0.00152047 NB. bld 50 300000

faster=: 3 : '(old-bench'''')%old' NB. faster bench''

runpm=: 3 : 0
start_jpm_''
jd'insert f';newdata
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
