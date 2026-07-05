NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

load JDP,'test/util/beat.ijs'

NB. create base db 
create_rep_db=: 3 : 0
jdadmin 0
jdadminnew'rep'
(fread JDP,'test/util/custom.ijs') fwrite '~temp/jd/rep/custom.ijs'
jdloadcustom_jd_'' NB. load custom ops - xdelete, xrdspin, xwrspin
jd'createtable t'
jd'createcol t a int';i.3

NB. set admin.ijs - same admin for all
jdsetadmin'rep';'rep';'user0';'*' NB. simple dan user0 can do all ops
jdsetadmin'rep';'ro';'user0';'info read reads'

NB. add users to test_upfile with encrypted pswd
jdsetuser 'test_upfile';'admin';'funny'
jdsetuser 'test_upfile';'user0';'pswd0'

jdadmin 0

URL=: 'https://localhost:3000'
LOGON=: 'logon rep user0 pswd0'
i.0 0
)

NB. create rep servers for rep base and 2 clones
create_rep_server=: 3 : 0
jdserver'rep';'delete'
jdnode'rep';'delete'
create_rep_db''
repdata=:'~temp/jdreplicate/rep/' NB. folder for replicate tar and wal
mkdir_j_ repdata
tar=: repdata,'tar.gz.tar'
wal=: repdata,'wal'
ferase each tar;wal

jdrepsrc_jd_ 'rep';tar;wal NB. mark rep db as replicate base

clone0=: 'rep_clone_0' NB. rep db clone
jddeletefolder_jd_ adminp_jd_ clone0 NB. so we can create the db
jdrepsnk_jd_'rep';'~temp/jd' NB. create rep_clone_0

clone1=: 'rep_clone_1' NB. rep db clone
jddeletefolder_jd_ adminp_jd_ clone1 NB. so we can create the db
jdrepsnk_jd_'rep';'~temp/jd' NB. create rep_clone_0

jdserver'rep';'create';65220;'rep'
jdserver'rep';'start'

jdnode'rep';'create';3000;'testup';'inspect-yes';NODE_TIME_jd_
jdnode'rep';'start'
rep=: ''jdclient
'logon rep user0 pswd0'rep''
i.0 0
)

NB. check that base and clones are the same
check=: 3 : 0
p65220=: 'port 65220'rep'read from t'
p65221=: 'port 65221'rep'read from t'
p65222=: 'port 65222'rep'read from t'
if. (-.p65220-:p65221)+.-.p65220-:p65222 do.
 dbr 1
 'IMPORTANT: study this!'assert 0
end. 
b=. 'port 65220'rep'read from t'
'base does not match clone_0'assert b-:'port 65221'rep'read from t'
'base does not match clone_1'assert b-:'port 65222'rep'read from t'
)

NB. check that f0 and f1 have expected log.txt files
checklog=: 3 : 0
d=. <;.2 fread y,'/log.txt'
d=.  26}.each d NB. drop ts
d=.  (9+;d i:each '|'){.each d NB. replicate   |bad wal ...
'expected bad wal ... records'assert 1=#~.d
'unexpected bad wal ...'assert 'replicate   |bad wal '-:;;~.d
)

NB. * count - number of times to beat
NB. pound on rep to find race conditions or other problems
NB. create_rep_server''
reppound=: 3 : 0
'arg scalar'assert 1=#y
'arg range'assert (y>0)*.y<20
f0=. adminp_jd_'rep_clone_0'
f1=. adminp_jd_'rep_clone_1'

for. i.y do.
 rep'delete t';'a>0'
 beat 8;1000;<(<'info summary'),(<'delete t';'jdindex>0'),<'insert t';'a';10000$123
 check''
end.

checklog f0
checklog f1
)
