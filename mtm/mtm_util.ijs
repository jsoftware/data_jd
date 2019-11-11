NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm server/client common routines

echo 0 : 0
man pages:
   jd_mtm_overview_jman_
   jd_mtm_usage_jman_
)   

NB. define n z perhaps not the best solution
enc_z_=: 3!:1
dec_z_=: 3!:2

streamframe=: 3 : 0
0 streamframe y
: 
t=. enc y
t,~'JdMTMfrm',(((8#256)#:HLEN+#t){a.),((8#256)#:x){a.
)

framelen=: 3 : 0
256#.a.i._8{.16{.y
)

getrid_z_=: 3 : 0
256#.a.i._8{.24{.y
)

0 : 0
frame header
'JdMTMfrm' - 8 chars
len        - 8 byte integer (see framelen)
rid        - request id - same format as framelen
)

HLEN=: 24 NB. bytes in  frame header

create_mtm_db=: 3 : 0
jdadminx'mtm'
jd'createtable /a 2 1 2 f'
jd'createcol f a int'
jd'createcol f b int'
d=. i.2
jd'insert f';'a';d;'b';d
jd'createtable /a 2 1 2 g'
jd'createcol g a int'
jd'createcol g b byte 2'
d=. i.2
jd'insert g';'a';d;'b';2 2$'abcd'
)

jd_mtm_overview_jman_=:  0 : 0
Jd multi task manager

CJ  - task  for jobs (request/response zmq_raw)
CW  - task  for write ops
CRS - tasks for read ops

CW init  - CRS tasks not started ; winit'' ; fails if refs or varbyte

CRS init - CW idle ; rinit''

CW run
 insert runs concurrently with CRS - info-summary is arg for CRS runs
 other ops - run only when CRS all idle and runs rinit in each CRS task
 
CRS run
 mtmfix info-summary
  remap files that have changed size
  tlen set in table locale and any mapped headers
 
todo:
varbyte not supported (server init fails) but it could work with more work
 dat is easy (just like normal cols) but val needs mtmfix support
 
refs not supported (server init fails)
 insert to left cols could be supported with some work
 insert to right col is more complicated and needs thought
)

jd_mtm_usage_jman_=: 0 : 0
1. create mtm DB
   start new j session
   load'~Jddev/jd.ijs'
   load'~Jddev/mtm/mtm_util.ijs'
   create_mtm_db''
   jd'info summary'
   jd'read from f'
   jd'read from g'
   jdadmin 0
   
2. start mtm server
   start new jconsole sessopm
   load'~Jddev/mtm/mtm.ijs'
   init config'' NB. run mtm
   
3. start mtm client (same machine as server for testing)
   start new jconsole session
   load'~Jddev/mtm/mtm_client.ijs'
   init''
   msr'info summary'           NB. runs in first available CRS task             
   msr'reads from f'           NB. runs in first available CRS task             
   msr'insert f';'a';12;'b';13 NB. runs in CW task - insert result to update CRS tasks
   msr'reads from f'           NB. tables updated for insert
   r=. msnd'reads from f'      NB. result is RID (request ID)
   mgetw r                     NB. get result for RID (wait if required) 
   test''                      NB. run series of ops
)
