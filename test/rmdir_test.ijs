NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. jddeletefolder tests

ae=: 'not allowed'
de=: 'domain error'

0 : 0
err - is a file
OK  - not a folder
err - locked
OK  - empty
OK  - deleteok
err - dropstop (not deleteok)
OK  - jdclass
)

jdadmin 0

f=. '~/jd_rmdir_test'

jddeletefolderok_jd_ f
jddeletefolder_jd_ f                 NB. deletefodlerok

jddeletefolder_jd_ f                NB. OK  - not a file or a folder

assert 3='abc' fwrite f
ae assert jddeletefolder_jd_  etx f NB. err - is a file

ferase f
jdcreatefolder_jd_ f                NB. not a folder (or a file)

jdcreatefolder_jd_ f
jddeletefolder_jd_ f                NB. OK - empty

jdadminnew f
ae assert jddeletefolder_jd_ etx f  NB. protect non _temp db

jddeletefolderok_jd_ f
ae assert jddeletefolder_jd_ etx f  NB. locked

jdadmin 0
jddeletefolder_jd_ etx f            NB. not locked and deleteok

f=. '~temp/jd/test'

jdadminnew 'test'
jdadmin 0
jddeletefolder_jd_ f                NB. OK - ~temp

jdadminnew 'test'
jddropstop_jd_''
jdadmin 0
ae assert jddeletefolder_jd_ etx f  NB. protect dropstop
jdadmin 'test'
0 jddropstop_jd_''
jdadmin 0
jddeletefolder_jd_ f

NB. older test
f=. '~/jd_rmdir_test'
jdcreatefolder_jd_ f
jddeletefolderok_jd_ f
jddeletefolder_jd_ f
jddeletefolder_jd_ f                 NB. ok does not exist
jdcreatefolder_jd_ f
jddeletefolder_jd_ f                 NB. ok empty
jdcreatefolder_jd_ f
'abc' fwrite f,'/test'
ae assert jddeletefolder_jd_ etx f  NB. not empty
jddeletefolderok_jd_ f
jddeletefolder_jd_ f
