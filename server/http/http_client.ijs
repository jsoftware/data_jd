NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm jbin/jbin client example
NB. mtm client - normal socket connection to mtm server ZMQ_STREAM socket

require'socket'
require'convert/pjson'

HTTP=: 0 : 0 rplc LF;CRLF
POST /fubar HTTP/1.1
Host: 127.0.0.1:65220
User-Agent: curl/7.47.0
Accept: */*
Content-Length: XX
Content-Type: application/x-www-form-urlencoded
)

reload=: 3 : 0
load JDP,'server/http/http_tools.ijs'
load JDP,'server/http/http_client.ijs'
)

3 : 0''
if. _1=nc<'S' do. PORT=: S=: _1 end.
)

jbinenc_z_=: 3 !: 1
jbindec_z_=: 3 !: 2
jsonenc_z_=: enc_pjson_
jsondec_z_=: dec_pjson_

close=: 3 : 'S=: _1[sdclose_jsocket_ S'

connect=: 3 : 0
close S
S=: >{:sdsocket_jsocket_''
rc=. sdconnect_jsocket_ S;AF_INET_jsocket_;'127.0.0.1';PORT
'connect failed' assert 0=rc
)

NB. jbin jbin version
NB. send http request and get response - must be connected and does not close
msr=: 3 : 0
CONTEXT msr y
:
'a b'=. 2{.;:x
if. 'json'-:a do. in=:  jsonenc else. in=:  jbinenc  end.
if. 'json'-:b do. out=: [       else. out=: jbindec end.
try.
 if. PORT=_1 do. config''  end.
 if. S=_1    do. connect'' end.
 if. L.y do. y=. CONTEXT,(;{.y),LF,in }.y else. y=. x,y end.
 snd_request (HTTP rplc'XX';":#y),CRLF,y
 out rcv_response''
catch.
 close''
 'failed'assert 0
end.
)

snd_request=: 3 : 0
while. #y do.
 'e c'=. y sdsend_jsocket_ S;0
 'send error' assert 0=e
 y=. c}.y
end.
)

rcv_response=: 3 : 0
data=. ''
while. 1 do.
 'e reads writes errors'=. sdselect_jsocket_ S;'';'';TIMEOUT
 'select error' assert 0=e
 'timeout' assert S e. reads
 D=: data=. data,;{:sdrecv_jsocket_ S,BUFSIZE,0
 r=. chk_response data
 if. -.0-:r do. break.  end.
end.
if. ({.a.)={.r do. connect'' end.
r
)

NB. return data if response is complete otherwise 0
chk_response=: 3 : 0
j=. (y E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
if. j<#y do. NB. have headers
 k=. 4+j
 h=. k{.y NB. headers
 j=. ('Content-Length:'E. h)i.1
 'header without content-length'assert j~:#h
 t=. (15+j)}.h
 c=. _1".(t i.CR){.t
 'bad content-length'assert _1-.@-:cl
 if. (k+c)=#y do. k}.y return. end.
end.
0
)

NB. version that breaks sends into parts with delays for testing
xxxsnd_request=: 3 : 0
while. #y do.
 d=. (50<.#y){.y
 'e c'=. d sdsend_jsocket_ S;0
 'send error' assert 0=e
 y=. c}.y
 6!:3[1
end.
)

NB. send bad http request and get response - must be connected and does not close
msrbad=: 3 : 0
if. PORT=_1 do. config''  end.
if. S=_1    do. connect'' end.
if. L.y do. y=. CONTEXT,(;{.y),';',jsonenc}.y else. y=. CONTEXT,y end.
bad=. HTTP rplc'POST';'POSx'
snd_request (bad rplc'XX';":#y),CRLF,y
out rcv_response''
)

NB. wget

NB. create post arg file for wget or curl
wcarg=: 3 : 0
c=. 'json json http u/p;'
if. L.y do. a=. c,(;{.y),LF,jsonenc }.y else. a=. c,y end.
a fwrite 'wget_post'
)

wget=: 3 : 0
wcarg y
spawn_jtask_ 'wget -O- -q http://127.0.0.1:65220/ --post-file wget_post > foo.txt'
fread'foo.txt'
)

curl=: 3 : 0
wcarg y
spawn_jtask_ 'curl -s http://127.0.0.1:65220/ --data @wget_post > foo.txt'
fread'foo.txt'
)


