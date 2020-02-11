NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. verify extra precision is dropped
jdadminx'test'
jd'createtable f'
jd'createcol f edt edatetime'
jd'insert f edt';'2014-09-10T00:00:00,000000000'
jd'insert f edt';'2014-09-10T01:01:01,000000000'
jd'insert f edt';'2014-09-10T01:01:01,123400000'
jd'insert f edt';'2014-09-10T01:01:01,123456789'
jd'reads from f'
assert ( ;{:{:jd'read /e from f')-:463622400000000000 463626061000000000 463626061000000000 463626061000000000

jdadminx'test'
jd'createtable f'
jd'createcol f e edate'
jd'insert f e';'2000'
jd'insert f e';'2000'
jd'reads from f'
jd'insert f e';0
jd'insert f e';'1700'   NB. bad allowed from sfe
jd'insert f e';IMIN_jd_ NB. bad allowed

NB. bad allowed in csv
CSVFOLDER=: '~temp/jd/csv'
jd'csvwr f.csv f'
jd'csvrd f.csv g'
