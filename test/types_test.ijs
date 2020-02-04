NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

'new'jdadmin'test'
jd'gen types f 5'
a=. jd'reads from f'
assert 5=>{:{:jd'read count boolean from f'

CSVFOLDER=: '~temp/jd/csv'
jd'csvwr /h1 f.csv f'
jd'csvrd f.csv g'
b=. jd'reads from g'
assert a-:b
