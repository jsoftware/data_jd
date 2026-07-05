load JDP,'test/util/rep.ijs' NB. rep server tools

jdserver'rep';'delete' NB. clean slate
jdnode  'rep';'delete'

create_rep_db'' NB. create rep db

NB. replicate data is a tar of the starting db data
NB. and a wal (write ahead log) of all changes

repdata=:'~temp/jdreplicate/rep/' NB. folder for replicate tar and wal
mkdir_j_ repdata
tar=: repdata,'tar.gz.tar'
wal=: repdata,'wal'
ferase tar;wal

jdrepsrc_jd_ 'rep';tar;wal NB. mark rep db as replicate base

jdadmin'rep'
jd'insert t';'a';23
jd'insert t';'a';24
jd'read from t'
jd'xdelete'
jd'insert t';'a';66
jdadmin 0

fread wal
jdwalread_jd_ fread wal

get_state_val=: {{;{:(({."1 y) i. <x){y}}

NB. create clone0 as replicate of rep
clone0=: 'rep_clone_0' NB. rep db clone
jddeletefolder_jd_ adminp_jd_ clone0 NB. so we can create the db
jdrepsnk_jd_'rep';'~temp/jd' NB. create rep_clone_0

jdserver'rep';'delete'
jdserver'rep';'create';65220;'rep'
jdserver'rep';'start'
jdnode'rep';'delete'
jdnode'rep';'create';3000;'testup';'inspect-yes';NODE_TIME_jd_
jdnode'rep';'start'

NB. create_rep_db set URL and LOGON
rep=: URL jdclient
LOGON rep ''
rep'info summary'
rep'insert t';'a';567 NB. goes to base
rep'info summary'      NB. goes to clone

jdserver'rep';'delete'
jdnode'rep';'delete'

NB. create 2nd clone 

clone1=: 'rep_clone_1' NB. rep db clone
jddeletefolder_jd_ adminp_jd_ clone1 NB. so we can create the db
jdrepsnk_jd_'rep';'~temp/jd' NB. create rep_clone_1
jdgstate_jd_'rep'

jdserver'rep';'create';65220;'rep'
jdserver'rep';'start'

jdnode'rep';'create';3000;'testup';'inspect-yes';NODE_TIME_jd_
jdnode'rep';'start'

jdnode'';'status'

rep=: URL jdclient
'logon rep user0 pswd0'rep''
rep'info summary'
rep'insert t';'a';789
rep'info summary'
rep'read from t'
jdnode'rep';'report' NB. note ports used

'logon rep user0 pswd0;logoff'rep'list version'
jdnode'rep';'report' NB. on req off

'logon rep user0 pswd0'rep''

0 : 0
a replicate db requires non-trivial maintenance

walfile grows with every change and if it gets too large it should be cleared
 updates all the clones and sets their walindex=:0
 ferases tarfile and sets walfile to empty
perhaps tarfile and wallfile should be backed up before this is done

cluster_reset:
cluster_clear and create new tarfile
)
