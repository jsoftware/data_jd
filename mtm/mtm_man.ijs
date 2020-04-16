NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

0 : 0
man pages:
   jd_mtm_overview_jman_
   jd_mtm_demo_jman_
)

jd_mtm_overview_jman_=:  0 : 0
Jd multi task manager

CJ  - task  for jobs (request/response zmq_raw)
CW  - task  for write ops
CRS - tasks for read ops


SCJ  - socket jobs (request/response)
SCW  - socket for CW task
SCRn - socket(s) for CRS tasks

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

***

mtm server requests come in as http requests from mtm clients

Jd task verb jdserver handles http requests

mtm gets string args from http request (may include json/bin encoded array)
passes the request to the appropriate Jd task (read/insert/write)
and resturn json/jbin formated result

all encoding/decoding is done in mtm client or Jd task
mtm server does not do any encoding/decoding
)

jd_mtm_demo_jman_=: 0 : 0

start J as control task
   load jd (from git or ~addons)
   load JDP,'mtm/mtmx.ijs' NB. utils
   
   create_mtm_db'' NB. only need to do this the first time
    
   jconsole server NB. start server task
   jconsole client NB. start client task
   jconsole client NB. start second client task - optional
   
in client task(s)
   msr'info table'
   msr'info summary'
   msr'droptable f'
   msr'createtable f'
   msr'createcol f a int'
   msr'insert f';'a';2 3
   msr'read from f'
   msr'delete f';'jdindex>2'
   test''
   drive 10
   
   msr'mtm report'
   msr'mtm stop'   NB. stop serving request and flush job queues
   msr'mtm start'  NB. start serving again
   msr'mtm kill'   NB. kill tasks
   
wget/curl from control task
   wget'info summary'
   wget'read count a from f'
   wget 'update f;',jsonenc 'a=4444';'a';666
   
   curl'info schema'
)
