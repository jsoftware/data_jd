NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. nov 2025 - benchmark Jd for new server work

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

NB. task-count,beat-count
NB. task-count is number of tasks to spawn
NB. each task loads beat.ijs and runs beat[beat-count
beatit=: 3 : 0
req__CL'logon admin/funny'
req__CL'admin oplogdata_jd_=: '''''
'tasks count'=: y
'too many'assert tasks<7
for_i. i.tasks do.
 user=. 'userx/userx'rplc 'x';":i
 spawn_jtask_ t=: 'x-terminal-emulator -e " \"j9.6/bin/jconsole\" -js load\''~addons/data/jd/pm/server/beat.ijs\'' user=:\''',user,'\'' beat[',(":count),' "'
end. 
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

