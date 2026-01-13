NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. only script required by J client of Jd server

jdaccess_z_=: jdaccess_jd_
jd_z_  =:   jd_jd_
jdae_z_=:   jdae_jd_
jdtx_z_=:   jdtx_jd_
jds_z_=:    jds_jd_
jdserver_z_=:    jdserver_jd_

coclass'jd'
optionspace=: 0
optionsort =: 0

lastcmd    =: 'none'
lasttime   =: _1
lastspace  =: _1
lastparts  =: _1

JDE1001=: 'jde: not an op'

jbinenc_z_=: 3 !: 1
jbindec_z_=: 3 !: 2
jsonenc_z_=: enc_pjson_

NB. jsondec_z_=: dec_pjson_

NB. json data has byte matrices encoded as ["abc","def","ghi"]
NB. open everything to get byte matrices
jsondec_z_=: 3 : 0
if. '"'={.y do. dec_pjson_ y return. end.
>each dec_pjson_ y
)

fmtx=: 4 : 0
if. 0=#y do. '' else. x,':',(}:;,&','@":&>boxxopen y),' ' end.
)

fmtoper=: 3 : 0
('op'fmtx OP),('tab'fmtx FETAB),('col'fmtx FECOL),('xtra'fmtx FEXTRA),('db'fmtx DB),('user'fmtx USER)
)

NB. dan;user [;intask or host]
NB. last parameter was used but is now ignored
NB. previously user was user/password and this was checked agains admin.ijs
NB. jd direct allows user access without password check
NB. jds/node server requires logon that checks password against uctable
jdaccess=: 3 : 0
if. ''-:y do. DBX return. end.
if. 0-:y do. y=. '';'' end.
t=. 2{.(bdnames y),<'u' NB. default u
assert 2=#t['bad jdaccess arg'
a=. ;{:t
a=. (a i.'/'){.a
'DB UP'=: DBX_jd_=: ({.t),<a
i.0 0
)

0 : 0
previously Jd had user/pswd in db admin.ijs
not well thought out but worked ok for  private use

node server requires better system

user replaces u/p in admin.ijs
 user defines which valid (logged on) users 
 can access a dan with what valid ops

user is validated at logon
 validated user sets cookie that identifies
 session and allows cookie to map to validated user

user can be an individual or it can be a role

)

NB. jbin;lz4;data
jdsresult=: 3 : 0
'jbin lz4 a'=. y
if. jbin do. a=. jbinenc a else. a=. jsonenc a end. 
if. lz4 do. a=. lz4_compressframe_jlz4_ a end.
a
)

NB. cookie dan req
NB. cookie is added by node
NB. cookie must not contain blank
NB. single blank delimits cookie and dan
NB. req can be compressed or not - lz4
NB. req is jbin or json
NB.
NB. client request
NB. +user/pswd or req
NB. req (compressed or not)
NB. compression determined by examining initial bytes - lz4 first byte 4{a.
NB. decompress req if required
NB. decompreq is in jbin or json format
NB. node adds cookie in front of req (it is not compressed)
NB. 
NB. jds - similar to jd - except for server
NB. cookie dan ; enc info summary
NB. cookie dan ; enc insert f',LF,json/jbin-encoded-dat
NB. + +;enc logonu/p
NB. enc - lz4+jbin or json
NB. cookie selects user from logon data
NB. result is a lz4+jbin or json dictionary
NB. jd server can be used by jdjclient/bash/browser and other clients
NB. most clients except browser will use curl
jds=: 3 : 0
decho jdsq__=: y
try.
 req=. y

 NB. cookie dan cmd - strip off cookie and dan
 i=. req i. ' '
 up=. i{.req
 req=. (>:i)}.req
 i=. req i. ' '
 dan=. i{.req
 req=. (>:i)}.req
 
 NB. infer compression/encoding from data 
 lz4=. 4=a.i.{.req
 if. lz4 do. req=. lz4_uncompressframe_jzl4_ req end.

 jbin=. 227=a.i. {.req

echo jbin
echo jsondec req
 
 if. jbin do. req=. jbindec req else. req=. jsondec req end.

 opstring=. dltb;{.boxopen req

 decho opstring
 
 'invalid cmd' assert 2=3!:0 opstring
 op=. dltb(opstring i.' '){.opstring

 if. 'logoff'-:op do. a=. logoff_jdup_ up return. end.
 if. 'logon'-:op do. a=. logon_jdup_ opstring return. end.
  
 user=. getuser_jdup_ up
 if. user-:'admin' do.
  'admin can only do admin'assert 'admin '-:6{.a
  a=. do__ 6}.a
  a=. jdsresult jbin;lz4;<a
  return.
 end.

 jdaccess dan;user

 opstart=. 6!:9''
 jdlast_z_=: jdx req
 oplog ((":!.18)opstart-~6!:9''),' ',user,' ',op
 
 a=. jdlast
 t=. ;{.{.a
 if. 'Jd error'-:t do. a=. ('Jd error';'Jd extra'),.}.a
 elseif. JDOK-:a do. a=. ,:'Jd OK';0
 elseif. 'Jd report '-:10{.t do. a=. ,a
 elseif. 0=*/$a do. a=. ,:'Jd empty';''
 elseif. 0=L.a  do. a=. ,:'Jd version';a
 end.
 if. (op-:'info')*.-.jbin do. a=. |:a end. NB. json requires 
 a=.jdsresult jbin;lz4;<a
catch.
 if. +./_1=nc ;:'lz4 jbin opstring' do. 'lz4 jbin opstring'=. 0;0;'not available' end.
 a=. jdsresult jbin;lz4;<('Jd server error';'Jd extra'),.(13!:12'');;opstring
end.
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

NB. assert error that was expected
jdae=: 4 : 0
try. 
 jd y
 'did not get expected error'assert 0
catchd.
 t['did not get expected error text'assert +./x E. t=. ;1{jdlast
end.
)

NB. timex jd sentence
jdtx=: 3 : 0
timex 'jd''',y,''''
)

NODBOPS=: 'close';'createdb';'list';'option' NB. ops without DB
ROOPS=: 'close';'read';'reads';'info';'list';'rspin'

NB. log performance info
NB. add this op info to memory log
NB. record only if oplogdata has been defined (perhaps by user admin)
oplog=: 3 : 0
oplogdata=: oplogdata,y,LF
if. 10e6<#oplogdata do.
 oplogdata=: (<.-:#oglogdata)
 oplogdata=: (oplogdata i. LF)}.oplogdata
end.
)

NB. jdx always returns a boxed result - jd asserts it is not an error
jdx=: 3 : 0
jdlasty_z_=: y
'DB UP'=: bdnames DBX
USER=: (UP i.'/'){.UP NB. newer usage has only user (not user/password)
'FEOP OP FETAB FECOL FEER FEXTRA'=: <''
FIXPAIRSFLAG=: 0
try.
 'jde: jd not loaded'assert 0=nc<'DBPATHS'
 
 if. 0=L.y do.
  t=. dlb y
  i=. t i.' '
  FEOP=: OP=: i{.t
  a=. dltb i}.t
 else.
  t=. (bdnames ;{.y),}.y
  FEOP=: OP=: dltb ;{.t
  a=. }.t
 end.
 
 pm OP
 'op'logtxt FEOP
 opx=. ;('x'-:{.OP){OP;'x'
 
 'MTRO db only allows read type ops' assert (JDMT~:MTRO_jmf_)+.(<OP) e. ROOPS
 
 if. -. (<OP) e. NODBOPS do. 
  getdb'' NB. dbl global and test for damage
  'db damaged and not under repair' assert (-.DAMAGE__dbl)+.REPAIR__dbl
  r=. dbrow DBPATHS
  'not a db access name' assert r<#DBPATHS
  r=. dbrow DBUPS
  'bad DBUPS' assert (r<#DBUPS)*.(<UP)e.bdnames>{:r{DBUPS
  NB. OP in DBOPS  and jd__CMD defined
  r=. dbrow DBOPS 
  JDE1001 assert r~:#DBOPS 
  JDE1001 assert +./(OP;,'*')e.bdnames>{:r{DBOPS
  JDE1001 assert 3=nc<'jd_',opx 
 else.
  dbl=: ''
 end. 

 start=. 6!:1''
 parts=: _1
 if. optionspace do. NB.! this should be fixed or killed off
  lastspace=: 7!:2'r=. (''jd_'',opx)~a' 
 else.
 
  NB. do repupdate if required
  if. 0~:#dbl do.
   if. 2=REPLICATE__dbl do.
    repupdate''
   end. 
  end.
  
  r=. ('jd_',opx)~a

  if. (<opx) e. rops_jddatabase_ do. opx rlog__dbl a end. 
  
  lastspace=: _1
 end.
 lasttime=: start-~6!:1''
 lastcmd=: FEOP
 lastparts=: parts
 pmz''
 r
 return.

catchd.
  LASTRAW=: t=. 13!:12''
  t=. dltb each (}.^:('|'={.))each<;._2 t
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
   t=. t-.<': assert'
   r=. _2}.;t,each<' |'
  end.
  r=. (5*'jde: '-:5{.r)}.r
  ,.'Jd error';r;fmtoper y
end.
)
