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

note: ~Jddev vs distributed to addons
note: mtmx.ijs - helpers

1. create mtm demo DB - only run once to create a new mtm db
   start new j session
   load'jd'
   load'~Jddev/mtm/mtmx.ijs'
   create_mtm_db''
   
2. start mtm server
   start new jconsole session
   load'~Jddev/mtm/mtmx.ijs'
   ldserver''
   init_server''
   
3. start mtm client
   start new jconsole session
   load'~Jddev/mtm/mtmx.ijs
   ldclient''
   client_config''
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
   
4. start another mtm client
   start new jconsole session
   load'~Jddev/mtm/mtmx.ijs
   ldclient''
   client_config''
   msr'info table'

   drive 10000
   
   in mtm client started in step 3 do:
   drive 10000

5. send http POST requests via browser or other client.

$ wget -O- -q http://127.0.0.1:65220/ --post-data 'json json;insert f;["a",[2,3,4,5,6,7,8,9]]'
{
"Jd OK":0
}

$ wget -O- -q http://127.0.0.1:65220/ --post-data 'json json;delete f;"jdindex>5"'
response body
{
"Jd OK":0
}

$ curl http://127.0.0.1:65220/ --data-raw 'json json;info summary'
response body
{
"table":["f","g"],
"rows":[[6],[4]]
}

$ wget -O- -q http://127.0.0.1:65220/ --post-data 'json json;read from f where jdindex<3'
response body
{
"a":[4,0,1]
}

)
