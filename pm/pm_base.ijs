NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

NB. 'small' bld i.1000
bld=: 4 : 0
jd'createtable ',x
jd'createcol ',x,' a int'
jd'createcol ',x,' b int'
jd'createcol ',x,' c int'
jd'createcol ',x,' d int'
p=. 'a';y;'b';y;'c';y;'d';y
jd('insert ',x);p
)

init=: 3 : 0
'new'jdadmin'pm'
'a0'      bld ''
'a1'      bld 1
'a100'    bld i.100
'a1000'   bld i.1000
'a10000'  bld i.10000
'a100000' bld i.100000
jd'info summary'
)

tests=: <;._2 [ 0 : 0
jd'list version'
jd'read a from D'
jd'read a from D where  a=123'
jd'read a from D where  a=123 or b=234'
jd'read a from D where (a=123 or b=234) and c=127'
)

run=: 3 : 0
d=. tests rplc each <'D';y
for_t. d do.
 t=. ;t
 echo t
 timex t NB. run once
 r=. 10 timex t
 echo <.r*10e6
end.
)
