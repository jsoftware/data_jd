NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. jd'validate'

unexpected=: 'unexpected error'

reget=: 3 : 0
d=: getdb_jd_''
t=: getloc__d'a'
c=: getloc__t'aref'
)

jdadminx'test'
jd'gen ref2 a 3 2 b 2'
[r=. jd'validate'
assert ''-:r

reget''
assert 3=Tlen__t
Tlen__t=: 2
[r=. jd'validate'
assert 6=+/LF=r

reget''
Tlen__t=: 3

q=: 0+0 1 0 NB. 0+dat__c
dat__c=: dat__c,1
[r=. jd'validate'
assert 1=+/LF=r

reget''
dat__c=: q
dat__c=: i.Tlen__t,2
[r=. jd'validate'
assert unexpected-:(#unexpected){.r

reget''
dat__c=: q

jd'reads from a,a.b' NB. force refleft1 dat;
reget''
c=: getloc__t'jdreference_aref_b_bref'
NB. assert 0=dirty__c
NB. assert 0 1 0-:datl__c
q=: 0+0 1 0
datl__c=: 2{.q

jd'close'


[r=. jd'validate'
assert 0=+/LF=r

reget''
c=: getloc__t'jdreference_aref_b_bref'
datl__c=: q

jd'dropdynamic'
jd'reference a aref b bref'
jd'reads from a,a.b'

reget''
c=: getloc__t'jdreference_aref_b_bref'
jd'validate'
