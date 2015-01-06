NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. tests for read/reads/readtc options

a=: ><;._2 [0 : 0
2014-01-01Z
2015-01-01Z
)

e=: efs_jd_ a

jdadminx'test'
jd'createtable f'
jd'createcol f aa int _';i.2
jd'createcol f bb edate _';e NB. createcol does not handle iso 8601 format

NB. reads options
assert (2 2$('aa';'bb';(,.0 1);a))-:jd'reads from f'
assert (2 2$('aa';0 1;'bb';a))-:jd'reads /lr from f'
assert (2 2$('aa';'bb';(,.0 1);,.e))-:jd'reads /e from f'
assert (2 2$('aa';0 1;'bb';e))-:jd'reads /lr /e from f'

NB. read options
assert (2 2$('aa';0 1;'bb';a))-:jd'read from f'
assert (2 2$('aa';0 1;'bb';a))-:jd'read /lr from f' NB. /lr has no effect
assert (2 2$('aa';0 1;'bb';e))-:jd'read /e from f'
assert (2 2$('aa';0 1;'bb';e))-:jd'read /lr /e from f'

NB. readtc options

assert (2 2$'year';'aa';('2014',:'2015');,.0 1)-:jd'readtc :::f_year=: 4{."1 sfe_jd_ f_bb::: sum aa by year from f'
assert (2 2$'year';('2014',:'2015');'aa';0 1)-:jd'readtc /lr :::f_year=: 4{."1 sfe_jd_ f_bb::: sum aa by year from f'
