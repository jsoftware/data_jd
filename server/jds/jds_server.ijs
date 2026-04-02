NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. only script required by J client of Jd server

jdaccess_z_=: jdaccess_jd_
jd_z_  =:   jd_jd_
jdae_z_=:   jdae_jd_
jdce_z_=:   jdce_jd_
jdtx_z_=:   jdtx_jd_
jds_z_=:    jds_jd_
NB.! jdserver_z_=:    jdserver_jd_

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
NB. jds/node server requires logon that checks password against ductable
jdaccess=: 3 : 0
if. ''-:y do. DBX return. end.
if. 0-:y do. y=. '';'' end.
t=. 2{.(bdnames y),<'user0' NB. default admin
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
if. jbin do.
 a=. jbinenc a
else.
 try. a=. jsonenc a catch. a=. '{"Jd error":"jsonenc failed"}' end. NB.!
end.
if. lz4 do. a=. lz4_compressframe_jlz4_ a end.
a
)

NB. server log is separate and in addition to other logs
jdslog=: 3 : 0
'type dan user data'=. y
m=. (_4}._12{.isotimestamp 6!:0''),' : ',(3{.type),' : ',(12{.dan),' : ',(12{.user),' : ',(50{.data) rplc LF;TAB
f=. JDSPATH,'jds.log'
logsize f
(m,LF) fappend f
)

NB. server log is separate and in addition to other logs
jdslog=: 3 : 0
'type dan user data'=. 4{.y
m=. (isotimestamp 6!:0''),TAB,type,TAB,dan,TAB,user,TAB,data rplc LF;' LF ';TAB;' TAB '
f=. JDSPATH,'jds.log'
logsize f
(m,LF) fappend f
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

NB. check error - verify expected error
NB. similar to jdae but can be used with jd and s1 (server)
jdce=: 4 : 0
'a b'=. {.y
if. 'Jd error'-:a do.
 'did not get expected error text'assert +./x E. b
else.
 'did not get expected error'assert 0
end.
i.0 0
)

NB. assert error that was expected
jdae=: 4 : 0
try. 
 jd y
 'did not get expected error'assert 0
catchd.
 t['did not get expected error text'assert +./x E. t=. 13!:12''
end.
)

NB. client request
NB. jds - similar to jd - except for server
NB. cookie dan cmd
NB. cookie is added by node
NB. cookie must not contain blank
NB. sinlge blank delimits cookie and dan
NB. dan cmd can be compressed (lz4) or not
NB. compression determined by examining initial bytes - lz4 first byte 4{a.
NB. dan cmd is jbin or json or simple string
NB. simple string does not start with { or " and does not have " or other special chars
NB.
NB. cookie selects user from logon data
NB. result is lz4 if arg was lz4
NB. result data is jbin or json dictionary
NB.
NB. jd server can be used by jdjclient/bash/python/browser and other clients
NB. most clients except browser will use curl
jds=: 3 : 0
'lz4 jbin dan user opstring'=. 0;0;3#<'not-set'
try.
 req=. y

 NB. strip off cookie from end
 i=. req i: ' '
 up=. (>:i)}.req
 cmd=. i{.req

 NB. infer compression from data 
 lz4=. 4=a.i.{.cmd
 if. lz4 do. cmd=. lz4_uncompressframe_jzl4_ cmd end.
 
 NB. infer encoding from data
 jbin=. 227=a.i. {.cmd
 if. jbin do. cmd=. jbindec cmd else. if. +/'["'e. {.cmd do. cmd=. jsondec cmd end. end.
 
 opstring=. dltb;{.boxopen cmd
 'invalid cmd' assert 2=3!:0 opstring
 op=. dltb(opstring i.' '){.opstring

 if. 'logoff'-:op do. a=. logoff_jdup_ up return. end.

 if. 'logon'-:op do.
  t=. bdnames 6}.opstring
  ETALLY assert 3=#t
  a=. logon_jdup_ t
  return.
 end. 
 
 'dan user'=. get_dan_user_jdup_ up
 'logon required'assert 0~:#user
 jdslog 'req';dan;user;opstring
 jdaccess dan;user

 if. op-:'admin' do.
  'only admin can do admin'assert 'admin'-:user
  a=. do__ 6}.opstring
  a=. jdsresult jbin;lz4;<a
  return.
 end.

 NB. troubles with jd treatment of <'read from t'
 if. 1=#cmd do. cmd=. opstring end.
 
 opstart=. 6!:9''
catch.
 jdslog 'err';dan;user;opstring,LF,}:13!:12''
 a=. jdsresult jbin;lz4;<('Jd server error';'Jd extra'),.(13!:12'');;opstring
end.

jdlast_z_=: jdx cmd
t=. ;{.{.jdlast
NB.if. 'Jd error'-:t do. jdlast_z_=: ('Jd error';'Jd extra'),.}.jdlast end.
if. (op-:'info')*.-.jbin do. jdlast_z_=: |:jdlast end. NB. |: so we have a json table
a=.jdsresult jbin;lz4;<jdlast
)

NB. [signal] * 'info summary'
NB. * 'info summary'
NB. 0 * 'info xxx' NB. returns Jd error
NB. signal 1 (default) signals an error with a Jd error result
NB. most results are boxed array of labeled rows or cols
NB. {.{.result can be Jd ...
NB. 'Jd report' has special treament
NB. jd'key ...' - returns list of numbers
NB. jd'csv...'  - do not return tables
jd=: 3 : 0
1 jd y
:
jdlast_z_=: jdx y

if. x*.'Jd error'-:;{.{.jdlast do.
  t=. _2}.;jdlast,each <': '
  13!:8&3 t
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
  jdlast_z_=. ('jd_',opx)~a

  if. (<opx) e. rops_jddatabase_ do. opx rlog__dbl a end. 
  
  lastspace=: _1
 end.
 lasttime=: start-~6!:1''
 lastcmd=: FEOP
 lastparts=: parts
 pmz''
 
 t=. ;{.{.jdlast
 if. 'Jd report '-:10{.t     do. ;{:jdlast 
 NB.! elseif. 0=*/$jdlast         do. ,:'Jd empty';''
 elseif. 1                   do. jdlast
 end.
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
  NB. t=. ,.'Jd error';r;fmtoper y
  ('Jd error';'Jd extra'),.r;fmtoper y
end.
)
