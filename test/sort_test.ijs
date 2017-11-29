NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

tst=: 3 : 0
jd'sort ',y
assert d-:jd'reads from f,f.g order by f.akey'
)

jdadminx'test'
jd'gen ref2 f 6 2 g 4'
d=: jd'reads from f,f.g order by f.akey'

tst'/desc g bref'
tst'      g bref'
tst'/desc g bref bb12'
tst'      g bref bb12'

tst'/desc f aref'
tst'     f aref'
tst'/desc f adata a0'
tst'      f adata a0'

jd'gen test h 10'
d=. jd'reads from h order by boolean desc,int desc'
jd'sort /desc h boolean int'
assert d-:jd'reads from h'

