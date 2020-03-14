NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

echo 0 : 0
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

)

jd_mtm_demo_jman_=: 0 : 0
1. create mtm demo DB - only run once to create a new mtm db
   start new j session
   load'jd'
   load'~Jddev/mtm/demo/createmtmdb.ijs'
   createmtmdb''
   
2. start mtm server
   start new jconsole session
   load'~Jddev/mtm/mtm.ijs'
   init '~temp/jd/mtm'

   
3. start mtm client
   start new jconsole session
   load'~Jddev/mtm/mtm_client.ijs'
   init 65220 NB. port reported by mtm server
   msr'info summary'
   msr'json info summary'
   msr'read from f'
   msr'json read from f'
   msr'insert f';'a';23
   msr'json ',enc_pjson_'insert f';'a';123
   msr'json info nope'
   
   load'~addons/mtm/demo/test.ijs'
   test''
   drive 10
   
 4. start another mtm client
    start new jconsole session
    load'~Jddev/mtm/mtm_client.ijs'
    init 65220 NB. port reported by mtm server
    msr'info summary'
   
    in mtm client started in step 3 do:
    drive 10000 NB. keep busy with request
   
    msr'info schema'

 5. start mtm server as a web server
   start new jconsole session (shutdown previous mtm server if necessary)
   HTTPSVR_jcs_=: 1 [ load'mtm/mtm.ijs mtm/mtm_util.ijs'
   init '~temp/jd/mtm'

  send http POST requests via browser or other client.

$ curl http://127.0.0.1:65220/ --data-raw 'json "info summary"'
response body
{
"table":["f","g"],
"rows":[[45003],[4]]
}

$ wget -O- -q http://127.0.0.1:65220/ --post-data 'json "read from f where jdindex<5"'
response body
{
"a":[0,23,2,0,1]
}

)
