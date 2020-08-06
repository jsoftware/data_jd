NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. jddeletefolder tests

ae=: 'assertion failure'

jdadmin 0

NB. clean state
f=:  jpath'~/_jd_rmdir_test'
1!:5 :: [<jpath f
jddeletefolderok_jd_ f
jddeletefolder_jd_ f


NB. not temp and not database tests
jddeletefolder_jd_ f NB. OK - not a file or a folder

'' fwrite f
assert ae-:jddeletefolder_jd_  etx f NB. err - is a file
ferase f

jdcreatefolder_jd_ f
jddeletefolder_jd_ f                NB. OK - delete empty folder

jdcreatefolder_jd_ f
'' fwrite f,'/foo'
assert ae-:jddeletefolder_jd_ etx f NB. err - non-empty - non-database - non temp

jddeletefolderok_jd_ f
jddeletefolder_jd_ f                NB. OK - deleteok

NB. not temp and database tests
jdadminnew f
assert ae-:jddeletefolder_jd_ etx f  NB. locked

jdadmin 0
jddeletefolder_jd_ f            NB. OK - delete database class

jdadminnew f
jd'createtable a'
jd'createtable b'
jd'droptable a'

jdadmin 0
jddeletefolder_jd_ f,'/b'
jddeletefolder_jd_ f            NB. OK - delete jd folder

jdadminnew f
jddropstop_jd_''
jdadmin 0
assert ae-:jddeletefolder_jd_ etx f  NB. dropstop
jdadmin f
0 jddropstop_jd_''
jdadmin 0
jddeletefolder_jd_ f

NB. temp tests
f=. '~temp/jd/test'
jddeletefolderok_jd_ f

jdadminnew 'test'
jdadmin 0
jddeletefolder_jd_ f                NB. OK - ~temp

jdadminnew 'test'
jddropstop_jd_''
jdadmin 0
assert ae-:jddeletefolder_jd_ etx f  NB. dropstop
jdadmin 'test'
0 jddropstop_jd_''
jdadmin 0
jddeletefolder_jd_ f

jdadminnew '~temp/jd/_jdtest'
jd'createtable f'
jd'createtable g'
jd'droptable f'


NB. older test
f=. '~temp/jd/jd_rmdir_test'
jdcreatefolder_jd_ f
jddeletefolderok_jd_ f
jddeletefolder_jd_ f
jddeletefolder_jd_ f                 NB. ok does not exist
jdcreatefolder_jd_ f
jddeletefolder_jd_ f                 NB. ok empty
jdcreatefolder_jd_ f
'abc' fwrite f,'/test'
NB. following test not valid with use of ~temp
NB.assert ae-:jddeletefolder_jd_ etx f  NB. not empty
jddeletefolderok_jd_ f
jddeletefolder_jd_ f
