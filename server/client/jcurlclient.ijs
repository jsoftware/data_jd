NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. curl access to jd server
NB. most clients use libcurl
NB. if libcurl not available (e.g. in shell) then curl can be used

0 : 0
   jds1=: (jdcurl 'localhost:3002')&jdcurlreq
   jds1 'logon simple u u'
   jds1 'info summary'
)

3 : 0'' NB. normally done in jd.ijs - but not if only client code
if. _1=nc<'jdscpath' do. jdscpath=: 'jdscpath/' end. NB. path to all server/client files
)

coclass'jd'

jdcurlclient_z_=: jdcurlclient_jd_
jdcurlreq_z_=: jdcurlreq_jd_

NB. stuff for client files for client that use curl instead of libcurl

NB. mkdirunigue path
NB. ensure last folder in path is unique 
NB. if last folder already exists - name adjusted until it is ok
NB. assumes safe to mkdir -p up to last folder
mkdirunique=: 3 : 0
path=. abspath jpath y
'mkdirunique failed'assert 1=mkdir_j_ (path i:'/'){.path
c=. 0
p=. path
while. 1 do.
 c=. c+1
 'too many folders'assert 100>c
 path=. p,'-',":c
 if. IFWIN do.
  if. 0=#shell'mkdir ',hostpathsep path do. break. end.
 else.
  if. -.0-:shell :: 0: 'mkdir ',path,' 2> /dev/null' do. break. end.
 end. 
end.
path
)

NB. * 'host:port'
NB. client files created at jdclientdefault/host-port-n
NB. returns path to client files - jdreq arg
NB. used by jd client that use curl intead of libcurl
jdcurlclient=: 3 : 0
'host port'=. <;._1 ':',y
cert=. ('localhost'-:host){'';'-k' NB. localhost curl option -k
path=. mkdirunique jdscpath,'client/',host,'-',port
a=. fread JDP,'server/client/curl'
a=. a rplc '$1';path;'$2';(host,':',port);'$3';cert
a fwrite path,'/curl'
'client'fwrite path,'/jdclass'
path
)

NB. * path;cmd
NB. path * cmd
NB. * path;'logon dan user pswd'
NB. * path;'info schema'
NB. * path;'logoff'  NB. logoff and delete folder
NB. dyadic allows path&jdreq
jdcurlreq=: 3 : 0
path=. ;{.y
cmds=. }.y
'not a jd client folder'assert 'client'-:fread path,'/jdclass'
(lz4_compressframe_jlz4_ 3!:1 cmds) fwrite path,'/post'
NB.! try. shell path,'/curl.sh' catch. ('curl failed: ',fread path,'/stderr')assert 0 end.
try. shell fread path,'/curl' catch. ('curl failed: ',fread path,'/stderr')assert 0 end.
r=. fread path,'/result'
if. 'logoff'-:dltb ;{.cmds do. rmdir_j_ path end.
if. '{'={.r do. dec_pjson_ r return. end. NB. dec not jsondec
(3 !: 2) @ lz4_uncompressframe_jlz4_ r
:
jdreq x;y
)

