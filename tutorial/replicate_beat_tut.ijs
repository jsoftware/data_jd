load JDP,'test/util/rep.ijs' NB. rep server tools

create_rep_server'' NB. create rep server with rep base and 2 clones
rep'info summary'

0 : 0
beat starts n tasks that loop c times through a set of 1 or more ops
result is requests/second
   beat 4;100;'list version' NB. rps for 4 tasks each running 100 list ops
)

beat 4;100;'info summary'
beat 4;100;'' NB. calls node but does not call jd
beat 4;100;'read from t'
fread 'beat.txt' NB. detail results for each task
t=. ('insert t';'a';1234);'read from t';'info summary';'info schema'
beat 4;1000;<t NB. cycle through the ops

rep'delete t';'a>_1'
rep'read from t'
beat 8;1000;<'INSERT'
rep'read from t'
d=: ;{:{:rep'read from t'
cnts=: <.d%1000000 NB. pids
pids=: <.1000000|d
'8 tasks * 1000 inserts'assert 8000=#d
'8 tasks'assert 8=#~.pids
'each task did 1000 inserts with cnt'assert 8=+/"1 =cnts
'each cnt was done once by each task'assert 1=+/=cnts

NB. verify that base and clones are the same
b=. 'port 65220'rep'read from t'
'base does not match clone_0'assert b-:'port 65221'rep'read from t'
'base does not match clone_1'assert b-:'port 65221'rep'read from t'