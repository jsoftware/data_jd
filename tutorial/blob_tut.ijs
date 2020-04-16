0 : 0
preliminary support for blobs - subject to change!

blob - binary large object
a blob is stored as a file in the database folder structure
a blob can be stored at DB folder, table folder, or column folder
)

jdadmin 0
'new'jdadmin'test'
jd'createtable f'
jd'createcol f a int'

NB. blobs in the DB folder
jd'blobwrite name';'db data'
jd'blobwrite crudstuff';'db different data'
jd'blobread  name'
jd'blobread  crudstuff'
jd'bloberase name'
'failed'jdae'blobread  name'

NB. blobs in the table folder
jd'blobwrite f name';'table data'
jd'blobwrite f crudstuff';'table different data'
jd'blobread  f name'
jd'blobread  f crudstuff'

NB. blobs in the col folder
jd'blobwrite f a name';'col data'
jd'blobwrite f a crudstuff';'col different data'
jd'blobread  f a name'
jd'blobread  f a crudstuff'

jd'info blob'

0 : 0
use custom ops to connect a blob to a table row
see jd_myblobread_jd_ below
)

'new'jdadmin'test'
jd'createtable f'
jd'createcol f num int'
jd'createcol f name byte 5'
jd'insert f';'num';44 55 66;'name';3 5$'abc  de   fghi '
jd'read from f'

jd'blobwrite f abc';'this is the data for name abc'
jd'blobwrite f de';'dededede'
jd'blobwrite f fghi';'yet another blob'

jd_myblobread_jd_=: 3 : 0
a=. jdi_read'from f where num=',y
d=. 'name' jdfrom_jd_ a
'can only read on blob at a time'assert 1=#d
a,jd_blobread'f ',,d
)

jd'myblobread 44'
jd'myblobread 55'
jd'myblobread 55'
