NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

f=: 3 : 0
jdadminnew'test'
jd'createtable /pairs f';'a';((y?.y){y$i:3);'b';y$'abbcas'
)

tst=: 3 : 0
f 30
d=: jd'reads from f order by ',y
jd'sort f ',y
assert d-:jd'reads from f'
)

tst'a'
tst'a desc'
tst'b'
tst'b desc'

tst'a,b'
tst'a desc,b'
tst'a,b desc'
tst'a desc,b desc'

tst'b,a'
tst'b desc,a'
tst'b,a desc'
tst'b desc,a desc'

f 30
jd'sort f a,b'
d=. jd'reads from f'
jd'sort f a,b desc'
assert -.d-:jd'reads from f'

