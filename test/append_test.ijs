NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. tests for tableappend

load JDP_jd_,'demo/common.ijs'
builddemo'sandp'

jdadmin'sandp'
s1=. jd'read * from s where status < 20'
s2=. jd'read * from s where status < 30 and status >= 20'
s3=. jd'read * from s where status >= 30'
s=.  jd'read * from s order by sid'

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
jd etx'tableappend snkt srct foo'
assert 'invalid srcdb'-:;1{jdlast
assert t-:DB_jd_

jd etx'tableappend snkt srct snkdb'
assert 'srcdb same as snkdb'-:;1{jdlast

jd'tableappend snkt srct srcdb'

jd'tableappend snkt srct srcdb2'
assert s -: jd'read * from snkt order by sid'
