NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

jd_gen=: 3 : 0
y=. bdnames y
select. ;{.y
case. 'test' do.
 gentest }.y
case. 'types' do.
 gentypes }.y
case. 'ref2' do.
 'atab arows acols btab brows'=. }.y
 arows=. 0".arows
 acols=. 0".acols
 brows=. 0".brows
 assert arows>:brows
 t=. (arows,12)$'abc def'
 jd_createtable atab
 jd_createtable btab
 jd_createcol atab;'akey' ;'int';'_';i.arows
 jd_createcol atab;'adata';'int';'_';i.arows
 jd_createcol atab;'aref' ;'int';'_';arows$i.brows
 if. acols do.
  t=. (arows,12)$'abc def'
  for_i. i.acols do.
   jd_createcol atab;('a',(":i));'byte';'12';t
  end.
 end. 
 t=. (brows,12)$'abc def'
 jd_createcol btab;'bref';'int' ;'_' ;i.brows
 jd_createcol btab;'bb12';'byte';'12';t
 jd'ref A aref B bref'rplc'A';atab;'B';btab NB. jd_ref_jd_ fails
case. 'one' do.
 genone }.y
case. 'two' do.
 gentwo }.y
case. do.
 assert 0['unknown gen type'
end.
JDOK
)

NB. gen two f 10 g 3
NB. generate 2 tables suitable for testing dynamics
gentwo=: 3 : 0
 'atab arows btab brows'=. 4{.y
 arows=. 0".arows
 if. 0=#brows do. brows=. 3>.>.arows%10 else. brows=. 0".brows end.
 jd_createtable atab
 jd_createtable btab
 jd_createcol atab;'a1';'int';'_';i.arows
 jd_createcol atab;'a2';'int';'_';arows$i.brows
 jd_createcol btab;'b2';'int';'_' ;i.brows
)

genone=: 3 : 0
'atab arows acols'=. y
jd_createtable atab
d=. i.0".arows
for_i. i.0".acols do. 
 NB. jd_close''
 jd_createcol atab;('a',":i);'int';'_';d
end. 
)

NB. insert of 1st col sets Tlen
NB. subsequent creaecol gets defauilt data of right size
NB. this means set works
NB. not optimal efficient as dat is created and then set
gentest=: 3 : 0
t=. bdnames y
ECOUNT assert 2=#t
'tab n'=. t
n=. 0".n
jd_droptable tab
jd_createtable tab;'x int'
jd_insert tab;'x';i.n NB. insert sets Tlen and new col creates get default data
jd_createcol tab,' datetime datetime'
jd_set tab;'datetime';(n#20130524203132)-10000000000*?.n#20
jd_createcol tab,' float float'
jd_set tab;'float';0.5+i.n
jd_createcol tab,' boolean boolean'
jd_set tab;'boolean';n$0 1 1
jd_createcol tab,' int int'
jd_set tab;'int';100+i.n
jd_createcol tab,' byte byte'
jd_set tab;'byte';n$AlphaNum_j_
jd_createcol tab,' byte4 byte 4'
jd_set tab;'byte4';(n,4)$AlphaNum_j_
jd_createcol tab,' varbyte varbyte'
if. 0~:n do.
 t=. n$?.100000$10
 t=. (0,}:+/\t),.t
 jd_set tab;'varbyte';t;(+/{:"1 t)$AlphaNum_j_
end. 
JDOK
)

gentypes=: 3 : 0
t=. bdnames y
ECOUNT assert 2=#t
'tab n'=. t
n=. 0".n
a=. i.n
jd_droptable tab
jd_createtable tab
b=. 'boolean';'int';'int1';'int2';'int4';'float'
c=. (n$0 1) ;(a+70000);(a+15);(a+523);(a+60000);a+0.5

b=. b,'date';'datetime';'edate';'edatetime';'edatetimem';'edatetimen';'byte';'byte 4';'varbyte'
c=. c,(n#19551212);(n#19551212105812);(n#0);(n#0);(n#0);(n#0);(n$'abc');((n,4)$'abc');<n$'abc';'ab';'a'

'type problem'assert (/:~TYPES)-:/:~b-.<'byte 4'

for_t. b do.
 t=. ;t
 jd_createcol tab,' ',(t-.' '),' ',t 
end.
jd_insert tab;,(b-.each' '),.c
JDOK
)
