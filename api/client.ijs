NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. only script required by J client of Jd server

require'socket'

optionspace_jd_=: 0
lastcmd_jd_    =: 'none'
lasttime_jd_   =: _1
lastspace_jd_  =: _1

jdaccess_z_=: jdaccess_jd_
jd_z_  =: jd_jd_

coclass'jd'

JDE1000=: 'jde: not a database'
JDE1001=: 'jde: not an op'

fmtx=: 4 : 0
>(0<#y){' ';' ',x,':',y
)

fmtoper=: 3 : 0
'user:',USER,' db:',DB,' op:',OP,' tab:',ETAB,('col'fmtx ECOL),('typ'fmtx ETYP),('shape'fmtx ESHAPE)
)

NB. clean args
NB. box blank delimited args
NB. args can be quoted in double quotes (to include blanks in arg)
NB. * escapes to include remainder in final arg
NB. dltb and , applied to each
ca=: 3 : 0
if. 1=L.y do. ,each dltb each y return. end.
a=. y
r=. ''
while. #a=.dlb a do.
 if. '"'={.a do.
  a=. }.a
  i=. a i.'"'
  'jde: unmatched double quote' assert i<#a
  r=. r,<i{.a
  a=. }.i}.a
  'jde: closing double quote not followed by blank' assert ' '={.a
 elseif. '*'={.a do.
  r=. r,<}.a
  a=. '' 
 elseif. 1 do.
  i=. a i.' '
  r=. r,<i{.a
  a=. }.i}.a
 end.
end.
,each dltb each r
)

NB. box blank delimited names
bdnames=: 3 : 0
if. 0=#y do. y return. end.
if. 0=L.y do.
 ,each <;._1' ',deb y
else.
 ,each dltb each y
end. 
)

jdaccess=: 3 : 0
if. ''-:y do. DBX return. end.
if. 0-:y do. i.0 0['DB UP SERVER'=: DBX_jd_=: '';'';'intask' return. end.
t=. bdnames y
if. 1=#t do. t=. t,'u/p';'intask' end.
assert 3=#t['bad arg'
a=. ;{:t
if. -.'intask'-:a do.
 assert 'localhost:'-:10{.a['bad host'
 assert 0=#(10}.a)-.'0123456789'['bad port number'
end.
'DB UP SERVER'=: DBX_jd_=: t
i.0 0
)

jd=: 3 : 0
jdlast_z_=: jdx y
t=. ;{.{.jdlast
if. 'Jd error'-:t do.
 t=. _2}.;jdlast,each <': '
 13!:8&3 t
elseif. 'Jd report '-:10{.t do. ;{:jdlast 
elseif. 'Jd OK'-:t          do. i.0 0
elseif. 1                   do. jdlast
end.
)

NB. jdx always returns a boxed result - jd asserts it is not an error
jdx=: 3 : 0
if. IFJHS do. assert (<URL_jhs_) e.'jijx';'jijs' end.
DBX jdx y
:
APIRULES=: 1
'DB UP SERVER'=: bdnames x
USER=: (UP i.'/'){.UP
'OP ETAB ECOL ETYP ESHAPE'=: 5$<''
try.
if. 'intask'-:SERVER do.
 'jde: jd not loaded'assert 0=nc<'DBPATHS'
 
 if. 0=L.y do.
  y=. dlb y
  i=. y i.' '
  OP=: i{.y
  a=. dltb i}.y
 else.
  y=. (bdnames ;{.y),}.y
  OP=: dltb ;{.y
  a=. }.y
 end.
 'op'trace <OP
 opx=. ;('x'-:{.OP){OP;'x'
 if. -. (<OP) e. 'close';'createdb' do. NB. ops without DB
  DBL=: getdb'' NB. DBL global and test for damage
  t=. JDE1000
  NB. DB in DBPATHS
  r=. dbrow DBPATHS
  t assert r<#DBPATHS
  NB. USER/PSWD in DBUPS
  r=. dbrow DBUPS
  t assert r<#DBUPS
  t assert (<UP)e.bdnames>{:r{DBUPS
  NB. OP in DBOPS  and jd__CMD defined
  r=. dbrow DBOPS 
  JDE1001 assert r~:#DBOPS 
  JDE1001 assert +./(OP;,'*')e.bdnames>{:r{DBOPS
  JDE1001 assert 3=nc<'jd_',opx 
 end. 
 start=. 6!:1''
 if. optionspace do.
  lastspace=: 7!:2'r=. (''jd_'',opx)~a' 
 else.
  r=. ('jd_',opx)~a
  lastspace=: _1
 end.
 lasttime=: start-~6!:1''
 lastcmd=: OP
 NB. assumed clean up and unmap would allow for better host management of ram
 NB. helps a little bit in windows, but is disatrous in linux
 NB. pm/pma.ijs result
 NB. jd_close'' 
 r
 return.
end.
NB. shellwget can be used instead of jwget
'headers data'=. jwget SERVER;'jjd';'JBIN;JBIN;',DB,';',UP,';;*',3!:1 y 
h=.  <;._2 headers-.CR
if. -.(<'HTTP/1.1 200 OK')={.h do. headers assert 0 return. end.
if. (<'Content-Type: text/plain')e.h do. data assert 0 return. end.
3!:2 data
catchd.
  LASTRAW=: t=. 13!:12''
  t=. dltb each }.each<;._2 t
  v=. >{.t
  if. 'ECONNREFUSED:'-:13{.v do.
   r=.'jde: jdserver (',SERVER,') not running'
  elseif. 'assertion failure: assert'-:v do.
   r=. >1{t
   if. ''''={:r do.
    r=. }:r
    r=. r rplc '''''';{.a.
    i=. r i: ''''
    r=. }.i}.r
    r=. r rplc ({.a.);''''
   end.
  elseif. ': assert'-:_8{.v do.
   r=. _8}.v
  elseif. ': throw'-:_7 {.v do.
   r=. _7}.v
  elseif. 1 do.
   r=. ;  ( {.t) ,(<': '), }.t
  end.
  r=. (5*'jde: '-:5{.r)}.r
  ,.'Jd error';r;fmtoper y
end.
)

NB.! following code should be made as robust and general as possible
NB.  it should then be refactored into JHS (where it came from)

NB. send socket data
NB. return count of bytes sent
NB. errors: timeout, socket error, no data sent (disconnect)
ssend=: 4 : 0
'socket timeout'=. y
z=. sdselect_jsocket_ '';socket;'';timeout
'jde: jdserver send not ready' assert socket=>2{z
'c r'=. x sdsend_jsocket_ socket,0
('jde: jdserver send error: ',sderror_jsocket_ c) assert 0=c
'jde: jdserver send no data' assert 0<r
r
)

NB. data putdata socket,timeout
putdata=: 4 : 'while. #x do. x=. (x ssend y)}.x end.'

srecv_jd_=: 3 : 0
'socket timeout bufsize'=. y
z=. sdselect_jsocket_ socket;'';'';timeout
'jde: jdserver recv timeout' assert  socket e.>1{z  NB.0;'';'';'' is a timeout
'jde: jdserver recv not ready' assert socket=>1{z
'c r'=. sdrecv_jsocket_ socket,bufsize,0
('jde: jdserver recv error: ',sderror_jsocket_ c) assert 0=c
'jde: jdserver recv no data'       assert 0<#r
r
)

NB. get/post data - headers end with CRLF,CRLF
NB. post has Content-Length: bytes after the header
NB. listen and read until a complete request is ready
getdata=: 3 : 0
'socket timeout bufsize'=. y
h=. d=. ''
cl=. 0
while. (0=#h)+.cl>#d do. NB. read until we have header and all data
 r=. srecv socket,timeout,bufsize
 d=. d,r
 if. 0=#h do. NB. get headers
  i=. (d E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
  if. i<#d do. NB. have headers
   i=. 4+i
   h=. i{.d NB. headers
   d=. i}.d
   i=. ('Content-Length:'E. h)i.1
   if. i<#h do.
    t=. (15+i)}.h
    t=. (t i.CR){.t
    cl=. _1".t
    assert _1~:cl
   else.
    cl=._1
   end. 
  end.
 end.
end.
h;d
)

jwget=: 3 : 0
'server url data'=. y
i=. server i.':'
ip=. i{.server
port=. 0".(>:i)}.server
ip=. >2{sdgethostbyname_jsocket_ ip
try.
 t=. posttemplate rplc '<URL>';url;'<DATA>';data;'<COUNT>';":#data
 sk=. >0{sdcheck_jsocket_ sdsocket_jsocket_''
 NB. sdcheck_jsocket_ sdioctl_jsocket_ sk,FIONBIO_jsocket_,1
 sdcheck_jsocket_ sdconnect_jsocket_ sk;AF_INET_jsocket_;ip;port
 t putdata sk,5000
 hd=. getdata sk,5000,50000
catch.
 sdclose_jsocket_ sk
 (13!:12'') assert 0
end.
sdclose_jsocket_ sk
hd
)

posttemplate=: _2}.toCRLF 0 : 0
POST /<URL> HTTP/1.1 
Connection: Keep-Alive
Content-Length: <COUNT>

<DATA>
)

wget=:   jpath'~tools/ftp/wget' NB.! IFUNIX
pid=. ":2!:6''
fileresult=:  jpath'~temp/jdresult',pid
filepost=:    jpath'~temp/jdpost',pid

NB. 'headers data'=. jwget SERVER;'jjd';3!:1 DB;y 
shellwget=: 3 : 0
'server url data'=. y
i=. server i.':'
ip=. i{.server
port=. 0".(>:i)}.server
ip=. >2{sdgethostbyname_jsocket_ ip
data fwrite filepost
g=. wget,' --timeout=5 --save-headers --output-document="',fileresult,'" --post-file="',filepost,'" ',server,'/',url
gr=. shell g
r=. fread fileresult
ferase filepost
ferase fileresult
i=. 4+(r E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
(i{.r);i}.r
)

3 : 0''
if. _1=nc<'DBX_jd_' do. jdaccess 0 end.
)