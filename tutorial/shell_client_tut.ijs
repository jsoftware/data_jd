NB. server access from shell clients - windows bat and unix bash
load JDP,'server/client/jcurlclient.ijs' NB. curl tools
load JDP,'server/server1.ijs'
s1_build''
jdserver'server1';'start'

jdp1=: jdcurlclient 'localhost:3000' NB. build client folder with curl
jdcurlreq jdp1;'logon simple user0 pswd0' NB. access dan simple with user and pswd

bash_client=: 0 : 0
#!/bin/bash
# $1 path to j client folder, $2 command
printf %s "$2" > $1/post
$1/curl
cat $1/result
)

bat_client=: 0 : 0
rem %1 path to j client folder, %2 command
@echo %2 > %1\post
@call %1\curl > null
@type %1\result
)

3 : 0''
if. IFWIN do.
 name=: 'bat_client.bat'
 bat_client fwrite 'bat_client.bat'
 (fread jdp1,'/curl') fwrite jdp1,'/curl.bat'
else.
 name=: './bash_client.sh'
 bash_client fwrite 'bash_client.sh'
 shell 'chmod +x bash_client.sh'
 shell 'chmod +x ',jdp1,'/curl' NB. required to run from bash
end.
)

shellcmd=: 3 : 0
shell name,' ',(hostpathsep_j_ jdp1),' "',y,'"'
)

shellcmd'info schema'
shellcmd'read from t'

jdserver 'server1';'stop'
