NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. port/pid tools

pidfromport=: 3 : 0
select. UNAME
case. 'Linux' do.
 _1 ". ": shell_jtask_ :: _1: 'fuser -n tcp ',":y
case. 'Win' do.
 p=. _1 ". ": shell_jtask_ :: _1: 'for /f "tokens=5" %a in (''netstat -aon ^| find ":',(":y),'" ^| find "LISTENING"'') do echo %a'
 p-._1
case. 'Darwin' do.
end.
)

killport=: 3 : 0 
'must be single port'assert 1=#y
spid=: ":pidfromport y
select. UNAME
 case. 'Win' do. shell_jtask_'taskkill /f /pid ',spid
 case. do. shell_jtask_'kill ',spid
end.
''
)

NB. from jcs.ijs
pidfromport=: 3 : 0
p=. y
select. UNAME
case. 'Linux' do.
 t=. jpath'~temp/fuser.txt'
 try.
  d=. 2!:1'fuser -n tcp ',(":p),' > "',t,'" 2>&1'
 catch.
  0 2$0
  return.
 end.
 d=. fread t
 d=. d-. '/tcp:'
 d=. d rplc LF,' '
 d=. 0".d
 d=. (2,~2%~#d)$d
case. 'Darwin' do.
 d=. <;._2 [ 2!:0 'netstat -anv'
 b=. ;(<'tcp')-:each 3{.each d
 d=. deb each b#d
 d=. ><;._2 each d,each' '
 d=. ( (<'LISTEN')=5{"1 d )#d
 a=. 3{"1 d
 a=. ;0".each(>:;a i: each'.')}.each a
 d=. a,.;0".each 8{"1 d
 d=. (({."1 d) e. p)#d
case. 'Win' do.
 d=.  CR-.~each deb each <;._2 shell'netstat -ano -p tcp'
 b=. d#~;(<'TCP')-:each 3{.each d
 d=. ><;._2 each d,each' '
 d=. d#~(<'LISTENING')=3{"1 d
 a=. 1{"1 d
 a=. ;0".each(>:;a i: each':')}.each a
 d=. ;0".each 4{"1 d
 (a i. p){d,_1
end.
)

NB. check if jds server y is running and start it if not
check_jds=: 3 : 0
if. _1~:pidfromport y do. 'server already running' return. end.
f=. '~temp/jdserver/jds/65220/run.txt'
'run jdrt''jds'' first to set up server'assert fexist f
fork_jtask_ fread f NB. start server set up by jds tutorial
6!:3[0.2 NB. give task a chance to get started
'server failed to start' assert _1~:y=pidfromport y
'server has been started'
)