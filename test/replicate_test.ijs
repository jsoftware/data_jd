NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
load JDP,'test/util/rep.ijs'
r1_run''

f0=. adminp_jd_'rep_clone_0'
f1=. adminp_jd_'rep_clone_1'

r1'createcol t b int'
r1'createcol t c int'
r1'insert t';'a';1;'b';1;'c';1
r1'insert t';'a';2;'b';2;'c';2
r1'insert t';'a';3;'b';3;'c';3
r1'delete t';'jdindex<3'
r1'each';(<'insert t';'a';7;'b';8;'c';9) NB. each is a write op and is in rlog

'clone_0 does not have col b'assert 0=ftype f0,'/t/b'
'port 65221'r1'read from t' NB. trigger clone_0 update
'clone_0 has col b'assert 2=ftype f0,'/t/b'

'clone_1 does not have col b'assert 0=ftype f1,'/t/b'
'port 65222'r1'read from t' NB. trigger clone_0 update
'clone_1 has col b'assert 2=ftype f1,'/t/b'

r1_check''

r1'dropcol t b'
r1'dropcol t c'
r1'delete t';'a>0'
r1_check''

r1'delete t';'a>_1'
r1'read from t'
beat 8;1000;<10 3 1#'INSERT';'xdelete';'info summary'
r1'read from t'
d=: ;{:{:r1'read from t'
cnts=: <.d%1000000 NB. pids
pids=: <.1000000|d
'bad cnts'assert 1=+/=cnts
'bad cnts'assert (#cnts)=+/+/"1=cnts
r1_check''

r1_reppound 1 NB. torn wal records

