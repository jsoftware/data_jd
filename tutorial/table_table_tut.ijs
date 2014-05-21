NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. table-table tutorial
NB. tableappend (insert and append) - tablecopy - tablemove

bld=: 3 : 0
jdadmin 0
jdadminx'gdb'
jd'gen test ga 2'
jd'gen test gb 2'
jdadminx'fdb'
jd'gen test fa 3'
jd'gen test fb 3'
)

NB. tableappend/tableinsert require conformable tables - same col names/types
NB. tableappend is fast but requires no dynmaic cols to update
NB. insertable is slow and requires dynamic cols to updata

NB. multiple large tables and large amounts of new data 
NB. can probably be updated faster and more conveniently with:
NB.  dropdynamic, tableappends, rebuild dynamic

bld ''
NB. tableappend is fast but requires no dynamic cols in the snktable
jd'tableappend fa ga gdb'
assert 0 1 1 0 1-:,>{:jd'reads boolean from fa'

NB. deleted rows in the src table are appended and deleted status is also appended
bld''
jdaccess'gdb'
jd'delete';'ga';'int=100'
jdaccess'fdb'
jd'tableappend fa ga gdb'
assert 0 1 1 1-:,>{:jd'reads boolean from fa'


NB. tableinsert can be much slower - updates dynamics and doesn't copy deleted
bld''
jd'reference fa int fb int' NB. create dynamic cols
jd'tableinsert fa ga gdb'
assert 0 1 1 0 1-:,>{:jd'reads boolean from fa'

NB. tableappend fails if there are dynamic cols
jd etx'tableappend fa ga gdb'
assert 'dynamic dependencies - use tableinsert or dropdynamic+dynamic'-:;1{jdlast

bld''
jd'tablecopy new ga gdb'
jd'tablecopy again ga gdb' NB. show that table ga is still in gdb ((just copied)
jd'tablemove moved ga gdb'
jd etx 'tablecopy nope ga gdb'
assert 'invalid srcdb'-:,;1{jdlast
t=. jd'reads from new'
assert t-:jd'reads from again'
assert t-:jd'reads from moved'

NB. move table from src db to new table current db 
jdadmin 0
jdadminx'src'
jd'gen test b 2'
jdadminx'snk'
jd'gen test a 3'
jd'tablemove new b src' NB. move table b in db src to db snk
jd'reads from a'
jd'reads from new'
jdadmin'src'
jd etx'reads from b' NB. assertion failure - table doesn't exist (it was moved)

NB. copy table from src db to new table current db
jdadmin 0
jdadminx'src'
jd'gen test b 2'
jdadminx'snk'
jd'gen test a 3'
jd'tablecopy new b src' NB. move table b in db src to db snk
jd'reads from a'
jd'reads from new'
jdadmin'src'
jd'reads from b'

NB. append table from src db to table in current db
jdadmin 0
jdadminx'src'
jd'gen test b 2'
jdadminx'snk'
jd'gen test a 3'
jd'tableappend a b src' NB. append table b in src to table a
jd'reads from a'
