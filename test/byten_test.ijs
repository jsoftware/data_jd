NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

bld=: 3 : 0
jdadminnew'test'
jd'createtable f'
jd'createcol f a byte 2'
jd'insert f';'a';2 2$'a'
)

bld''

assert 2 2=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 5'
assert 2 5=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 3'
assert 2 3=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 5';'x'
assert 2 5=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 3';'y'
assert 2 3=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 1'
assert 2 1=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 0'
assert 2 0=$'a' jdfrom_jd_ jd'read from f'

jd'byten f a 5';'x'
assert 2 5=$'a' jdfrom_jd_ jd'read from f'

'bad fill'jdae'byten f a 5';'xy'
'bad fill'jdae'byten f a 5';23

jd'createcol f b byte'
'bad type'jdae'byten f b 3'

jd'createcol f c int'
'bad type'jdae'byten f c 3'
