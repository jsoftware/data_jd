NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm server/client helpers

JDP_z_=: 3 : 0''
n=. '/addons/data/jd/'
d=. jpath each 4!:3''
d=. ;d{~(1 i.~;+./each(<n)E. each d)
d{.~(1 i.~n E.d)+#n
)

NB. server utils

ldserver=: 3 : 0
load JDP,'mtm/mtm.ijs'
)

config_server=: 3 : 0
NOLOG=: 0
DB=: '~temp/jd/mtm'
BASE=: 65220 NB. base port for mtm ports
NCRS=: 2     NB. numbers of CRS tasks (concurrent read tasks)
LOGFILE_z_=: DB,'/mtm_log.txt'
)

NB. client utils

ldclient=: 3 : 0
load JDP,'mtm/mtm_client.ijs'
load JDP,'mtm/demo/test.ijs'
)

NB. create initial db utils

NB. custom derive verb for testing mtm derived col
custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verb
derive_bfroma=: 3 : 0
2{."1 jd_get'g a'
RPAREN
)


NB. createmtmdb portbase;crscount
create_mtm_db=: 3 : 0
'new'jdadmin'mtm'
custom fappend jdpath_jd_'custom.ijs'
jdadmin 0
echo 'mtm db created with no tables'
echo 'custom.ijs set with derive_bfroma_ verb for derived col test'
echo 'ready to be used by mtm server'
)
