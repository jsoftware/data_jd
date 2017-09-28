NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. tests for tableinsert

jdadmin'sandp'
s1=. jd'read * from s where status < 20'
s2=. jd'read * from s where status < 30 and status >= 20'
s3=. jd'read * from s where status >= 30'
s=.  jd'read * from s order by sid'
s=. s /:{."1 s

COLDEFS=. 'city byte 10';'sid byte 3';'sname byte 10';'status int'

jdadmin 0

jdadminx'snkdb'
jd'createtable';'snkt';COLDEFS
jd'insert';'snkt';,s1

jdadminx'srcdb'
jd'createtable';'srct';COLDEFS
jd'insert';'srct';,s2

jdadminx'~temp/jd/deeperdir/srcdb2'
jd'createtable';'srct';COLDEFS
jd'insert';'srct';,s3

jdaccess'snkdb'

t=. DB_jd_
'invalid srcdb'jdae'tableinsert snkt srct foo'
assert t-:DB_jd_

'invalid srcdb'jdae'tableinsert snkt srct snkdb'

jd'tableinsert snkt srct srcdb'

jd'tableinsert snkt srct srcdb2'
z=. jd'read * from snkt order by sid'
z=. s /:{."1 z
assert s-:z

jdadminx'a'
jd'gen ref2 f 4 0 g 2'
jdadminx'b'
jd'gen ref2 j 4 0 k 2'

c=. jdgl_jd_'j jdref_aref_k_bref'
assert 1=dirty__c
jd'reads from j,j.k'
assert 0=dirty__c

assert 4='count'jdfroms_jd_ jd'reads count:count akey from j'
jd'tableinsert j f a'
assert 8='count'jdfroms_jd_ jd'reads count:count akey from j'

c=. jdgl_jd_'j jdref_aref_k_bref'
assert 1=dirty__c
assert 8='count'jdfroms_jd_ jd'reads count:k.bref from j,j.k'
assert 0=dirty__c

NB. test map as required
jdadminx'testf'
jd'gen test f 3'
jdadminx'testg'
jd'gen test g 3'
jd'close'
jd'tableinsert g f testf'
assert 0 1 2 0 1 2-:,;{:jd'reads x from g'
