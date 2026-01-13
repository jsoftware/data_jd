NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. node server tools

load'~addons/data/jd/server/client/jdbashclient.ijs'

coclass'jdserver'
coinsert'jd'

NB. PATH;nport;jport
NB. create node files in folder PATH/PORT
create_node=: 3 : 0
'path nport jport'=. y NB. unused was nodebinpath
nodebin=. fread '~config/nodebinpath'
p=. jpath path,('/'#~'/'~:{:path),'node/'
mkdir_j_ p

nodefile=. jpath'~addons/data/jd/server/node/reverse_proxy_binary.js'
config=. '{\"nport\":\"<NPORT>\",\"jport\":\"<JPORT>\"}'rplc '<NPORT>';nport;'<JPORT>';jport
nodeflags=. ' --inspect=localhost:',(":1+0".nport),' '

if. IFWIN do.
 NB. create run.bat and run.txt
 t=. '"NODEBIN" "JS" "CONFIG"'
 t=. t rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.bat'
 r=. t fwrite p,'run.bat'
 pw=. hostpathsep p
 ('"PATHrun.bat" > "LOG" 2>&1' rplc 'PATH';pw;'LOG';pw,'logstd.log') fwrite p,'run.txt'
else.
 NB. create run.sh and run.txt
 t=. '#!/bin/bash'
 t=. t,LF,'"NODEBIN" ',nodeflags,' "JS" "CONFIG"' NB. --inspect=localhost:65222
 t=. t rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.sh'
 r=. t fwrite f
 shell'chmod +x "',f,'"'
 ('nohup "PATHrun.sh" > "LOG" 2>&1' rplc 'PATH';p;'LOG';p,'logstd.log') fwrite p,'run.txt'
 createsh_jdbash_ p NB. bash client scripts on this system and in node server files
end. 

(fread '~addons/data/jd/server/node/server.html') fwrite p,'/server.html' NB.! ???
i.0 0
)
