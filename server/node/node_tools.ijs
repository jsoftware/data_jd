NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. node server tools

coclass'jdserver'
coinsert'jd'

NB. PATH;nport;jport
NB. create node files in folder PATH/PORT
create_node=: 3 : 0
'path nport jport inspect'=. y NB. unused was nodebinpath
nodebin=. fread '~config/nodebinpath'
p=. jpath path,('/'#~'/'~:{:path),'node/'
mkdir_j_ p

nodefile=. JDP,'/server/node/reverse_proxy_binary.js'
curl=. (fread path,'node/curl')rplc'"';'\\\"';'/';'\/';'$';'\$' NB. has to get past shell rules
config=. '{\"nport\":\"<NPORT>\",\"jport\":\"<JPORT>\",\"jdpath\":\"<JDPATH>\"}'rplc '<NPORT>';nport;'<JPORT>';jport;'<JDPATH>';JDP
nodeflags=. ;(inspect-:'inspect-yes'){' --no-inspect ';' --inspect=localhost:',":1+0".nport

if. IFWIN do.
 NB. create run.bat and run.txt
 t=. '"NODEBIN" "JS" "CONFIG"'
 t=. t rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.bat'
 r=. t fwrite p,'run.bat'
 pw=. hostpathsep p
 ('"PATHrun.bat" > "LOG" 2>&1' rplc 'PATH';pw;'LOG';pw,'logstd.log') fwrite p,'run.txt'

 NB. create --inspect debug versions
 sh=.  fread handle,'node/run.bat'
 txt=. fread handle,'node/run.txt'
 if. +./' --no-inspect 'E.sh do.
  NB. need --inspect versions of run.txt and run.sh
  sh=. sh rplc ' --no-inspect ';' --inspect=localhost:',":1+0".nport
  txt=. txt rplc 'run.bat';'rundebug.bat'
 end. 
 sh  fwrite handle,'node/rundebug.bat'
 txt fwrite handle,'node/rundebug.txt'

else.

 NB. create run.sh and run.txt
 t=. '#!/bin/bash'
 t=. t,LF,'"NODEBIN" ',nodeflags,' "JS" "CONFIG"' NB. --inspect=localhost:65222
 t=. t rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.sh'
 r=. t fwrite f
 shell'chmod +x "',f,'"'
 (SETSID,' "PATHrun.sh" > "LOG" 2>&1' rplc 'PATH';p;'LOG';p,'logstd.log') fwrite p,'run.txt'

 NB. create --inspect debug versions
 sh=.  fread handle,'node/run.sh'
 txt=. fread handle,'node/run.txt'
 if. +./' --no-inspect 'E.sh do.
  NB. need --inspect versions of run.txt and run.sh
  sh=. sh rplc ' --no-inspect ';' --inspect=localhost:',":1+0".nport
  txt=. txt rplc 'run.sh';'rundebug.sh'
 end. 
 sh  fwrite handle,'node/rundebug.sh'
 shell 'chmod +x "',handle,'node/rundebug.sh"'
 txt fwrite handle,'node/rundebug.txt'
end. 

(fread JDP,'server/node/server.html') fwrite p,'/server.html' NB.! ???
i.0 0
)
