NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
0 : 0
 agg                          - select aggregators
 dynamic     [table [column]] - dynamic cols
 jd          [table [column]] - jd... cols
 last                         - cmd time space
 schema      [table [column]] - normal cols (non jd...)
 summary     [table]
 table
 validate    [table][column]]
 validatebad [table][column]]
 varbyte     [table [column]]
 hash        [table]          - hash cols
 ref         [table]          - ref cols
 reference   [table]          - reference cols
 unique      [table]          - unique cols
) 
 
jdadminx'test'
jd'gen test gg 3'
jd'gen test f 3'
jd'reference f x gg x'
jd'ref f boolean gg boolean'
jd'createunique f int'

f=: 3 : '#;{."1 {:r=:jd ''info '',y'

assert 8=f'agg'

assert 5=f'dynamic'
assert 1=f'dynamic gg'

assert 9=f'jd'
assert 3=f'jd gg'

assert 1=f'last'

assert 16=f'schema'
assert 8=f'schema gg'
assert 1=f'schema f float'

assert 2=f'summary'
assert 1=f'summary gg'

assert 2=f'table'

assert 28=f'validate'
assert 0=f'validatebad'

assert 2=f'varbyte'
assert 1=f'varbyte gg'

assert 2=f'hash'
assert 1=f'hash f'

assert 1=f'ref'

assert 1=f'reference'

assert 1=f'unique'

jd'dropdynamic reference f x gg x'
jd'dropdynamic ref f boolean gg boolean'
jd'dropdynamic unique f int' 

NB. test S_deleted
t=. jdgl_jd_'f'
assert 3=Tlen__t
assert 0=S_deleted__t

jd'delete f';'jdindex=1'
assert 3=Tlen__t
assert 1=S_deleted__t

jd'insert f';,jd'read from f'
assert 5=Tlen__t
assert 1=S_deleted__t

jd'droptable /reset f'
t=. jdgl_jd_'f'
assert 0=Tlen__t
assert 0=S_deleted__t

NB. ptable
load JDP,'gen/ptable.ijs'
ptablebld'int'
assert 3=f'summary'
assert 1=f'summary f'
assert ((,'f');27;0)={:jd'info summary f'
assert 2=ttally_jd_ {:jd'reads from f where p=2016 and p2=1'
jd'delete f';'p=2016 and p2=1'
assert ((,'f');25;2)={:jd'info summary f'
assert (}.{:jd'info schema base')-:}.{:jd'info schema f'
assert (}.{:jd'info schema f',PTM_jd_,'2016')-:}.{:jd'info schema f'
assert 0 6 3 1 2 5 10 4 0 0 0 0 0 0 0 2-:,;}.{:jd'info summary f',PTM_jd_,'*'
assert 3=f'table'
assert 8=f'table f',PTM_jd_,'*'
