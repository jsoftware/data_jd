NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
FORCEREVERT_jd_=: 0
jdadminx'test'
jd'gen test f 4'
a=. jd'read from f'
FORCEREVERT_jd_=: 1
'insert failed'jdae'insert f';,a
jdrepair_jd_'fixing it now'
repair_jd_''
jddamage_jd_'' 
assert 4='count'jdfroms_jd_ jd'reads count:count x from f'
jdadmin 0
jdadmin'test'
assert 4='count'jdfroms_jd_ jd'reads count:count x from f'
