NB. custom.ijs contains db custom ops (ops specific to the db)
NB. custom ops are of the form jd_x...
NB. custom ops can call any jd_... op 
NB. custom ops must NOT call jd'...' - won't work with jjd server
NB. custom ops are usually patterned after jd_... ops

custom=: 0 : 0 rplc 'RPAREN';')'
jd_xra=: 3 : 0
ECOUNT assert 0=#y
jdi_read'cola from f'
RPAREN

jd_xins=: 3 : 0
ECOUNT assert 2=#y
'a b'=. y
jd_insert'f';'cola';a;'colb';b
RPAREN

jd_xsum=: 3 : 0
ECOUNT assert 0=#y
r=. jdi_read'cola,colb from f'
,:'xsum';+/>{:"1 r
RPAREN
)

jdadminx'test'                               NB. new admin, new db, no custom.ijs
custom fwrite '~temp/jd/test/custom.ijs'  NB. create custom.ijs
jdloadcustom_jd_'' NB. load changes
jd'createtable';'f';'cola int,colb int'
jd'insert';'f';'cola';23 24 25;'colb';33 34 35
jd'read from f'
jd'xins';55;66
jd'read from f'
jd'xra'
jd'xsum'
