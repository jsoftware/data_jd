NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm client - ZMQ_STREAM

require'~Jddev/mtm/mtm_common.ijs'

ld=: 3 : 0
load'~Jddev/mtm/mtm_client.ijs'
load'~Jddev/mtm/mtm_common.ijs'
)

client_init=: 3 : 0
load'socket'
S=: >{:sdsocket_jsocket_''
sdconnect_jsocket_ S;AF_INET_jsocket_;'127.0.0.1';65220
RS=: ''
RID=: 1
)

msnd=: 3 : 0
t=. RID streamframe y
RID=: >:RID
r=. t sdsend_jsocket_ S;0
'send error' assert 0=>{.r
'send truncated' assert (#t)=>{:r
<:RID
)

mrcv=: 3 : 0
'e reads writes errors'=. sdselect_jsocket_ S;'';'';0
'select error' assert 0=e
'no data' assert S e. reads
RS=: RS,;{:sdrecv_jsocket_ S,10000 0
'need more data for header'assert HLEN<:#RS
dc=. framelen RS
'need more data for complete frame'assert dc<:#RS
rid=: getrid RS
j=. HLEN}.dc{.RS
RS=: dc}.RS
rid;<dec j
)

