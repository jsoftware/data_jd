NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. custom.ijs contains db custom ops (ops specific to the db)
NB. custom ops are of the form jd_x...
NB. custom ops can call any jd_... op 
NB. custom ops must NOI call jd'...' - won't work with jjd server
NB. custom ops are usually patterned after jd_... ops

custom=: 0 : 0 rplc 'RPAREN';')'
jd_xra=: 3 : 0
ECOUNT assert 0=#y
jd_read'cola from f'
RPAREN

jd_xins=: 3 : 0
ECOUNT assert 2=#y
'a b'=. y
jd_insert'f';'cola';a;'colb';b
RPAREN

jd_xsum=: 3 : 0
ECOUNT assert 0=#y
r=. jd_read'cola,colb from f'
,:'xsum';+/>{:"1 r
)

jdadminx'test'                               NB. new admin, new db, no custom.ijs
EMPTY[custom fwrite '~temp/jd/test/custom.ijs'  NB. create custom.ijs
NB. custom.ijs loaded when db opened - explicit load now as db was already open
jd'loadcustom'                                  NB. load new custom.ijs
jd'createtable';'f';'cola int,colb int'
jd'insert';'f';'cola';23 24 25;'colb';33 34 35
jd'read from f'
jd'xins';55;66
jd'xra'
jd'xsum'


