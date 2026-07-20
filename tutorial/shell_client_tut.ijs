NB. server access from shell clients - windows bat and unix bash
load JDP,'test/util/simple.ijs'
simple_play''

jdp1=: jdcurlclient_jd_ 'localhost:3000' NB. build client folder with curl

bash_client=: 0 : 0
#!/bin/bash
# $1 path to j client folder, $2 jdcmd [, $3 nodecmd ]
if [[ "$2" =~ ^[^[:alpha:]]*([[:alpha:]]+) ]]; then
    op="${BASH_REMATCH[1]}"
fi
printf '%s\n%s;op %s' "$2" "$3" "$op" > $1/post
$1/curl
cat $1/result
)

NB.!!! needs work
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
arg=. }.;' ',each '''',~each'''',each boxopen y
cmd=. name,' ',(hostpathsep_j_ jdp1),' ',arg
techo cmd
shell cmd
)

shellcmd '';'logon simple user0 pswd0'
shellcmd 'info schema';''
shellcmd '["insert t","a",45]';''
shellcmd 'read from t';''

jdserver 'simple';'stop'
jdnode   'simple';'stop'
