NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm client - ZMQ_STREAM

require'socket'
require'~Jddev/mtm/mtm_util.ijs'

NB. force load - normal is require
ld=: 3 : 0
load'~Jddev/mtm/mtm_client.ijs'
load'~Jddev/mtm/mtm_util.ijs'
''
)

close=: 3 : 0
sdclose_jsocket_ S
)

init=: 3 : 0
sdclose_jsocket_ S
S=: >{:sdsocket_jsocket_''
sdconnect_jsocket_ S;AF_INET_jsocket_;'127.0.0.1';65220
RS=: ''
RID=: 1
rids=: ''
results=: ''
i.0 0
)

NB. send reqest, wait for result, return result
msr=: 3 : 'mgetw msnd y'

NB. send request
msnd=: 3 : 0
t=. RID streamframe y
RID=: >:RID
r=. t sdsend_jsocket_ S;0
'send error' assert 0=>{.r
'send truncated' assert (#t)=>{:r
<:RID
)

NB. recv result stream and update rids and results
NB. y - 0 for no timeout and n for timeout
mrcv=: 3 : 0
'e reads writes errors'=. sdselect_jsocket_ S;'';'';y
'mrcv select error' assert 0=e
'mrcv timeout' assert (0=y)+.S e. reads
if. -.S e. reads do. i.0 0 return. end.
RS=: RS,;{:sdrecv_jsocket_ S,10000 0
while. #RS do.
 if. HLEN>#RS do. i.0 0 break. end. NB. need more data for header
 dc=. framelen RS
 if. dc>#RS do. i.0 0 break. end.   NB. need more data for complete frame
 rid=: getrid RS
 j=. HLEN}.dc{.RS
 RS=: dc}.RS
 rids=: rids,rid
 results=: results,<dec j
end.
i.0 0
)

NB. get rid result
mget=: 3 : 0
'mget rid invalid' assert (y>0)*.y<RID
mrcv 0
'mget rid not available'assert y e. rids
mgx y
)

NB. get rid result (wait for it)
mgetw=: 3 : 0
'mget rid invalid' assert (y>0)*.y<RID
while. 1 do.
 if. y e. rids do. mgx y return. end.
 mrcv 20000
end.
)

mgx=: 3 : 0
r=. >(rids i. y){results
b=. y~:rids
rids=: b#rids
results=: b#results
r
)

