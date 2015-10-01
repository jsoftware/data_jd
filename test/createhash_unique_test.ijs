NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. createhash
NB. createhash /nc
NB. createunique

jdadminx'test'
jd'gen two f 100 g 10'
jd'dropdynamic'
jd'createhash f a1'
jd'dropdynamic'
jd'createunique f a1'
jd'dropdynamic'
'warning: deleted 90'jdae'createunique f a2' NB. older duplicate rows are deleted!

jdadminx'test'
jd'gen two f 100 g 10'
jd'createhash f a2'
jd'dropdynamic'
jd'createhash g b2'
jd'dropdynamic'
jd'createunique g b2'

NB. /nc
jd'dropdynamic'

'/nc'jdae'createhash /nc 10 f a1' NB. too small

jd'createhash f a2'
h=. jdgl_jd_'f jdhash_a2'
assert 211=#hash__h
assert 10=+/hash__h~:_1
assert 90=+/link__h~:_1

jd'dropdynamic'
jd'createhash /nc 10 f a2'
h=. jdgl_jd_'f jdhash_a2'
assert 41=#hash__h          NB. smaller hash table - builds faster
assert 10=+/hash__h~:_1
assert 10=+/link__h=_1

d=. jd'read from f'
jd'insert f';,d
assert 41=#hash__h          NB. insert of more values
assert 10=+/hash__h~:_1
assert 10=+/link__h=_1

jd'insert f';'a1';1000;'a2';100
assert 41=#hash__h          NB. insert of more values
assert 11=+/hash__h~:_1
assert 11=+/link__h=_1

jd'insert f';'a1';1001 1002;'a2';101 102
assert 41=#hash__h          NB. insert of more values
assert 13=+/hash__h~:_1
assert 13=+/link__h=_1

NB. insert more new nub values than will fit
'/nc'jdae'insert f';'a1';(1003+i.40);'a2';102+i.40


