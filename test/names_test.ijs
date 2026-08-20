NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB.test db, dan, table, col name validation

'new'jdadmin'jdtest' NB. jd prefix allowed in DB
e=. 'invalid name'

e jdae'createtable a/b'
e jdae'createtable ab',1{a.
e jdae'createtable "ab"'
e jdae'createtable "a b"'
e jdae'createtable from'
e jdae'createtable jdfoo'

jd'createtable f'
e jdae'createcol f jdfoo int'
e jdae'createcol f foo',(0{a.),' int'
