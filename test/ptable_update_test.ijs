NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

require JDP,'tools/ptable.ijs'

chk=: 3 : 0
jd 'update ptab ';y
jd'update f'   ;y
assert ({:jd'reads from ptab order by sort')-:{:jd'reads from f order by sort'
)

ptablebld'int'

chk'val=6';'p1';666 777 888 999
chk'val=6 and p=2015';'p1';23 24
chk'val=5 and p in (2015,2016)';'p1';1111 2222;'p2';23 24


