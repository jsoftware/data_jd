NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. jddeletefolder tests

ae=: 'assertion failure'
de=: 'domain error'

f=. '~/jd_rmdir_test'
jdcreatefolder_jd_ f
jddeletefolderok_jd_ f
jddeletefolder_jd_ f
jddeletefolder_jd_ f                 NB. ok does not exist
jdcreatefolder_jd_ f
jddeletefolder_jd_ f                 NB. ok empty
jdcreatefolder_jd_ f
'abc' fwrite f,'/test'
assert ae-:jddeletefolder_jd_ etx f  NB. not empty
jddeletefolderok_jd_ f
jddeletefolder_jd_ f
assert ae-:jddeletefolder_jd_ etx'/bad' NB. not enough /s 
