NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. utils for starting jconsole tasks

coclass'jctask'

PID=: 2!:6''
PIDC=: ":PID
PATH=: jpath'~temp/jctask/'

mktmpdir=: 3 : 0
if. _1=nc<'unique' do. unique=: _1 end.
unique=: >:unique
PATH,(":2 !:6''),'-',":unique
)

hdr=: 0 : 0
(":2!:6'')fwrite 'DIR/pid.txt'
)

NB. [opt] jctask sentences
NB. opt is t for terminal or r for redirect
jctask=: 3 : 0
if. 0=L. y do. y=. 't';y end.
'opt d'=. y
'option must be t (terminal) or r (redirect)'assert opt e. 'tr'
dir=. mktmpdir''
mkdir_j_ dir
start=. dir,'/start.ijs'
d=. d,~hdr rplc 'DIR';dir
d fwrite start
if. 'Linux'-:UNAME do.
 if. 't'={.opt do.
  c=. 'x-terminal-emulator -e "\"/home/eric/j901/bin/jconsole\" \"START\""'
 else.
  c=. '"/home/eric/j901/bin/jconsole" "START" > "DIR/out.txt"'
 end.
 c=.  c rplc 'START';start;'DIR';dir
 echo c
 fork_jtask_ c 
end.
_1".(>: dir i:'-')}.dir
)

getstart=: 3 : 0
fread PATH,PIDC,'-',(":y),'/start.ijs'
)

getpid=: 3 : 0
fread PATH,PIDC,'-',(":y),'/pid.txt'
)

getoutput=: 3 : 0
fread PATH,PIDC,'-',(":y),'/out.txt'
)


NB. stuff from jcs

starttask=: 3 : 0 
'server'vaddress y
jc=. jpath'~bin/',('/usr/share/j/'-:13{.jpath'~install'){::'jconsole';'ijconsole'
d=. ('"','"',~hostpathsep jc),' ~addons/net/jcs/start.ijs  -js "start_jcs_ ''',(":y),'''"'
if. IFWIN do. winserver d else. fork_jtask_ d,' > /dev/null 2>&1' end.
jcsc y-.'*'
)

NB. windows createprocess
NB. fork_jtask_ leaves stdin/stdout hooked up
NB. following should be refactored into jtasks
NB. /S strips leading " and last " and leaves others alone
NB. win32 requires 104->68 ; 16->24 ; _2 ic 8{.pi -> _3 ic 16{.pi
winserver=: 3 : 0
'only valid on win64'assert IF64
CloseHandle=. 'kernel32 CloseHandle i x'&cd"0
CreateProcess=. 'kernel32 CreateProcessW i x *w x x i  i x x *c *c'&cd
f=. 16b08000000
c=. uucp 'cmd /S /C "',y,'"'
si=. (104{a.),104${.a.
pi=. 24${.a.
'r i1 c i2 i3 i4 f i5 i6 si pi'=. CreateProcess 0;c;0;0;0;f;0;0;si;pi
'createprocess failed'assert 0~:r
CloseHandle _3 ic 16{.pi
)
