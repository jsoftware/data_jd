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
nodeflags=. ' <INSPECT> ' 

yes=. ' --inspect=localhost:',":1+0".nport
default=. ;(inspect-:'inspect-yes'){'';' --inspect=localhost:',":1+0".nport

 run=. '"NODEBIN" "INSPECT" "JS" "CONFIG"'
 if. IFWIN do.
 NB. create run.bat and run.txt
 t=. run rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.bat'
 t fwrite p,'run.bat'
 pw=. hostpathsep p
 ('"PATHrun.bat" > "LOG" 2>&1' rplc 'PATH';pw;'LOG';pw,'logstd.log') fwrite p,'run.txt'

 a=. fread handle,'node/run.bat'
 b=. a rplc '"INSPECT"';default
 b fwrite handle,'node/run.bat'
 
 b=. a rplc '"INSPECT"';yes
 b  fwrite handle,'node/rundebug.bat'

 a=. fread handle,'node/run.txt'
 b=. a rplc 'run.bat';'rundebug.bat'
 b fwrite handle,'node/rundebug.txt'

else.

 NB. create run.sh rundebug.sh run.txt rundebug.txt
 t=. '#!/bin/bash',LF
 t=. t, run rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.sh'
 r=. t fwrite f
 shell'chmod +x "',f,'"'
 (SETSID,' "PATHrun.sh" > "LOG" 2>&1' rplc 'PATH';p;'LOG';p,'logstd.log') fwrite p,'run.txt'

 a=. fread handle,'node/run.sh'
 b=. a rplc '"INSPECT"';default
 b  fwrite handle,'node/run.sh'
 b=. a rplc '"INSPECT"';yes
 f=. handle,'node/rundebug.sh'
 b  fwrite f
 shell'chmod +x "',f,'"'

 a=. fread handle,'node/run.txt'
 b=. a rplc 'run.sh';'rundebug.sh'
 b fwrite handle,'node/rundebug.txt'
 
end. 

(fread JDP,'server/node/server.html') fwrite p,'/server.html' NB.! ???
i.0 0
)
