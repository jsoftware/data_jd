NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. hash of float not allowed to avoid conflict with J tolerant equal

d=: 2.1 2.100000000000001
assert =/d
assert -.=!.0/d
3!:3 d NB. see the difference 

float1=: 3 : 0
jdadminx'test'
jd'createtable f a float'
jd'insert f';'a';d
assert (jd'read from f')-:jd'read from f where a=2.1'
assert (jd'read from f')-:jd'read from f where a=2.100000000000001'
)

ALLOW_FVE_jd_=: 0 NB. ensure normal state
float1''
assert 'domain error'-:jd etx 'createhash f a' NB. hash float is error because of wrong answers
assert 'float not allowed'-: ;1{jdlast
