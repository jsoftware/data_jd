NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. node server tools

require JDP,'server/port.ijs'

NB. PATH;PORT;NODEBIN
NB. create node files in folder PATH/PORT
create_node=: 3 : 0
'path port nodebin'=. y
sport=. ":port
p=. jpath path,('/'#~'/'~:{:path),'node/',sport,'/'
mkdir_j_ p

if. IFWIN do.
 NB. create run.bat and run.txt
 t=. '"NODEBIN" "JS" "CONFIG"'
 t=. t rplc 'NODEBIN';nodebin;'JS';(p,'server.js');'CONFIG';p,'config.js'
 f=. p,'run.bat'
 r=. t fwrite p,'run.bat'
 pw=. hostpathsep p
 ('"PATHrun.bat" > "LOG" 2>&1' rplc 'PATH';pw;'LOG';pw,'logstd.log') fwrite p,'run.txt'
else.
 NB. create run.sh and run.txt
 t=. '#!/bin/bash'
 t=. t,LF,'"NODEBIN" "JS" "CONFIG"'
 t=. t rplc 'NODEBIN';nodebin;'JS';(p,'server.js');'CONFIG';p,'config.js'
 f=. p,'run.sh'
 r=. t fwrite f
 shell'chmod +x "',f,'"'
 ('nohup "PATHrun.sh" > "LOG" 2>&1' rplc 'PATH';p;'LOG';p,'logstd.log') fwrite p,'run.txt'
end. 

NB. create cert.pem and key.pem - mangled to avoid github warning
((fread JDP,'server/node/cert.napem')rplc 'XXXXXX';'CERTIFICATE') fwrite p,'cert.pem'
((fread JDP,'server/node/key.napem') rplc 'XXXXXX';'RSA PRIVATE KEY') fwrite p,'key.pem'

NB. copy node js source files
n=. 'server.js';'jds.js';'config.js';'server.html'
d=. fread each (<JDP,'server/node/'),each n
'bad file name'assert -.;_1-:each d
d fwrite each (<p,'/'),each n

p
)
