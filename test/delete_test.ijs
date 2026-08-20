NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

jdadminx'test'
jd'gen test f 6'
t=: jdgl_jd_'f'
assert(i.6)-:,'x'jdfroms_jd_ jd'reads from f'
assert 6=Tlen__t
jd'delete f';'x=3'
assert(3-.~i.6)-:,'x'jdfroms_jd_ jd'reads from f'
assert 5=Tlen__t
jd'delete f';'x>1'
assert(0 1)-:,'x'jdfroms_jd_ jd'reads from f'
assert 2=Tlen__t
