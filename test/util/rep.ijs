NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

load JDP,'test/util/beat.ijs'

NB. config for r1 server
NB. jd task port 65220 for db rep
NB. jd task port 65221 for db rep_clone_0
NB. jd task port 65222 for db rep_clone_1
NB. node task port 3000 with parameters
r1_config=: 65220;'rep';3000;'testup';'inspect-yes';NODE_TIME_jd_

NB. create base db 
r1_build=: 3 : 0
killport_jport_ 3000 65220 65221 65222 NB. clean start is good - required in windows
jdadmin 0
jdadminnew'rep'
jdloadcustom_jd_ fread JDP,'test/util/custom.ijs' NB. set and load custom ops - xdelete, xrdspin, xwrspin
jd'createtable t'
jd'createcol t a int';i.3

NB. set admin.ijs - same admin for all
jdsetadmin'rep';'rep';'user0';'*' NB. simple dan user0 can do all ops
jdsetadmin'rep';'ro';'user0';'info read reads'

NB. replicate data is a tar of the initial base db
NB. and a wal (write ahead log) of all changes
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

jdadmin 0
i.0 0
)

NB. create rep servers for rep base and 2 clones
r1_server=: 3 : 0
killport_jport_ 3000 65220 65221 65222 NB. ok testing - be careful in production

NB. add users to test_upfile with encrypted pswd
jdsetuser 'test_upfile';'admin';'funny'
jdsetuser 'test_upfile';'user0';'pswd0'

jdserver'r1 delete'
jdserver'r1 create';r1_config
)

r1_req=: 3 : 0
URL=: 'https://127.0.0.1:3000'
LOGON=: 'logon rep user0 pswd0'
r1=: ''jdclient
'logon rep user0 pswd0'r1''
)

r1_run=: {{
r1_build''
r1_server''
jdserver'r1 start'
r1_req''
}}

NB. check that base and clones are the same
r1_check=: 3 : 0
p65220=: 'port 65220'r1'read from t'
p65221=: 'port 65221'r1'read from t'
p65222=: 'port 65222'r1'read from t'
if. (-.p65220-:p65221)+.-.p65220-:p65222 do.
 dbr 1
 'IMPORTANT: study this!'assert 0
end. 
)

NB. check that f0 and f1 have expected log.txt files
r1_checklog=: 3 : 0
d=. <;.2 fread y,'/log.txt'
d=.  26}.each d NB. drop ts
d=.  (9+;d i:each '|'){.each d NB. replicate   |bad wal ...
d=. ~.d
'expected bad wal ... records'assert 1=#d
'unexpected bad wal ...'assert 'replicate   |bad wal '-:;;d
)

NB. * count - number of times to beat
NB. pound on rep to find race conditions or other problems
r1_reppound=: 3 : 0
'arg scalar'assert 1=#y
'arg range'assert (y>0)*.y<20

r1_run''

f0=. adminp_jd_'rep_clone_0'
f1=. adminp_jd_'rep_clone_1'

for. i.y do.
 r1'delete t';'a>0'
 beat 8;1000;<(<'info summary'),(<'delete t';'jdindex>0'),<'insert t';'a';10000$123
 r1_check''
end.

r1_checklog f0
r1_checklog f1
)
