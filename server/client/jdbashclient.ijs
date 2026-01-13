NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. bash curl access jd server

NB. connect=$(./jdbashconnect.sh all user0/user0 localhost:3000)
NB. ./jdbashreq.sh $connect '"info schema"'
NB. echo "\"read from t\"" > temp ; ./jdbashreq.sh $connect @temp
NB. ./jdbashclose.sh $connect 

coclass'jdbash' NB. hide everything

jdhelp=: 0 : 0
read -r -d '' help <<EOF
$ connect=\$(.../jdconnect.sh all user0/user0 localhost:3000)
   create connect folder in same folder as jdconnect.sh
   connect folder has files used in accessing server
   connect folder deleted if curl or logon fail
   $connect on success is path to connect folder or on failure is empty

$ .../jdreq.sh \$connect '"info schema"'
$ echo '"info summary"' > foo
$ jdreq.sh \$connect @foo

$ .../jdclose.sh \$connect
   logoff and delete connect folder

$ .../jdhelp.sh
EOF
echo "$help"
)

jdconnect=: 0 : 0
#!/bin/bash
set -eu
quit(){
 if [ -f "$p/jdclass" ]; then rm -r $p; fi
 exit 1;
}
if [ $# -ne 3 ]; then echo "jdconnect: incorrect number of arguments" >&2; exit 1; fi
p="$(dirname $(realpath -s $0))"/"$(uuidgen)/"
mkdir -p $p
echo "jdclient" > $p/jdclass
echo $1 > $p/dan
echo $3 > $p/host
result=$p/resultfile
cookie=$p/cookie
curl --no-progress-meter -k --data-binary "+ \"logon $2\"" -o $result -c $cookie -X POST -H Content-Type:application/octet-stream https://$3 2> $p/stderr || true
if [ -s $p/stderr ]; then  cat "$p/stderr" >&2; quit; fi
awk -F'\t' -v name="jds_cookie" '($6 == name) {printf "%s",$7}' $p/cookie > $p/cookievalue
if [ ! -s $p/cookievalue ]; then  echo "logon failed" >&2; quit; fi
echo $p # path to connect folder
)

jdreq=: 0 : 0
#!/bin/bash
if [ ! -f "$1/jdclass" ]; then echo "bad connect folder"; exit 1; fi
post=$1/postfile
result=$1/resultfile
resultlz4=$1/resultfile.lz4
cookie=$1/cookie
host=$(cat $1/host)
dan=$(cat $1/dan)
arg=$2
if [[ "@" !=  "${2:0:1}" ]]; then echo $2 > $1/temp; arg=@$1/temp ; fi
printf "%s " $dan >  $post
lz4 -f -q -c "${arg:1}" >> $post
curl --no-progress-meter -k --data-binary @$post -o $resultlz4 -b $cookie -c $cookie -X POST -H Content-Type:application/octet-stream https://$host 2> $1/stderr || true
if [ -s $1/stderr ]; then  cat "$1/stderr" >&2; fi
read -n1 char <"$resultlz4"
if [[ "$char" == "{" ]]; then cp $resultlz4 $result; else lz4 -d -f -q $resultlz4 $result; fi
cat $result
)

jdclose=: 0 : 0
#!/bin/bash
set -eu
if [ ! -f "$1/jdclass" ]; then echo "bad connect folder"; exit 1; fi
if [ -f "$1/cookie" ]; then
 result=$1resultfile
 cookie=$1cookie
 host=$(cat $1/host)
 curl --no-progress-meter -k --data-binary "+ \"logoff\"" -o $result -b $cookie -X POST -H Content-Type:application/octet-stream https://$host || true
fi
rm -r $1
)

NB. ERR vs EXIT - BASH_LINENO
test=: 0 : 0
#!/bin/bash
set -eu
cleanup() {
 local a="$?" ; local b="$BASH_LINENO "; c="$BASH_COMMAND"
 echo "$a $b $c" >&2
 if [ -f "$connect/jdclass" ]; then rm -r $connect; fi 
}
trap cleanup EXIT

connect=$(./jdbashconnect.sh all user0/user0 localhost:3000)
exit 25
./jdreq.sh $connect '"info summary"'
)

NB. * path-node-server-files
createsh=: 3 : 0
jdclientfolder=. jpath'~/jdclient/bash/'
mkdir_j_ jdclientfolder
d=. <;._2 scripts
for_a. d do.
 n=. ;a
 f=. jdclientfolder,n,'.sh'
 (".n) fwrite f
 shell'chmod +x ',f
end.
t=. ;' ',~each(#jdclientfolder)}.each<;._2 shell 'ls ',jdclientfolder,'*.sh'
shell 'tar -cf bash.tar -C ',jdclientfolder,' ',t
(fread 'bash.tar')fwrite y,'bash.tar'
)

scripts=: 0 : 0
jdhelp
jdconnect
jdreq
jdclose
)

createsh''
