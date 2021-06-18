NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. port/pid tools

require'~addons/ide/jhs/port.ijs'

NB. check if jds server y is running and start it if not
check_jds=: 3 : 0
if. _1~:pidfromport_jport_ y do. 'server already running' return. end.
f=. '~temp/jdserver/jds/',(":y),'/run.txt'
'run jdrt''jds'' first to set up server'assert fexist f
fork_jtask_ fread f NB. start server set up by jds tutorial
6!:3[0.2 NB. give task a chance to get started
'server failed to start' assert _1~:y=pidfromport_jport_ y
'server has been started'
)