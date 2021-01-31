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

NB. create run.sh
t=. '#!/bin/bash'
t=. t,LF,'fuser -s -k -n tcp PORT'
t=. t,LF,'"NODEBIN" "JS" "CONFIG"'
t=. t rplc 'PORT';sport;'NODEBIN';nodebin;'JS';(p,'/jdserver.js');'CONFIG';p,'/config.js'
f=. p,'run.sh'
r=. t fwrite f
shell'chmod +x "',f,'"'

NB. create cert.pem and key.pem - mangled to avoid github warning
((fread JDP,'server/node/cert.napem')rplc 'XXXXXX';'CERTIFICATE') fwrite p,'cert.pem'
((fread JDP,'server/node/key.napem') rplc 'XXXXXX';'RSA PRIVATE KEY') fwrite p,'key.pem'

NB. create run.txt - fork_jtask arg
('nohup "PATH/run.sh" > "LOG" 2>&1' rplc 'PATH';p;'LOG';p,'logstd.log') fwrite p,'run.txt'

NB. copy node js source files
n=. 'jdserver.js';'jds.js';'config.js';'http_jdserver.html'
d=. fread each (<JDP,'server/node/'),each n
'bad file name'assert -.;_1-:each d
d fwrite each (<p,'/'),each n

p
)
