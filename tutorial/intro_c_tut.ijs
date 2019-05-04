NB. admin/create/drop
jdadminnew'test' NB. create new db (~temp/jd/test)
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';i.3
jd'reads /lr from f' NB. reads with /lr labeled row option
jdadmin 0 NB. db unavailable
''jdae'read from f'

NB. you could exit J, shutdown, and relax
NB. then start it all up and access the db

jdadmin'test' NB. admin for db test that must already exist
jd'read from f'
jdadminnew'fubar' NB. create new db (~temp/jd/fubar)
jd'createtable /pairs f';'b';'zxcv';'c';i.4
jd'read from f'
jdadmin'test' NB. access test again
jd'read from f'
jdadmin'fubar'
jd'read from f'
jd'dropcol f c'
jd'read from f'
jd'info table'
jd'droptable f'
jd'info table'
jd'dropdb'
jdadmin'test'
jd'reads from f'
jdadmin etx 'fubar' NB. error as it does not exist
13!:12''
jdadmin 0 NB. remove all admin - no db available
