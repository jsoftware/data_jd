NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

CSVFOLDER=: '~temp/jd/csv/test/'

require JDP,'tools/ptable.ijs'

ptype=: 'int'
ptype=: 'edate'

ptablebld ptype

NB. base
jddeletefolder_jd_ CSVFOLDER
jd'csvwr foobase.csv base'
jd'droptable t'
jd'csvrd foobase.csv t'
assert (jd'reads from t')-:jd'reads from base'

NB. base val=6
jddeletefolder_jd_ CSVFOLDER
jd'csvwr /w foobase.csv base * val=6'
jd'droptable t'
jd'csvrd foobase.csv t'
assert (jd'reads from t')-:jd'reads from base where val=6'
jd'droptable t'

NB. f
jddeletefolder_jd_ CSVFOLDER
jd'csvwr foof.csv f'
jd'csvrd foof.csv t'
assert (jd'reads from t')-:jd'reads from f'
jd'droptable t'

NB. f val=6
jddeletefolder_jd_ CSVFOLDER
jd'csvwr /w foof.csv f * val=6'
jd'droptable t'
jd'csvrd foof.csv t'
assert (jd'reads from t')-:jd'reads from f where val=6'

NB. dump
ptablebld ptype
jddeletefolder_jd_ CSVFOLDER
jd'csvdump'
dbase=. jd'reads from base'
df=.    jd'reads from f'
dj=.    jd'reads from j'
sum=: jd'info summary'
sch=: jd'info schema'
jdadminx'test'
jd'csvrestore'
assert sum-:jd'info summary'
assert sch-:jd'info schema'
assert dbase-:jd'reads from base'
assert df   -:jd'reads from f'
assert dj   -:jd'reads from j'

NB. csvdump/restore /e option
jddeletefolder_jd_ CSVFOLDER
jd'csvdump /e'
jdadminx'test'
jd'csvrestore'
assert sum-:jd'info summary'
assert sch-:jd'info schema'
assert dbase-:jd'reads from base'
assert df   -:jd'reads from f'
assert dj   -:jd'reads from j'

NB. ref after ptable exists
jd'ref base p2 j p2'
jd'ref f p2 j p2'
assert ({:jd'reads from f,f.j')-:{:jd'reads from base,base.j'

NB. csvwr/rd /h1 option
jddeletefolder_jd_ CSVFOLDER
jd'csvwr /h1 gg.csv f'
jd'csvrd gg.csv gg'
assert (jd'reads from f')-:jd'reads from gg'

NB. combine partitions into single csv file
jddeletefolder_jd_ CSVFOLDER
ptablebld ptype
jd'csvwr /combine f.csv f'
jd'csvrd f.csv gg'
assert (jd'reads from f order by sort')-:jd'reads from gg order by sort'
jd'csvwr /h1 /combine gg.csv gg'
jd'csvrd gg.csv hh'
assert (jd'reads from f order by sort')-:jd'reads from hh order by sort'
