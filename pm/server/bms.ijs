NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. nov 2025 - benchmark Jd for new server work

0 : 0
performance for different types of access - rps - ops/seconds

ideas for perfommance beyond individual ops
1. s1'each';(<'info summary'),(<'info schema'),<'list version' NB. request with multiple ops
   
2. procedure - custom op with custom arg and result
3. program run on server with localhost access

jd direct rps 12416

***
  beatit 10;'http:localhost:3002'

  runall''
┌───────┬──────────────────────┬─────────────────────┬─────────────────────────────────┬─────────────────────┐
│       │https://localhost:3000│http://localhost:3002│https://server.jsoftware.com:3000│http://localhost:3003│
├───────┼──────────────────────┼─────────────────────┼─────────────────────────────────┼─────────────────────┤
│libcurl│      910             │      912            │        7                        │        6            │
├───────┼──────────────────────┼─────────────────────┼─────────────────────────────────┼─────────────────────┤
│curl   │       91             │      119            │        5                        │       10            │
├───────┼──────────────────────┼─────────────────────┼─────────────────────────────────┼─────────────────────┤
│ab     │      365             │     1308            │        7                        │        7            │
└───────┴──────────────────────┴─────────────────────┴─────────────────────────────────┴─────────────────────┘
)

cnt=: 100
op=: 'list version'

NB. remote server http access is through tunnel local 3003 -> remote 3002
tunnel=: 3 : 0
fork_jtask_ 'ssh -i ~/.ssh/jhs1-kp.pem -N -L 3003:localhost:3002 ec2-user@54.88.234.170'
)

NB. rps for op on server
beat=: 3 :0
a=. 6!:9''
i=. 0
while. i<cnt do.
 jds1 op
 i=. i+1
end. 
z=. 6!:9''
9j0 ":<.cnt%(z-a)%6!:8''
)

NB. jd direct ops withtout server
direct=: 3 : 0
jdserver'server1';'stop'
jdadmin'simple'
a=. 6!:9''
i=. 0
while. i<cnt do.
 jd op
 i=. i+1
end. 
z=. 6!:9''
jdadmin 0
<.cnt%(z-a)%6!:8''
)

runall=: 3 : 0
h=. ,:'';urls
h=. h,'libcurl';libcurl each i.4
h=. h,'curl';curl each i.4
h=. h,'ab';ab each i.4
)

NB. localhost:3003 is tunnel to http://remote:3002
urls=: <;._2 [0 : 0
https://localhost:3000
http://localhost:3002
https://server.jsoftware.com:3000
http://localhost:3003
)

NB. y{urls
libcurl=: 3 : 0
'tunnel required'assert -.(3=y)*._1=getpid_jport_ 3003
jds1=: (;y{urls)jdcdefine
jds1 'logon simple u u' NB. admin user can execute j sentences
r=. beat''
jds1'free'
r
)

curl=: 3 : 0
require JDP,'server/client/jcurlclient.ijs'
a=. ;y{urls
b=. (3+a i.':')}.a
jdp1=: jdclient b
jds1=: jdp1&jdreq
n=. jdp1,'/curl'

if. 'http:'-:5{.a do. ((fread n)rplc'https://';'http://')fwrite n end. 

jds1'logon simple u u'
r=. beat''
jds1'logoff'
r
)

get_ab_rps=: 3 : 0
d=. <;._2 y
t=. 'Requests per second:'
r=. ;d#~(<t)=(#t){.each d
r=. dltb (#t)}.r
r=. 9j0 ":<.0.5+0".(r i.' '){.r
)

ab=: 3 : 0
'' fwrite 'ab.jnk'
a=. 'ab -n 100 -c 1 -p ab.jnk -T application/octet-stream ','/',~;y{urls
get_ab_rps shell a
)

NB. time multiple tasks doing op on server
NB. * task-count;url
NB. * 3;'https://localhost:3000'
NB. task-count is number of tasks to spawn
NB. each task loads beat.ijs and runs beat[0
beatit=: 3 : 0
ferase 'beatit.txt'
'tasks url'=: y
'too many'assert tasks<32
for_i. i.tasks do.
 a=. ' -js load\''',JDP,'pm/server/beat.ijs\'' url=:\''<URL>\'' beat[10 ' rplc '<URL>';url
 spawn_jtask_ t=: 'x-terminal-emulator -e " \"j9.6/bin/jconsole\" ',a,'"'
 NB. fork_jtask_ t=: 'j9.6/bin/jconsole ',a
end. 
while. 1 do.
 6!:3[5
 d=. fread 'beatit.txt'
 if. tasks=+/LF=d do. break. end.
end. 
<.0.5+;0".each<;._2 d
)

NB. misc junk probably not used after here

geninsert=: 3 : 0
r=. 'c';'abc'
for_i. i.20 do.
 r=. r,('a',":i);y
end.
)

bmstime=: 3 : 0
echo timex 'jd''read from t where a0<10 || a1<10 || a2<10'''
a=. geninsert 3$5
echo timex '   jd''insert t'';a'
)

NB. timings from server oplogdata
getoplog=: 3 : 0
req__CL'logon admin/funny'
req__CL'admin oplogdata_jd_'
)

ROWS=: 1e6 NB. #rows
REPS=: 10  NB. duplicates

data=: ROWS$i.REPS
databyte=: (ROWS,10)$'ab⇒defqwr'

admin_bms=: 0 : 0
'all' jdadminfp ''    NB. all DAN uses DB that contains this script
'all' jdadminup 'user0 user1 user2 user3 user4 user5' NB. users allowed access
'all' jdadminop '*'   NB. ops allowed

'ro'  jdadminfp ''
'ro'  jdadminup 'user0'
'ro'  jdadminop 'info read reads'
)

build_bms=: 3 : 0
jdadminnew'bms'
c=. getdb_jd_''
admin_bms fwrite PATH__c,'admin.ijs'
jd'createtable t'
for_i. i.20 do.
 jd('createcol t a',(":i),' int');i.ROWS
end. 
jd'createcol t c byte 10';databyte
i.0 0
)
