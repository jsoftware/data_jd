NB. jddropstop - prevent drop of db/table/col

NB. admin can mark db/table/col so that drops fail
NB. dropstop can prevent inadvertant drops
NB. that might be difficult to recover from
NB. see jddropstop documentation

NB. [1] jddropstop writes empty jddroptstop files in the path
NB.  0  jddropstop erases all jddropstop files in the path

NB. jddropstop file prevents a drop of a db/table/col

de=: 'domain error'

jdadminx'test'
jd'createtable f a int,b int'
jd'createtable g a int,b int'

jddropstop_jd_'' NB. mark db, all tables, and all cols as dropstop
assert de-:jd etx 'dropdb'
assert de=:jd etx 'droptable f'
assert de=:jd etx 'dropcol f a'

0 jddropstop_jd_ 'f a' NB. allow drop of f a
jd'dropcol f a'
assert de=:jd etx 'dropcol f b' NB. f b still protected

0 jddropstop_jd_ 'f' NB. allow drop of f and all cols in f
jd'dropcol f b'
jd'droptable f'

0 jddropstop_jd_ '' NB. allow drop of db and all tables and all cols
jd'dropdb'
