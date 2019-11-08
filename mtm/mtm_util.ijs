NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm server/client common routines

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

man_mtm_overview=:  0 : 0
Jd multi task manager

CJ  - task for request/response zmq_raw
CW  - task for write ops
CRS - tasks for read ops

w init
 R tasks all idle (not even started)
 winit''
 fails if refs or varbyte

R init
 W idle
 rinit''
 
W run
 insert runs concurrently with CRS - result sets info-summary as arg for new CRS runs
 other ops - run only when CRS all idle and runs rinit in each CRS task
 
R run
 mtmfix info-summary
  remap files that have changed size
  tlen set in table locale and any mapped headers
 
todo:
varbyte not supported (server init fails) but it could work with more work
 dat is easy (just like normal cols) but val needs mtmfix support
 
refs not supported (server init fails)
 insert to left cols could be supported with some work (insert should avoid marking dirty)
 insert to right col is more complicated and needs thought and work (probably needs to run W exclusive)
)


man_mtm_usage=: 0 : 0
1. create mtm DB
   start new j session
   load'~Jddev/jd.ijs'
   load'~Jddev/mtm/test.ijs'
   mtm_test_simple''
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
   msnd'reads from f'          NB. result if RId (request ID)
   mrcv''                      NB. last result
   msnd'info summary'
   msnd'info schema'
   mrcv''                      NB. last result
   rids                        NB. rids for results
   results                     NB. results in rids order
   get 2                       NB. result for rid 2
   test''                      NB. run series of ops
)
