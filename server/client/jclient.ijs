NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. j curl access to jd server

3 : 0'' NB. normally done in jd.ijs - but not if only client code
if. _1=nc<'jdscpath' do. jdscpath=: 'jdscpath/' end. NB. path to all server/client files
)

require'~addons/ide/jhs/extra/man.ijs'
require'convert/pjson'
require'~addons/arc/lz4/lz4.ijs'

coclass'jdjclient'
coinsert'jd'

man_jd_jclient=: 0 : 0
access jd server running on localhost port 3000:
start J task 
   load'jd' NB. includes jdjclient.ijs
or   
   load'~addons/data/jd/server/client/jds/jdjclient.ijs' NB. just client

   jdp1=: jdclient 'localhost:3000' NB. create jd access folder
   jdreq jdp1;'logon simple u u' NB. dan simple user pswd
   jdreq jdp1;'info schema'
   jdreq jdp1;'logoff' NB. logoff and delete client folder

   jdrt'j_client'
)

jdclient_z_=: jdclient_jdjclient_
jdreq_z_=:    jdreq_jdjclient_

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
jdclient=: 3 : 0
'host port'=. <;._1 ':',y
cert=. ('localhost'-:host){'';'-k' NB. localhost curl option -k
path=. mkdirunique jdscpath,'client/',host,'-',port
a=. fread'~addons/data/jd/server/client/curl'
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
jdreq=: 3 : 0
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

