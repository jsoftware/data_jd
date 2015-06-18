NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. Assuming hash__x is correct, verify that hash__y is correct.
testhash =: 4 : 0
'hx hy' =. hash__x;hash__y
nh =. #hy
i =. hx I.@:~: hy
NB. Indices can be shifted but must be the same as a set
assert hx -:&(/:~)&(i&{) hy
NB. Each index in hy must come after its hash
NB. (there are no _1's between them cyclically).
hi =. nh | gethash__y"0 dat {~ i{hy
assert *./ i (_1 -.@e. hy{~nh|]+nh|-) hi
)

testdat =: 3 : 0
jdadminx 'test'
jd 'createtable f a int'
jd 'insert f a';y
jd 'createtable g a int'
jd 'insert g a';y

jd 'createhash f a'
HASHPASSLEN_jd_ =: 64 [ H =. HASHPASSLEN_jd_
  jd 'createhash g a'
HASHPASSLEN_jd_ =: H

dat =: y
testhash/ jdgl_jd_@> 'f jdhash_a';'g jdhash_a'
)

testdat i.1000
testdat 1000 ?@$ 2000
