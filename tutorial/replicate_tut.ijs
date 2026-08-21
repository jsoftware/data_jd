load JDP,'test/util/rep.ijs' NB. rep server tools

r1_build'' NB. study defn
repdata NB. folder for replicate tarfile and walfile
dir repdata
tar
wal

0 : 0
rep is the base db
repdata folder has tar (copy of rep db) and wal (write ahead log of all rep db changes)
jdrepsrc sets rep db to refer to the tar and wal files
jdrepsnk creates new db that is a clone (built from tar and updated from wal)
when a clone db is accessed it is first updated from the wal file
)

NB. rep db has tar and wal files and two clone dbs
jdgstate_jd_'rep' NB. rep db state info

NB. rep_clone_0 db has tar and wal files and the update index in the wal file
jdgstate_jd_'rep_clone_0'

r1_run'' NB. NB. build and start r1 server - study defns
jdserver'r1 status'

r1'insert t';'a';6 NB. write op goes to base db and is added to wal
r1'insert t';'a';7 NB. write op goes to base db and is added to wal

fread wal
jdwalread_jd_ fread wal

'WALINDEX'jdfrom_jd_ jdgstate_jd_'rep_clone_0' NB. 0 is current end of wal
r1'read from t' NB. read op goes to clone db - which updates from wal
'WALINDEX'jdfrom_jd_ jdgstate_jd_'rep_clone_0' NB. index updated to end of wal

jdserver'r1 report node 15' NB. note inserts to port 65220 and read to port 65221
jdserver'r1 report base 5'
jdserver'r1 report clone_0 3' 

NB. many write ops would create many wal records to update
NB. and this could block another read op causing a timeout
NB. reptrigger (set by NODE_TIME_jd_) triggers over due clone repupdates
a=. 'WALINDEX'jdfrom_jd_ jdgstate_jd_'rep_clone_0'
r1 each 60#<'insert t';'a';8 NB. enough writes to trigger repupdate
6!:3[1 NB. time for repupdate to run before checking
'repupdate did not advance index'assert ('WALINDEX'jdfrom_jd_ jdgstate_jd_'rep_clone_0')>:a

0 : 0
a replicate db requires non-trivial maintenance

wal reset:
 walfile grows with every change and if it gets too large it should be cleared
 update all the clones and sets their walindex=:0
 set walfile to empty - back up first
 db backup is now tar and all wall files

db reset:
 create new tarfile
 walindex=: 0
 walfile empty
)
