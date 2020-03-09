NB. Copyright 20209, Jsoftware Inc.  All rights reserved.
NB. create mtm demo DB

NB. custom derive verb for testing mtm derived col
custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verb
derive_bfroma=: 3 : 0
2{."1 jd_get'g a'
RPAREN
)

config=: 0 : 0
BASE=: 65220 NB. base port for mtm ports
NCRS=: 2     NB. numbers of CRS tasks (concurrent read tasks) 
)


NB. createmtmdb portbase;crscount
createmtmdb=: 3 : 0
'new'jdadmin'mtm'
config fappend jdpath_jd_'mtm_config.ijs'
'' fwrite jdpath_jd_'mtm_log.txt'
custom fappend jdpath_jd_'custom.ijs'
jdadmin 0
echo 'mtm db created with no tables'
echo 'custom.ijs set with derive_bfroma_ verb for derived col test'
echo 'ready to be used by mtm server'
)
