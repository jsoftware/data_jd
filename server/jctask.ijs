NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. utils for starting jconsole tasks

coclass'jctask'

help=: 0 : 0
jconsole terminal task:
   tid=. run_jctask_ 't';'test1';'echo 444'
   tid get_jctask_ 'pid'
   tid get_jctask_ 'start.ijs'
   tid get_jctask_ 'description'
   killtid_jctask_ tid
   
jconsole redirect task (no terminal):
   tid=. run_jctask_ 'r';'test2';'echo 444'
   tid get_jctask_ 'pid'
   tid get_jctask_ 'start.ijs'
   tid get_jctask_ 'description'
   tid get_jctask_ 'out'
   killtid_jctask_ tid 
)   

0 : 0
host differences:

kill 't' task:
 linux - terminates task - closes window
 macos - terminates task - leaves widow open - display only
 win   - terminates task - closes window

'r' task:
 linux/macos eof would terminate task but windows does not
 addding TAIL sentence that run exit (as modified by HEAD) write exit.txt file and does 2!:55''
 
ps:
 linux - ps -C jconsole
 macos - ps ?
 win   - tasklist /FI "IMAGENAME" eq jconsole.exe
)

3 : 0''
if. _1=nc<'unique' do. unique=: 0 end.
)

PID=: 2!:6''
PATH=: jpath'~temp/jctask/'
JC=: jpath'~bin/',(1 e. '/share/j/' E. jpath'~install'){::'jconsole';'ijconsole'
TAIL=: LF,LF,'exit'''''

HEAD=: 0 : 0
(":2!:6'') fwrite 'PUpid'
tid_jctask_=: 'TID'
exit_z_ =: 3 : '2!:55[0[''''fwrite ''PUexit'''

)

HEADWIN=: 0 : 0 NB. win does not need to write pid
tid_jctask_=: 'TID'
exit_z_ =: 3 : '2!:55[0[''''fwrite ''PUexit'''

)

3 : 0''
if. 'Win'-:UNAME do. HEAD=: HEADWIN end.
)

NB. timestamp is pretty unique + pid + unique
mktaskid=: 3 : 0
unique=: >:unique
t=. (isotimestamp 6!:0''),' ',(":PID),' ',":unique
'_' ((t e. ' -:.')#i.#t)}t
)


NB.! brute force rmdir of jctask folder
NB. could/should be made smarter (jum validatepids)
clean=: 3 : 0
select. y
case.'all' do.
 killtid each {."1[1!:0 <PATH_jctask_,'*'
case.      do.
 'bad arg'assert 0
end.
i.0 0
)

NB. run type;description;sentences
NB. type is t for terminal or r for redirect
run=: 3 : 0
'type description d'=. y
'type must be t (terminal) or r (redirect)'assert type e. 'tr'
if. 1=L. d do. d=. ;d,each LF end.
term=. 't'=type
taskid=. mktaskid''
pu=. PATH,taskid,'/'
mkdir_j_ pu
pstart=. pu,'start.ijs'
((TAIL#~-.term),~d,~HEAD rplc 'PU';pu;'TID';taskid)fwrite pstart
pout=. pu,'out'

select. UNAME
case. 'Linux' do.
 if. term do.
  c=. 'x-terminal-emulator -e "\"JC\" \"START\""'
 else.
  c=. '"JC" "START" > "OUT"'
 end.
 c=.  c rplc 'JC';JC;'START';pstart;'OUT';pu,'out'
 fork_jtask_ c

case. 'Darwin' do.
 if. term do.
  ('#!/bin/sh',LF,'"',JC,'" "',pstart,'"')fwrite pu,'/launch.command'
  shell'chmod +x ',pu,'/launch.command'
  c=. 'open -a /Applications/Utilities/Terminal.app "PU/launch.command"'
 else.
  c=. '"JC" "START" > "OUT"'
 end.
 c=.  c rplc 'JC';JC;'START';pstart;'PU';pu;'OUT';pu,'out'
 fork_jtask_ c
 
case. 'Win' do.
 if. term do.
  c=. '"JC" "START"'
 else.
  c=. '"JC" "START" > "OUT"'
 end.
 c=.  c rplc 'JC';(hostpathsep JC);'START';(hostpathsep pstart);'OUT';pu,'out'
 pid=. term winserver c
 (":pid) fwrite pu,'pid'
 'task did not start' assert _1-.@-:pid
end.

if. -.'Win'-:UNAME do.
 NB. unix starts need to give the task a chance to run
 for_i. >:i.10 do.   NB. +/0.2*>:i.10 is total delay of 11 seconds
  6!:3[i*0.2         NB. give task a chance to run
  t=. fread pu,'pid'
  if. -.t-:_1 do. break. end.
 end.
 'task did not start'assert -._1-:t
 t fwrite pu,'pid'
end.

type fwrite pu,'/type'
description fwrite pu,'/description'
taskid
)

NB. taskid get name
get=: 4 : 0
'invalid taskid' assert fexist PATH,x,'/start.ijs'
fread PATH,x,'/',y
)

report=: 3 : 0
p=. {."1[1!:0 <PATH,'*'
p=. p#~'.'~:;{.each p
time=. (<'-- ::.') 4 7 10 13 16 19}each 23{.each p
a=. p,~each<PATH
type=. ":each fread each a,each<'/type'
d=.    ":each fread each a,each<'/description'
pid=.  ":each fread each a,each<'/pid'
dead=. -.;checktaskid each p
exit=. ;fexist each a,each<'/exit'
status=. (2*dead)-exit
status=. status{'run ';'exit';'dead'
h=. ;:'red pid tid timestamp t desc'
h,(/:time){status,.pid,.p,.time,.type,.d
)

NB. killtaskid taskid - kill pid and remove jctask folder
NB. result 1 if pid was killed or was already dead
killtid=: 3 : 0
r=. 1 NB. 1 if pid has already been killed
if.  checktaskid y do.
 pid=. y get 'pid'
 try.
  if. IFWIN do.
   r=. 'SUCCESS:'-:8{. shell 'taskkill /f /pid ',pid
  else.
   r=. ''-:shell 'kill ',pid
  end.
 catch.
 end.
end. 
rmdir_j_ PATH,y
r
)

NB. return 1 if taskid still running
checktaskid=: 3 : 0
select. UNAME
case. 'Linux' do.
 a=. <;._2 shell 'ps -e -o pid -o command'
 #a#~;+/each (<PATH,y,'/start.ijs') E. each a
case. 'Darwin' do.
 a=. <;._2 shell 'ps -e -o pid -o command'
 t=. }.PATH NB. PATH Users vs users
 t=. (t i.'/')}.t
 #a#~;+/each (<t,y,'/launch.command') E. each a
case. 'Win'    do.
 a=. <;._2 shell'wmic process where "name like ''jconsole.exe''" get processid,commandline'
 #a#~;+/each (<hostpathsep PATH,y,'/start.ijs') E. each a
case.          do. assert 0
end.
)

NB. stuff from jcs/jum modified
3 : 0''
if. 'Win'-:UNAME do.
 CloseHandle=: 'kernel32 CloseHandle i x'&cd"0
 CreateProcess=: 'kernel32 CreateProcessW i x *w x x i  i x x *c *c'&cd
 CREATE_NO_WINDOW=:   16b8000000
 CREATE_NEW_CONSOLE=: 16b00000010
end. 
)

NB. result is pid or _1
NB. x 1 for terminal 
NB. windows createprocess
NB. fork_jtask_ leaves stdin/stdout hooked up
NB. following should be refactored into jtasks
NB. /S strips leading " and last " and leaves others alone
NB. win32 requires 104->68 ; 16->24 ; _2 ic 8{.pi -> _3 ic 16{.pi
NB. ProcessInfo dwProcessid is pid of cmd.exe parent
NB. wmic gets child probess for the parent
winserver=: 4 : 0
'only valid on win64'assert IF64
f=. x{CREATE_NO_WINDOW,CREATE_NEW_CONSOLE
c=. uucp 'cmd /S /C "',y,'"'
si=. (104{a.),104${.a.
pi=. 24${.a.
'r i1 c i2 i3 i4 f i5 i6 si pi'=. CreateProcess Q__=: 0;c;0;0;0;f;0;0;si;pi
'createprocess failed'assert 0~:r
CloseHandle _3 ic 16{.pi
ppid=. _2 ic 4{.16}.pi
pid=. shell'wmic process where (ParentProcessId=',(":ppid),') get ProcessId'
_1".;1{<;._2 pid-.CR
)
