NB. rebuild server1 from scratch
load JDP,'server/client/jcurlclient.ijs'
load JDP,'server/server1.ijs'
s1_start''
s1'free' NB. free libcurl locale connection

NB. server access from shell clients - windows bat and unix bash
NB. j client folder could be built, but for now we just use a j client folder
jdp1=: jdclient 'localhost:3000'
jdreq jdp1;'logon simple user0 user0' NB. access dan simple with user and pswd

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

shell name,' ',(hostpathsep_j_ jdp1),' "info schema"'

shellcmd=: 3 : 0
shell name,' ',(hostpathsep_j_ jdp1),' "',y,'"'
)

shellcmd'read from t'
