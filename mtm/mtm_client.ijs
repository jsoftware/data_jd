NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm client - normal socket connection to mtm server ZMQ_STREAM socket

NB. following code needs to be implemented on a per thread basis for the mtm server side

require'socket'
require'convert/pjson'

jbinenc_z_=: 3 !: 1
jbindec_z_=: 3 !: 2
jsonenc_z_=: enc_pjson_
jsondec_z_=: dec_pjson_

close=: 3 : 'sdclose_jsocket_ S'

connect=: 3 : 0
close S
S=: >{:sdsocket_jsocket_''
sdconnect_jsocket_ S;AF_INET_jsocket_;'127.0.0.1';PORT
)

http=: 0 : 0 rplc LF;CRLF
POST /fubar HTTP/1.1
Host: 127.0.0.1:65220
User-Agent: curl/7.47.0
Accept: */*
Content-Length: XX
Content-Type: application/x-www-form-urlencoded
)

client_config=: 3 : 0
PORT=: 65220
TIMEOUT=: 5000
CONTEXT=: 'json json;'
PORT;TIMEOUT;CONTEXT
)

msr=: 3 : 0
if. L.y do. y=. CONTEXT,(;{.y),';',jsonenc}.y else. y=. CONTEXT,y end.

 connect''
 t=. http 
 t=. t,CRLF,y NB. already have 1 CRLF
 t=. t rplc 'XX';":#y
 r=. t sdsend_jsocket_ S;0
 'send error' assert 0=>{.r
 'send truncated' assert (#t)=>{:r
 data=. get_response''
 close S NB. notify server so it can reset
 data
)

get_response=: 3 : 0
data=. ''
hi=. _1
while. 1 do.
 'e reads writes errors'=. sdselect_jsocket_ S;'';'';TIMEOUT NB. timeout
 'mrcv select error' assert 0=e
 'mrcv timeout' assert S e. reads
 data=. data,;{:sdrecv_jsocket_ S,10000 0
 if. _1=hi do. NB. get headers
  j=. (data E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
  if. j<#data do. NB. have headers
   hi=. j=. 4+j
   h=. j{.data NB. headers
   j=. ('Content-Length:'E. h)i.1
   if. j=#h do. j=. ('Content-length:'E. h)i.1 end.
   if. j<#h do.
    t=. (15+j)}.h
    t=. (t i.CR){.t
    cl=. _1".t
    assert _1~:cl
   end.
  end.
 end.
 if. (hi+cl)=#data do. break. end.
end.
hi}.data
)


msrjson=: 3 : 0
if. L.y do.
 msr CONTEXT,(;{.y),';',jsonenc}.y
else.
 msr CONTEXT,y
end.
)
