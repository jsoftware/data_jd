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
e=. 'invalid'
a1=. <:<.2^7
b1=. <:-a1
  jd  'update f';'jdindex=0';'i1';a1
  jd  'update f';'jdindex=0';'i1';b1
e jdae'update f';'jdindex=0';'i1';>:a1
e jdae'update f';'jdindex=0';'i1';<:b1

a2=. <:<.2^15
b2=. <:-a2
  jd  'update f';'jdindex=0';'i2';a2
  jd  'update f';'jdindex=0';'i2';b2
e jdae'update f';'jdindex=0';'i2';>:a2
e jdae'update f';'jdindex=0';'i2';<:b2

a4=. <:<.2^31
b4=. <:-a4
  jd  'update f';'jdindex=0';'i4';a4
  jd  'update f';'jdindex=0';'i4';b4
e jdae'update f';'jdindex=0';'i4';>:a4
e jdae'update f';'jdindex=0';'i4';<:b4

NB. csv tests

CSVFOLDER=: '~temp/jd/csv/intx'

d1=: <.(-2^7),23,<:2^7
d2=: <.(-2^15),23,<:2^15
d4=: <.(-2^31),23,<:2^31
d8=: imin_jd_,23,imax_jd_

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
