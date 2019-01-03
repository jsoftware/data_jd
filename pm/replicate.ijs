NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

NB. replicate performance
NB. some stuff copied from replicate_test.ijs

0 : 0
usage: src-task creates src db and snk-task replicates

src-task                     snk-task
  writerinit 1 NB. repsrc
                               reader 0.01 NB. start just before writer
  writer 100000 0
  NB. finishes
                               NB. finishes
  repvalidate''                    
)

RLOG=: '~temp/jd/rlog/'

addsrc=: 3 : 0
d=. ?10000
d=. 'a';d;'b';d;'c';d;'d';d;'e';d;'f';d;'g';d;'h';d
jd'insert t';d
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


NB. y 1 does repsrc
NB. create src table t with a few rows
writerinit=: 3 : 0
jddeletefolderok_jd_ RLOG
jddeletefolder_jd_ RLOG
jdadminnew'src'
setsrc''
if. y do. jdrepsrc_jd_ RLOG end.
)

NB. writer rows,delay
writer=: 3 : 0
'rows delay'=. y
while. rows do.
 rows=. <:rows
 addsrc'' 
 6!:3[delay
end.
d=. dbl_jd_
echo RLOGBLOCK__d;'RLOGBLOCK'
jd'read count a from t'
)

NB. reader y - delay between update requests
NB. 5 seconds no action before guiting
NB. quit if no new updates in 5 seconds
reader=: 3 : 0
jdadminnew'snk'
jdrepsnk_jd_ RLOG
d=. getdb_jd_''
n=. 0
t=. 6!:1''
while. 1 do.
 if.  RLOGINDEX__d=fsize RLOGFH__d do.
  6!:3[y
  if. 5<t-~6!:1'' do. break. end.
 else.
  t=. 6!:1''
  jd'info summary' NB. trigger update
 end. 
end.
(3!:1 jd'reads from t')fwrite RLOG,'/reader.dat'
d=. dbl_jd_
echo RLOGBLOCK__d;'RLOGBLOCK'
jd'read count a from t'
)

repvalidate=: 3 : 0
(3!:2 fread RLOG,'/reader.dat')-:jd'reads from t'
)

NB. y is rows
report0=: 3 : 0
r=. 0 2$''

writerinit 1
a=. timex'writer y 0'rplc 'y';":y
NB. echo a=. t;'writer log on'
r=. r,a

writerinit 0
b=. timex'writer y 0'rplc 'y';":y
NB. echo a=. t;'writer log off'
(a;'log on'),(b;'log off'),:(<.100*_1+a%b);'percent overhead'
)

report1=: 3 : 0
r=. 0 2$''
writerinit''
writersrc''
t=. timex'writer y 0'rplc 'y';":y
echo a=. t;'writer log on with reader'
r=. r,a
)
