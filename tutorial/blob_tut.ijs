0 : 0
blob - binary large object
a blob is stored as a file in the database folder structure
a blob can be stored at DB folder, table folder, or column folder
)

jdadmin 0
'new'jdadmin'test'
jd'createtable f'
jd'createcol f a int'

NB. blobs in the DB folder
jd'blobwrite name*db data'
jd'blobwrite crudstuff*db different data'
jd'blobread  name'
jd'blobread  crudstuff'
jd'bloberase name'
'failed'jdae'blobread  name'

NB. blobs in the table folder
jd'blobwrite f name*table data'
jd'blobwrite f crudstuff*table different data'
jd'blobread  f name'
jd'blobread  f crudstuff'

NB. blobs in the col folder
jd'blobwrite f a name*col data'
jd'blobwrite f a crudstuff*col different data'
jd'blobread  f a name'
jd'blobread  f a crudstuff'

jd'info blob'


