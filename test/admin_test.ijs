NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. jdadmin MTxx tests

jdadmin 0

'new'jdadmin'ada'
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';12

'new'jdadmin'adb'
jd'createtable g'
jd'createcol g a int'
jd'insert g';'a';12

assert 2=+/(<'[w]')={."1 jdadmin''

jdadmin 0
jdadmin'ada'
jdadmin'ada' NB. open when already open allowed
jdadmin'adb' NB. open another rw OK

NB. reopen ok with same mt
jdadmin 0
jdadmin'ada';0
jdadmin'ada';0
'same' jdadmae_jd_ jdadmin etx'ada';1

jdadmin 0
jdadmin'ada';1
jdadmin'ada';1
'same' jdadmae_jd_ jdadmin etx'ada';2

jdadmin 0
jdadmin'ada';2
jdadmin'ada';2
'same' jdadmae_jd_ jdadmin etx'ada';0

NB. error on open RO/CW when another already open
jdadmin 0
jdadmin'ada';0
'multiple' jdadmae_jd_ jdadmin etx'adb';1
'multiple' jdadmae_jd_ jdadmin etx'adb';2

NB. error on open RW/RO/CW when RO/CW already open
jdadmin 0
jdadmin'ada';1
'multiple' jdadmae_jd_ jdadmin etx'adb';0
'multiple' jdadmae_jd_ jdadmin etx'adb';1
'multiple' jdadmae_jd_ jdadmin etx'adb';2

NB. MRRO
jdadmin 0
jdadmin'ada';1
jd'read from f'
'read type'jdae'insert f';'a';12

NB. MRCW
jdadmin 0
jdadmin'ada';2
a=. jd'read from f'
jd'insert f';'a';12
jdadmin 0
jdadmin'ada';0
assert a-:jd'read from f'

