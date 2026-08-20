NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
0 : 0
 agg                          - select aggregators
 last                         - cmd time space
 schema      [table [column]] - normal cols (non jd...)
 summary     [table]
 table
 validate    [table][column]]
 validatebad [table][column]]
 varbyte     [table [column]]
 ref         [table]          - ref cols
) 
 
jdadminx'test'
jd'gen test gg 3'
jd'gen test f 3'
jd'ref f x gg x'
jd'ref f boolean gg boolean'

f=: 3 : '#;{."1 {:r=:jd ''info '',y'

assert 8=f'agg'

assert 1=f'last'

assert 16=f'schema'
assert 8=f'schema gg'
assert 1=f'schema f float'

assert 2=f'summary'
assert 1=f'summary gg'

assert 2=f'table'

assert 20=f'validate'
assert 0=f'validatebad'

assert 2=f'varbyte'
assert 1=f'varbyte gg'
jd'close'
assert 2=f'varbyte'
assert 1=f'varbyte gg'

assert 2=f'ref'
jd'close'
assert 2=f'ref' NB. verify works without mapping

jd'dropcol f jdref_x_gg_x'
jd'dropcol f jdref_boolean_gg_boolean'

t=. jdgl_jd_'f'
assert 3=Tlen__t

jd'delete f';'jdindex=1'
assert 2=Tlen__t

jd'insert f';,jd'read from f'
assert 4=Tlen__t

jd'droptable /reset f'
t=. jdgl_jd_'f'
assert 0=Tlen__t

NB. ptable
require JDP,'tools/ptable.ijs'
ptablebld'int'
assert 3=f'summary'
assert 1=f'summary f'
assert ((,'f');,.27)={:jd'info summary f'
assert 2=ttally_jd_ {:jd'reads from f where p=2016 and p2=1'
jd'delete f';'p=2016 and p2=1'
assert ((,'f');,.25)={:jd'info summary f'
assert (}.{:jd'info schema ptab')-:}.{:jd'info schema f'
assert (}.{:jd'info schema f',PTM_jd_,'2016')-:}.{:jd'info schema f'
assert 0 6 3 1 2 5 10 4-:,;}.{:jd'info summary f',PTM_jd_,'*'
assert 3=f'table'
assert 8=f'table f',PTM_jd_,'*'
