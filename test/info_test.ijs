NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

 0 : 0 NB. info commands
 agg                        - select aggregators
 hash      [table]
 last                       - cmd time space
 reference [table]
 schema    [table [column]]
 summary   [table]
 table
 varbyte   [table [column]]
)


jdadminx'test'
jd'gen test f 3'
jd'gen test gg 3'
jd'reference f x gg x'
jd'close' NB. ensure info works form locales and not mappings

f=: 3 : '#;{."1 {:jd ''info '',y'

assert 8=f'agg'
assert 2=f'hash'
assert 1=f'last'
assert 1=f'reference'

assert 16=f'schema'
assert 8=f'schema f'
assert 8=f'schema gg'
assert 1=f'schema f x'
assert 1=f'schema gg x'

assert 2=f'summary'
assert 2=f'table'
assert 2=f'varbyte'
