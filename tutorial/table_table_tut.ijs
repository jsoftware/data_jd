NB. table-table tutorial
NB. tableinsert - tablecopy - tablemove

bld=: 3 : 0
jdadmin 0
jdadminx'gdb'
jd'gen test ga 2'
jd'gen test gb 2'
jdadminx'fdb'
jd'gen test fa 3'
jd'gen test fb 3'
)

NB. tableinsert requires conformable tables - same col names/types
bld ''
jd'tableinsert fa ga gdb'
assert 0 1 1 0 1-:,>{:jd'reads boolean from fa'

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

NB. insert table from src db to table in current db
jdadmin 0
jdadminx'src'
jd'gen test b 2'
jdadminx'snk'
jd'gen test a 3'
jd'tableinsert a b src' NB. insert table b in src to table a
jd'reads from a'
