
0 : 0
some dbs must always be available for quick updates
and slow queries would interfere

a solution is to replicate the src db in a snk db for queries

src db appends change ops to a log
snk db applies these to be a copy of the src db

overhead to append an op ro the log is small
and is fast compared to insert

log can be on a different drive and could be ssd

src and snk dbs are normally in different Jd tasks
and this makes good use of multiple cores

there could be more than 1 snk replicated from a src

this tutorial works with src and snk in the same task
and extra steps avoid conflicts with file handles
)

0 : 0
!!! csvrd, csvrestore, and table-table ops
!!! are NOT recorded in src db rlog folder
!!! and will NOT be reflected in the snk db
)

RLOG=: '~temp/jd/rlog' NB. folder to hold replicate info
jddeletefolder_jd_ jddeletefolderok_jd_ RLOG

jdadmin 0 NB. no locks
jdadminnew'src'
jdrepsrc_jd_ RLOG NB. mark db as replicate src and set rlog folder
jdrepinfo_jd_''
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';23
jd'reads from f'

jdadminnew'snk'
'replicate'jdadmae_jd_ jdrepsnk_jd_ etx RLOG NB. rlog in use by src - expected error

jdadmin 0 NB. no locks
jdadminnew'snk'
jdrepsnk_jd_ RLOG NB. connect rlog folder
jdrepinfo_jd_''
jd'reads from f' NB. updated from rlog before read

jdadmin 0 NB. no locks
jdadmin'src'
jd'insert f';'a';222 333
jd'reads from f'

jdadmin 0 NB. no locks and src rlog handles closed

jdadmin'snk'
jd'reads from f' NB. updated from rlog before read

'replicate' jdadmae_jd_ jdadmin etx 'src' NB. error as rlog is in use by snk db

jdadmin 0
jdadmin'src'
jd'createtable g'
jd'createcol g t int'
jd'insert g';'t';i.5
jd'delete f';'a=222'
jd'info summary'
jd'read from f'
jd'read from g'

jdadmin 0
jdadmin'snk'
jd'info summary'
jd'info summary'
jd'read from f'
jd'read from g'

0 : 0
src db can exist before snk repsrc is run
repsrc copies src db files to the rlog folder
and they are used to init the snk db when it does repsnk
)

jdadmin 0
jdadminnew'src'
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';i.3
jd'createtable g'
jd'createcol g t int'
jd'insert g';'t';23
jddeletefolderok_jd_ RLOG NB. so that repsrc can delete it
jdrepsrc_jd_ RLOG   NB. current db is copied to rlog folder
jd'insert g';'t';777 NB. recorded as new op in rlog folder
jd'renamecol g t tt'
jd'renametable g h'
jd'createtable p'
jd'createcol p a int'
jd'createcol p b int'
jd'insert p';'a';23;'b';24
jd'dropcol p a'
jd'createtable k'
jd'createcol k a int'
jd'insert k';'a';123
jd'droptable k'
jd'createtable i'
jd'createcol i a int'
jd'insert i';'a';i.4
jd'intx i a int1'
a=. jd'info schema'
b=. jd'info summary'

jdadmin 0 
jdadminnew'snk'
jdrepsnk_jd_ RLOG
jd'info summary'
assert a-:jd'info schema'
assert b-:jd'info summary'

jd'droptable f' NB. trigger later error

jdadmin 0
jdadmin'src'
jd'insert f';'a';777
b=. jd'info summary'

jdadmin 0
jdadmin 'snk'
'damaged'jdae'reads from a' NB. damaged - rep update insert to table that was droped

jdlogijfshow_jd_ '' NB. logijf info
jdlogijfshow_jd_ 0  NB. logijf info from record 0

0 : 0
the above shows the problem was in replicate update
xtra shows that update command that failed was an insert
and RLOGINDEX is the position of the failing update in the rlog file
)

NB. you can drop the damaged snk database and recreate from the src db
jdadminnew'snk'   NB. get rid of the damaged database
jdrepsnk_jd_ RLOG NB. recreate from src
jd'info summary'
assert a-:jd'info schema'
assert b-:jd'info summary'

jdrepkill_jd_'' NB. no more replication
jdrepinfo_jd_''

jdadmin'src'
jdrepkill_jd_'' NB. no more replication

NB. hard to know when the RLOG folder is no longer necessary
NB. it has been marked with jddropstop for protection

'dropstop' jdadmae_jd_ jddeletefolder_jd_ etx RLOG NB. dropstop

jddeletefolderok_jd_ RLOG NB. mark it as ok for delete
jddeletefolder_jd_ RLOG

NB. see JDP,'pm/replicate.ijs' for examples with 2 tasks
