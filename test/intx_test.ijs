NB. test i1/2/4 types

ad=: i:5

bld=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f i8 int'
jd'createcol f i1 int1'
jd'createcol f i2 int2'
jd'createcol f i4 int4'
jd'insert f';'i8';y;'i1';y;'i2';y;'i4';y
jd'insert f';'i8';y;'i1';y;'i2';y;'i4';y
jd'insert f';'i8';y;'i1';y;'i2';y;'i4';y
)

bld ad
c8=. jdgl_jd_'f i8'
c1=. jdgl_jd_'f i1'
c2=. jdgl_jd_'f i2'
c4=: jdgl_jd_'f i4'
assert (ad,ad,ad) =  n-(n<128){256 0[n=. a.i.dat__c1
assert (ad,ad,ad) = _1 ic dat__c2
assert (ad,ad,ad) = _2 ic dat__c4

assert d-:|.d=.{:jd'reads from f'
qs=: <;.2 '< <= = <> > >= in notin sample. '

test=: 3 : 0
for_q. qs do.
 q=. ;q
 d=. jd'reads from f where i8 ',q,' 2'
 assert d -:jd'reads from f where i1 ',q,' 2'
 assert d -:jd'reads from f where i2 ',q,' 2'
 assert d -:jd'reads from f where i4 ',q,' 2'
end.
)

test'' 

'like'jdae'reads from f where i1 like "2"'
'like'jdae'reads from f where i1 unlike "2"'
'like'jdae'reads from f where i2 like "2"'
'like'jdae'reads from f where i2 unlike "2"'
'like'jdae'reads from f where i4 like "2"'
'like'jdae'reads from f where i4 unlike "2"'
 
d=. jd'reads from f where i8 range (0,2,4,5)' 
assert d-:jd'reads from f where i1 range (0,2,4,5)'
assert d-:jd'reads from f where i2 range (0,2,4,5)'
assert d-:jd'reads from f where i4 range (0,2,4,5)'

NB. ref and empty join!
jd'createtable g'
jd'createcol g a int'
jd'insert g a';_5 0 5 99

jd'ref g a f i8'
d0=. jd'reads from g,g.f'
assert d-:|.d=.}:each{:do
assert 99 0 0 0 0=,;{:jd'reads from g,g.f where a=99'

jd'dropcol g jdref_a_f_i8'
'not allowed'jdae'ref g a f i4'

jd'dropcol g jdref_a_f_i4'
'not allowed'jdae'ref g a f i2'

jd'dropcol g jdref_a_f_i2'
'not allowed'jdae'ref g a f i1'

NB. update
bld i.3
jd'update f';'jdindex=0';'i8';22;'i1';23;'i2';24;'i4';25
assert 22 23 24 25=,;{:jd'reads from f where jdindex=0'

NB. invalid data errors
e=. 'bad int'
  jd  'update f';'jdindex=0';'i1';I1MAX_jd_
  jd  'update f';'jdindex=0';'i1';I1MIN_jd_
e jdae'update f';'jdindex=0';'i1';>:I1MAX_jd_
e jdae'update f';'jdindex=0';'i1';<:I1MIN_jd_

  jd  'update f';'jdindex=0';'i2';I2MAX_jd_
  jd  'update f';'jdindex=0';'i2';I2MIN_jd_
e jdae'update f';'jdindex=0';'i2';>:I2MAX_jd_
e jdae'update f';'jdindex=0';'i2';<:I2MIN_jd_

  jd  'update f';'jdindex=0';'i4';I4MAX_jd_
  jd  'update f';'jdindex=0';'i4';I4MIN_jd_
e jdae'update f';'jdindex=0';'i4';>:I4MAX_jd_
e jdae'update f';'jdindex=0';'i4';<:I4MIN_jd_

NB. csv tests

CSVFOLDER=: '~temp/jd/csv/intx'

d1=: I1MIN_jd_,23,I1MAX_jd_
d2=: I2MIN_jd_,23,I2MAX_jd_
d4=: I4MIN_jd_,23,I4MAX_jd_
d8=: IMIN_jd_,23,IMAX_jd_

f=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f i1 int1'
jd'createcol f i2 int2'
jd'createcol f i4 int4'
jd'createcol f i8 int' 
jd'insert f';'i1';d1;'i2';d2;'i4';d4;'i8';d8
jd'reads from f'
)

f''
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert (jd'reads from g')-:jd'reads from f'

NB. createcol
jd'createtable h'
jd'createcol h i1 int1';d1
jd'createcol h i2 int2';d2
jd'createcol h i4 int4';d4
jd'createcol h i8 int' ;d8

assert (jd'reads from h')-:jd'reads from f'

NB. intx
jdadminx'test'
jd'createtable t1'
jd'createcol t1 c1 int';i.5
jd'createcol t1 c2 byte';'abcde'

jd'intx t1 c1 int'
jd'intx t1 c1 int4'
jd'intx t1 c1 int2'
jd'intx t1 c1 int1'
jd'intx t1 c1 int'
jd'intx t1 c1 intx'
assert 'int1'-:typ__c[c=. jdgl_jd_'t1 c1'
jd'intx t1 c1 int'

jd'intx t1 c1 int'
jd'update t1';'jdindex=0';'c1';>:I4MAX_jd_
e jdae'intx t1 c1 int4'
e jdae'intx t1 c1 int2'
e jdae'intx t1 c1 int1'

jd'intx t1 c1 int'
jd'update t1';'jdindex=0';'c1';<:I4MIN_jd_
e jdae'intx t1 c1 int4'
e jdae'intx t1 c1 int2'
e jdae'intx t1 c1 int1'

jd'intx t1 c1 int'
jd'update t1';'jdindex=0';'c1';>:I2MAX_jd_
jd     'intx t1 c1 int4'
e jdae'intx t1 c1 int2'
e jdae'intx t1 c1 int1'

jd'intx t1 c1 int'
jd'update t1';'jdindex=0';'c1';<:I2MIN_jd_
  jd  'intx t1 c1 int4'
e jdae'intx t1 c1 int2'
e jdae'intx t1 c1 int1'

jd'intx t1 c1 int'
jd'update t1';'jdindex=0';'c1';>:I1MAX_jd_
  jd  'intx t1 c1 int4'
  jd  'intx t1 c1 int2'
e jdae'intx t1 c1 int1'

jd'intx t1 c1 int'
jd'update t1';'jdindex=0';'c1';<:I1MIN_jd_
  jd  'intx t1 c1 int4'
  jd  'intx t1 c1 int2'
e jdae'intx t1 c1 int1'

NB. intx delete
jdadminx'test'
jd'gen test f 10'
jd'intx f int int1'
jd'delete f';'x<2'
jd'intx f int int2'
jd'delete f';'x<4'
jd'intx f int int4'
jd'delete f';'x<6'
assert 106 107 108 109=>{:{:jd'read int from f'

NB. intx sort
jdadminx'test'
jd'gen test f 10'
jd'intx f int int1'
'int1'jdae'sort f int'
jd'intx f int int2'
'int2'jdae'sort f int'
jd'intx f int int4'
'int4'jdae'sort f int'

NB. ptable pcol
jdadminx'test'
jd'gen test f 0'
jd'intx f int int2'
'bad col type'jdae'createptable f int'
