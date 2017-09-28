NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. table-from_array tutorial

NB. create a table from an array that is in reads /lr format

NB. get an array from sandp
jdadmin'sandp'
d=. ,jd'reads /lr sp.sid,sp.pid,sp.qty,s.city,p.city from sp,sp.s,sp.p where s.city=p.city'
d

NB. create new table in new db
jdadminx'test'
d=. jdfixcolnames_jd_ d NB. . to - etc to have valid col names
d
jd'createtable f';jdcdef_jd_ d
jd'insert f';d
jd'reads from f'
