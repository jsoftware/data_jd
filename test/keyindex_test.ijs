load JDP,'tools/ptable.ijs'

tst=: 3 : 0
kf=:  jd'key f';y
kF=:  jd'key ptab';y
assert kf-:kF
)
 
ptablebld'int'

NB. check that i. is used and not i:
assert 1=jd'key ptab';'val';16
assert 1=jd'key ptab';'val';16;'b1';'B'

NB. nub - single part
tst 'p';2015;'val';6
tst 'p';2015;'val';123       NB. not found
tst 'p';2015 2015;'val';6 16
tst 'p';2015 2015;'val';6 99 NB. not found
tst 'p';1999;'val';0         NB. 1st
tst 'p';1999;'val';123       NB. 1st not found

NB. multiple parts
tst 'p';2013 2015 2016 2015 2013;'val';16 6 8   19 14
tst 'p';2013 2015 2016 2015 2013;'val';16 6 999 19 14

tst 'p';2020;'val';23 NB. part not found

NB. update with indexes from keyindex
key=. 'p';2013 2015 2016 2015 2013;'val';16 6 8 19 14
k=. jd'key f';key
data=. 'p1';66 77 123 88 99
jd'update ptab';k;data
jd'update f';k;data
assert (jd'reads from f')-:jd'reads from ptab'
