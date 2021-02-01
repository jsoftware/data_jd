NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. post request is built from: host port fin fout dan u/p ; string LF boxed

require'socket'
require'convert/pjson'

NB. JDP_z_ set as path to JD if not already set
3 : 0''
if. 0=nc<'JDP' do. return. end.
n=. '/addons/data/jd/'
d=. jpath each 4!:3''
d=. ;d{~(1 i.~;+./each(<n)E. each d)
JDP_z_=: d{.~(1 i.~n E.d)+#n
)

load JDP,'server/port.ijs'

3 : 0''
if. _1=nc<'S' do. PORT=: S=: _1 end.
)

NB. 'localhost';65220;'jbin';'jbin';'a';'u/p' 
jds_client_config=: 3 : 0
'HOST PORT FIN FOUT DAN UP'=: y
SPORT=: ":PORT
TIMEOUT=: 20000
BUFSIZE=: 50000
close''
if. 'json'-:FIN  do. in=:  jsonenc else. in=:  jbinenc  end.
if. 'json'-:FOUT do. out=: [       else. out=: jbindec end.
i.0 0
)

HTTP=: 0 : 0 rplc LF;CRLF
POST / HTTP/1.1
Host: IPAD:PORT
User-Agent: j_jd_msr
Accept: */*
Content-Length: XXX
Content-Type: application/x-www-form-urlencoded
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

NB. build http request
msrx=: 3 : 0 
c=. FIN,' ',FOUT,' ',DAN,' ',UP,';'
if. 0=L.y do. c=. c,y else. c=. c,(;{.y),LF,in }.y end.
(HTTP rplc 'IPAD';HOST;'PORT';SPORT;'XXX';":#c),CRLF,c
)

NB. send http request and get response - must be connected and does not close
msr=: 3 : 0
'run jds_client_config to set PORT'assert _1~:PORT
try.
 if. S=_1 do. connect'' end.
 snd_request msrx y
 out rcv_response''
catch.
 close''
 (13!:12'')assert 0
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
'run jds_client_config to set PORT'assert _1~:PORT
try.
 if. S=_1 do. connect'' end.
 snd_request (msrx y) rplc'POST';'POSx'
 out rcv_response''
catch.
 close''
 (13!:12'')assert 0
end.
)

NB. send request with bad boxed data
msrbaddata=: 3 : 0
'run jds_client_config to set PORT'assert _1~:PORT
try.
 if. S=_1 do. connect'' end.
 snd_request msrx y NB. drop last char to damage data
 out rcv_response''
catch.
 close''
 (13!:12'')assert 0
end.
)

NB. wget/curl
NB. wget or curl will fail (interface error) if they are not installed on your machine
NB. if wget fails, try curl and vice versa

POSTFILE=:   hostpathsep jpath'~temp/postfile'

NB. create post arg file for wget or curl
wcarg=: 3 : 0
c=. 'json json ',DAN,' ',UP,';'
if. L.y do. a=. c,(;{.y),LF,jsonenc }.y else. a=. c,y end.
a fwrite POSTFILE
)

wgetx=: 3 : 0
wcarg y
t=. ;(UNAME-:'Win'){'wget';hostpathsep jpath'~tools/ftp/wget'
t=. t,' -O- -q http://HOST:PORT/ --post-file "POSTFILE"'
t rplc 'HOST';HOST;'PORT';SPORT;'POSTFILE';POSTFILE
)

wget=: 3 : 'shell_jtask_ wgetx y'

curlx=: 3 : 0
wcarg y
t=. 'curl -s http://HOST:PORT/ --data @"POSTFILE"'
t rplc 'HOST';HOST;'PORT';SPORT;'POSTFILE';POSTFILE
)

curl=: 3 : 'shell_jtask_ curlx y'
