NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. utils for starting jconsole tasks

coclass'jctask'

0 : 0
host differences:

kill 't' task:
 linux - terminates task - closes window
 macos - terminates task - leaves widow open - display only
 win   - terminates task - closes window

'r' task:
 linux - eof terminates task
 macos - eof terminates task
 win   - eof does not terminate task - adding exit'' to the end works

 fix - add TAIL (exit'') at end of file for all platforms
 
ps:
 linux - ps -C jconsole
 macos - ps ?
 win   - tasklist /FI "IMAGENAME" eq jconsole.exe
)

PID=: 2!:6''
PIDC=: ":PID
PATH=: jpath'~temp/jctask/'
JC=: jpath'~bin/',('/usr/share/j/'-:13{.jpath'~install'){::'jconsole';'ijconsole'
HEAD=: '(":2!:6'''')fwrite ''DIR/pid.txt''',LF
TAIL=: LF,'exit'''''

NB.! brute force rmdir of jctask folder
NB. could/should be made smarter (jum validatepids)
clean=: 3 : 'i.0 0[rmdir_j_ }:PATH'

mktmpdir=: 3 : 0
if. _1=nc<'unique' do. unique=: _1 end.
unique=: >:unique
PATH,(":2 !:6''),'-',":unique
)

NB. jctask opt;sentences
NB. opt is t for terminal or r for redirect
jctask=: 3 : 0
if. 0=L. y do. y=. 't';y end.
'opt d'=. y
'option must be t (terminal) or r (redirect)'assert opt e. 'tr'
term=. 't'={.opt
dir=. mktmpdir''
mkdir_j_ dir
start=. dir,'/start.ijs'
((TAIL#~-.term),~d,~HEAD rplc 'DIR';dir)fwrite start

select. UNAME
case. 'Linux' do.
 if. term do.
  c=. 'x-terminal-emulator -e "\"/home/eric/j901/bin/jconsole\" \"START\""'
 else.
  c=. '"/home/eric/j901/bin/jconsole" "START" > "DIR/out.txt"'
 end.
 c=.  c rplc 'START';start;'DIR';dir
 fork_jtask_ c 

case. 'Darwin' do.
 if. term do.
  ('#!/bin/sh',LF,'"',JC,'" "',start,'"')fwrite dir,'/launch.command'
  shell'chmod +x ',dir,'/launch.command'
  c=. 'open -a /Applications/Utilities/Terminal.app "DIR/launch.command"'
 else.
  c=. '"JC" "START" > "DIR/out.txt"'
 end.
 c=.  c rplc 'JC';JC;'START';start;'DIR';dir
 fork_jtask_ c
 
case. 'Win' do.
 if. term do.
  c=. '"JC" "START"'
 else.
  c=. '"JC" "START" >"DIR/out.txt"'
 end.
 c=.  c rplc 'JC';(hostpathsep JC);'START';start;'DIR';dir
 term winserver c
end.
_1".(>: dir i:'-')}.dir
)

getstart=: 3 : 0
fread PATH,PIDC,'-',(":y),'/start.ijs'
)

getpid=: 3 : 0
fread PATH,PIDC,'-',(":y),'/pid.txt'
)

getout=: 3 : 0
fread PATH,PIDC,'-',(":y),'/out.txt'
)

NB. return 1 for success
kill=: 3 : 0
pid=. ":getpid y
if. IFWIN do.
 'SUCCESS:'-:8{.shell 'taskkill /f /pid ',pid
else.
 shell 'kill ',pid
end. 
)

NB. stuff from jcs/jum modified

3 : 0''
CloseHandle=: 'kernel32 CloseHandle i x'&cd"0
CreateProcess=: 'kernel32 CreateProcessW i x *w x x i  i x x *c *c'&cd
CREATE_NO_WINDOW=:   16b8000000
CREATE_NEW_CONSOLE=: 16b00000010
)

NB. x 1 for terminal 
NB. windows createprocess
NB. fork_jtask_ leaves stdin/stdout hooked up
NB. following should be refactored into jtasks
NB. /S strips leading " and last " and leaves others alone
NB. win32 requires 104->68 ; 16->24 ; _2 ic 8{.pi -> _3 ic 16{.pi
winserver=: 4 : 0
'only valid on win64'assert IF64
f=. x{CREATE_NO_WINDOW,CREATE_NEW_CONSOLE
c=. uucp 'cmd /S /C "',y,'"'
si=. (104{a.),104${.a.
pi=. 24${.a.
'r i1 c i2 i3 i4 f i5 i6 si pi'=. CreateProcess 0;c;0;0;0;f;0;0;si;pi
'createprocess failed'assert 0~:r
CloseHandle _3 ic 16{.pi
)
