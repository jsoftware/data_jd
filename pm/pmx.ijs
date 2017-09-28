NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

0 : 0

 linux   cr  ref  unique
 100e6   33    9      37
 500e6  178   77     186
1000e6  379  158     495

   win
  50e6   35    8      29 
 100e6   65   20      72  
 500e6  142   75     426
)

FLUSH=: 1

jdf=: 3 : 0
jd y
if. FLUSH do. jd'flush' end.
)

tn=: 3 : 0
;(y>:1e6){(":y);(":<.y%1e6),'e6'
)

admin=: 3 : 0
jdadmin'~temp/jdpm/','d',tn y
)

NB. create tables for preformance tests
NB. cr    10 - create table h10    with    10 rows
NB. cr 100e6 - create table h100e6 with 100e6 rows
cr=: 3 : 0
assert 19<y
n=. y
jdadmin 0
jdcreatefolder_jd_'~temp/jdpm'
jdadminx'~temp/jdpm/','d',tn y
pmclear_jd_''
b=. 5*i.10000<.-:n
c=. 5>.<.n%1
jd'createtable f'
jdf'createcol  f a  int _';3*i.n
jdf'createcol  f b  int _';n$b      NB. ref f b g b - many to one
jdf'createcol  f c  int _';3*i.n    NB. data (no dups)
jdf'createcol  f d  int _';n$i.c    NB. data (dups)

jd'createtable g'
jdf'createcol  g b int _';|.b
pmr_jd_''
)

ref=: 3 : 0
pmclear_jd_''
jdf'ref f b g b'
pmr_jd_''
)

hash=: 3 : 0
pmclear_jd_''
jdf'createhash f d' 
pmr_jd_''
)

unique=: 3 : 0
pmclear_jd_''
jdf'createunique f c' 
pmr_jd_''
)

rd=: 3 : 0
jd'reads from f,f.h where c=7'
jd'reads from f,f.h where c=7'

jd'reads from f,f.g where cu=7'
jd'reads from f,f.g where cu=7'
jd'reads from f,f.h where cu=7'
jd'reads from f,f.h where cu=7'

jd'reads count a from f,f.g where dh=3'
jd'reads count a from f,f.g where dh=3'
jd'reads count a from f,f.h where dh=3'
jd'reads from f,f.g where c=7'
jd'reads from f,f.g where c=7'
jd'reads count a from f,f.h where dh=3'
)
