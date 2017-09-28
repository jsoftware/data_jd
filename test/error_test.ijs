NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. tests for expected errors
NB. in general other test scripts do not test for expected errors

jdadminx'test'
jd'createtable f a int,b int'

'duplicate'jdae'createtable f a int,a int'

'duplicate'jdae'insert f';'a';2;'b';3;'a';4;'b';5
'unknown' jdae'insert f qqq';23
'missing' jdae'insert f';'a';23

'duplicate'jdae'update f';'a=0';'a';2;'a';3
'unknown'  jdae'update f';'a=0';'qqq';23


NB. csv
CSVFOLDER=: F=: '~temp/jd/csv/junk/'
jdadminx'test'
jdcreatefolder_jd_ F[jddeletefolder_jd_ F
('2,3',LF)          fwrite F,'a.csv'
('abc',LF,'abc',LF) fwrite F,'a.cnames'
'not found'jdae'csvrd a.csv a'
'duplicate'jdae'csvcdefs /replace /h 0 /c a.csv'
