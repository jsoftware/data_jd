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

NB. verify bad date is rejected
'bad epoch'jdae'insert f edt';'1700'
