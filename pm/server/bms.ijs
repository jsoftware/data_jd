NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. nov 2025 - benchmark Jd for new server work

NB. time multiple tasks doing read for server1

0 : 0
node performance

node server.keepAlive= 10000;
curl --keepalive-time 10

node-loop (no call to jd) makes little diference on localhost
beatit 4;500;'localhost' 69 vs 56
so the time is in curl access to node
)

NB. task-count;beat-count;host
NB. 2;100;'localhost'
NB. task-count is number of tasks to spawn
NB. each task loads beat.ijs and runs beat[beat-count
beatit=: 3 : 0
ferase 'beatit.txt'
'tasks count host'=: y
'too many'assert tasks<32
for_i. i.tasks do.
 NB.spawn_jtask_ t=: 'x-terminal-emulator -e " \"j9.6/bin/jconsole\" -js load\''~addons/data/jd/pm/server/beat.ijs\'' beat[',(":count),' "'
 fork_jtask_ t=: ('j9.6/bin/jconsole -js load\''~addons/data/jd/pm/server/beat.ijs\'' host=:\''<HOST>\'' beat[',(":count)) rplc '<HOST>';host
end. 
while. 1 do.
 6!:3[5
 d=. fread 'beatit.txt'
 if. tasks=+/LF=d do. break. end.
end. 
<.0.5+;0".each<;._2 d
)

cnt=: 500

beatserver=: 3 : 0
echo'server.jsoftware.com'
jds1=: (jdclient 'server.jsoftware.com:3000')&jdreq
jds1'logon simple u u'
echo jds1'list version'
a=. 6!:9''
i=. 0
while. i<cnt do.
 jds1'list version'
 i=. i+1
end. 
z=. 6!:9''
cnt%(z-a)%6!:8''
)

beatlocalserver=: 3 : 0
echo'localhost'
jdadmin 0
jdserver'server1';'start'
jds1=: (jdclient 'localhost:3000')&jdreq
jds1'logon simple u u'
echo jds1'list version'
a=. 6!:9''
i=. 0
while. i<cnt do.
 jds1'list version'
 i=. i+1
end. 
z=. 6!:9''
cnt%(z-a)%6!:8''
)


NB. rd ops with local jd
beatlocal=: 3 : 0
jdserver'server1';'stop'
jdadmin'simple'
a=. 6!:9''
i=. 0
while. i<1000 do.
 jd'list version'
 i=. i+1
end. 
z=. 6!:9''
1000%(z-a)%6!:8''
)

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


NB. build and start server for bmserver db
run_bms=: 3 :0
sj=: 'jdserver/bms'conew'jdserver' NB. server config at folder jd/test
delete__sj'' NB. delete any old stuff
config__sj 3000;65220;'bmserver'

uj=: 'jdserver'conew'jdup'
adduser__uj 'admin/funny'

for_i. i.6 do.
 adduser__uj 'userx/userx' rplc 'x';":i
end. 

kill__sj''   NB. kill old ports/tasks
run__sj 1

echo '   man''  jd  client'' NB. starting another client task'
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

NB. rate 1000#<'read sum b from t where a=5'  NB.  341
NB. rate 1000#<'read sum b from t where a=15' NB. 1370 - empty result
rate=: 3 : 0
(#y)% timex 'jd each y'
)

