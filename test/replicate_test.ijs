NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. validate replicate

load JDP,'test/util/rep.ijs'
create_rep_server''

f0=. adminp_jd_'rep_clone_0'
f1=. adminp_jd_'rep_clone_1'

rep'createcol t b int'
rep'createcol t c int'
rep'insert t';'a';1;'b';1;'c';1
rep'insert t';'a';2;'b';2;'c';2
rep'insert t';'a';3;'b';3;'c';3
rep'delete t';'jdindex<3'

'clone_0 does not have col b'assert 0=ftype f0,'/t/b'
'port 65221'rep'read from t' NB. trigger clone_0 update
'clone_0 has col b'assert 2=ftype f0,'/t/b'

'clone_1 does not have col b'assert 0=ftype f1,'/t/b'
'port 65222'rep'read from t' NB. trigger clone_0 update
'clone_1 has col b'assert 2=ftype f1,'/t/b'

check''

rep'dropcol t b'
rep'dropcol t c'
rep'delete t';'a>0'
check''

rep'delete t';'a>_1'
rep'read from t'
beat 8;1000;<10 3 1#'INSERT';'xdelete';'info summary'
rep'read from t'
d=: ;{:{:rep'read from t'
cnts=: <.d%1000000 NB. pids
pids=: <.1000000|d
'bad cnts'assert 1=+/=cnts
'bad cnts'assert (#cnts)=+/+/"1=cnts
check''

beat 8;1000;<(<'info summary'),(<'delete t';'jdindex>0'),<'insert t';'a';10000$123
check''

checklog f0
checklog f1

