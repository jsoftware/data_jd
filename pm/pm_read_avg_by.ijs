NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

man=: 0 : 0
   bld ''      NB. cols , rows
   faster ''   NB. current bench'' is x % faster that original

   runpm y     NB. run test under perfmon
   show''      NB. show perfmon results
   
   record'     NB. record last perfmon results in benchfile
   seerecord'' NB. show last record in benchfile
   seerecord 3 NB. show benchfile record 3 

   
jpm - j performance monitor - run in jconsole or Jqt
   showtotal_jpm_''
   showdetail_jpm_'jdx'
)

require'jfiles'
require'jpm'

sentence=: 'read avg fare_amount by passenger_count from yellow_tripdata'

old=: 0.316146 NB. time from before project started

reload=: 3 : 0
load JDP,'pm/pm_read_avg_by.ijs'
)



foo=: 3 : 0
fare=. jd 'get yellow_tripdata fare_amount'
pcnt=. jd 'get yellow_tripdata passenger_count'
(~.pcnt),.pcnt (+/ % #)/. fare
)


benchfile=: 'bench.ijf'

jdadmin'taxi' NB. tripdata table from jdrt

faster=: 3 : '(old-jdtx sentence)%old' NB. faster bench''

NB. sentence
runpm=: 3 : 0
start_jpm_''
jd y
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


coclass 'jdquery'
coinsert 'jddatabase'

Query=: 3 : 0
q__=: inds;indices;nby;agg;cloc
if. 0 do.
 r=. ''
 for_n. cloc do.
  r=. r,<memu dat__n
 end. 
 read=: r
else.
 indices =: (-. _1"0@{.)&.|: indices
 read =: (inds{indices) readselect cloc
 q__=: q__,read
end. 
if. nby do. read =: nby (agg aggregate) read
elseif. #;agg do. read =: agg  4 :'x getagg  y'&.>  read
end.
)
