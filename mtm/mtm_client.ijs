NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm client - normal socket connection to mtm server ZMQ_STREAM socket

NB. following code needs to be implemented on a per thread basis for the mtm server side

close=: 3 : 'sdclose_jsocket_ S'

init=: 3 : 0
P=: y
close S
S=: >{:sdsocket_jsocket_''
sdconnect_jsocket_ S;AF_INET_jsocket_;'127.0.0.1';P
RS=: ''
RID=: 1
rids=: ''
results=: ''
i.0 0
)

NB. [timeout] msr 'Jd op...'
msr=: 3 : 0
5000 msr y
:
try.
 t=. RID streamframe y
 RID=: >:RID
 r=. t sdsend_jsocket_ S;0
 'send error' assert 0=>{.r
 'send truncated' assert (#t)=>{:r
 <:RID
 r=. ''
 while. 1 do.
  'e reads writes errors'=. sdselect_jsocket_ S;'';'';x
  'mrcv select error' assert 0=e
  'mrcv timeout' assert S e. reads
  r=. r,;{:sdrecv_jsocket_ S,10000 0
  if. HLEN>#r do. continue. break. end. NB. need more data for header
  dc=. framelen r
  if. dc>#r do. continue. end.   NB. need more data for complete frame
  'bad recv count'assert dc=#r
  rid=: getrid r
  mtmdec HLEN}.r
  break.
 end.
catch.
 close S NB. notify server so it can reset
 'failure in send/recv - init required'assert 0
end.
)

msrjson=: 3 : 0
msr'json ',enc_pjson_ y
)