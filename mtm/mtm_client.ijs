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
ridrcv=: ridsnd=: ''
i.0 0
)

msnd=: 3 : 0
if. 'delay'-:(y i.' '){.y do. _1[6!:3[1{0".y return. end. 
t=. RID streamframe y
ridsnd=: ridsnd,RID
RID=: >:RID
r=. t sdsend_jsocket_ S;0
'send error' assert 0=>{.r
'send truncated' assert (#t)=>{:r
<:RID
)

NB. result is last result
mrcv=: 3 : 0
'e reads writes errors'=. sdselect_jsocket_ S;'';'';1000
'select error' assert 0=e
'no new data' assert S e. reads
RS=: RS,;{:sdrecv_jsocket_ S,10000 0
while. #RS do.
 if. HLEN>#RS do.
  echo 'need more data for header'
  break.
 end. 
 dc=. framelen RS
 if. dc>#RS do.
  echo 'need more data for complete frame'
  break.
 end.
 rid=: getrid RS
 ridrcv=: ridrcv,rid
 j=. HLEN}.dc{.RS
 RS=: dc}.RS
 rids=: rids,rid
 results=: results,<dec j
end.
>{:results
)

msr=: 3 : 0
msnd y
'e reads writes errors'=. sdselect_jsocket_ S;'';'';20000
mrcv''
)

get=: 3 : 0
'invalid rid'assert y e. rids
>results{~rids i. y
)

test=: 3 : 0
init''

t=.;{:msr'info table'
for_a. t do. msr'droptable ',a end.

msr'createtable f'
msr'createcol f a int'
msr'insert f';'a';i.5
assert (i.5)-:>{:{:msr'read from f'
msr'delete f';'jdindex < 3'
assert 3 4-:>{:{:msr'read from f'
msr'delete f';'jdindex ge 0'
assert (,:'')-:>{:"1 msr'read from f'
msr'insert f';'a';i.3
assert (,:i.3)-:>{:"1 msr'read from f'
msr'update f';'a=1';'a';23
assert (,:0 23 2)-:>{:"1 msr'read from f'
msr'createtable g'
assert'fg'-:,>{:msr'info table'
msr'droptable g'
assert(,'f')-:,>{:msr'info table'
'snd/rcv mismatch' assert ridsnd-:ridrcv NB. these should be in order

a=. 10 10 10 2 #i.4
a=. a{~(#a)?#a
d=: 0
msnd each ".each a{jobs
msnd'droptable done'
6!:3[2
mrcv''
'snd/rcv mismatch' assert ridsnd-:/:~ridrcv NB. the new ones will be out of order
)
