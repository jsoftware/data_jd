NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

load JDP,'gen/ptable.ijs'

ptablebld'int'

chk=: 3 : 0
jd'delete base';y
jd'delete f';y
assert (jd'reads from base order by sort')-:jd'reads from f order by sort'
)
assert 24=;{:jd'reads count p from f'
chk'val=14'
assert 19=;{:jd'reads count p from f'
chk'jdindex in (4,21)'
assert 17=;{:jd'reads count p from f'
