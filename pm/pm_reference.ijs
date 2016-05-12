NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. pm reference 
NB. most of this has been duplicated in pm_hash.ijs
NB. eventually this will deal more directly with reference

0 : 0
Jd hash differs from J hash

J has a special hash for ints
J has a special hash for small range ints that is much faster

Jd does not have these special cases
)

jdtmit=: 3 : 0
<.0.5+1000*timex 'jd ''',y,''''
)

NB. tst 30r6
tst=:3 : 0
jdadminx'test'
data=: y ?@$ <:2^63 NB. avoid J small range hash
jd'createtable f'
jd'createcol f a int _';data
jd'createtable g'
jd'createcol g a int _';data

fhash=. jdtmit 'createhash f a'
ghash=. jdtmit 'createhash g a'
fgref=. jdtmit 'reference f a g a'
jd=. +/fhash,ghash,fgref

j=. <.1000*0.5+2*timex 't=. data i. data' NB. doubled for both ways

t=. <"0 fhash,ghash,fgref,jd,j,<.0.5+jd%j
(,.;:'fhash ghash fgref jd j ratio'),.t
)

setdata=: 3 : 0
NB. data=: y ?@$ <:2^63 NB. avoid J small range hash
A=: (i.y)+y$0,<.2^62
B=: (i.y)+y$0,<.2^62
i.0 0
)

jidot=: 3 : 0
2*timex 't=. A i. B'
)

hash_test=: 3 : 0
d=: i.y
col=. pointer_to_name_jd_ 'd__'

hlen=. 4 p: +:y
h=: hlen$_1
hashP=. pointer_to_name_jd_ 'h__'

l=: y$_1
linkP=. pointer_to_name_jd_ 'l__'

a=: y$1
actP=. pointer_to_name_jd_ 'a__'

off=. 0

lib =. LIBJD_jd_,' hash_insert_fixed1 > x x x x x x x'
r =. lib cd off;hashP;linkP;actP;col;col
)

hashv=: 3 : 0
src=: y
snk=: (#y)$_1
srcp=. pointer_to_name_jd_ 'src__'
snkp=. pointer_to_name_jd_ 'snk__'
lib =. LIBJD_jd_,' hash_fixed1 > x x x'
r =. lib cd srcp;snkp

len=. 11>.4 p: +:#y
snk=: len|snk
i.0 0
)
