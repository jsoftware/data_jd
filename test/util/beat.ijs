NB. tools for beating on servers

NB. implicit args
NB. URL=:   '' NB. 'https://host:port'
NB. LOGON=: 'logon simple user0 pswd0'

NB. assumes server is running at URL and LOGON is valid

NB. * tasks ; cnt ; ops
NB. * 2;1000;'' NB. node call with no jd call
NB. * 2;1000;'list version'
NB. * 2;1000;'read from t'
NB. * 2;1000;<ops
NB. tasks is number of tasks to run
NB. cnt is number of jd ops to run from ops
NB. ops is 1 or more jd ops
NB. URL and LOGON are implicit args
NB. time multiple tasks doing ops on server
NB. each task loads beat.ijs and runs beattask[0
NB. beat.txt has task info
NB. beat.txt has line per task if 1~:task,cnt
NB. in which case beat.txt is reported
beat=: 3 : 0
'windows fork needs work'assert IFUNIX
'tasks cnt ops'=. y
'too many tasks'assert tasks<80
(3!:1 JDP;tasks;cnt;URL;LOGON;<boxopen ops)fwrite 'beat'
ferase 'beat.txt'
for_i. i.tasks do.
  a=. ' -js load\''',JDP,'test/util/beat.ijs\'' beattask[0 > /dev/null 2>&1'
  fork_jtask_ t=: (jpath'~bin/jconsole'),a
end.
while. 1 do.
 6!:3[1
 d=. fread 'beat.txt'
 if. tasks=+/LF=d do. break. end. NB. wait for all tasks to finish
end. 
if. 'Jd error'+./@:E.d do. d return. end.
+/;{.each 0".each<;._2 d
)

NB. forked run to beat on a server - fappend ops/second to 'beat.txt'
beattask=: 3 : 0
'JDP tasks cnt url logon ops'=: 3!:2 fread 'beat'
load JDP,'jd.ijs'
jds1=. url jdclient
logon jds1''
try.
  a=. 6!:9''
  i=. 0
  while. i<cnt do.
   op=. ;(?#ops){ops
   select. op
   case. 'INSERT' do. op=. 'insert t';'a';0".(6j0 ": i,2!:6'')rplc' ';'0'
   end.
   jds1 op
   i=. i+1
  end. 
  z=. 6!:9''
  r=. cnt%(z-a)%6!:8''
  r=. LF,~6j0":0.5+r
catch. 
 r=. LF,~(6j0":0),' ',(13!:12'')rplc LF;{.a.
end. 
'logoff'jds1''
r fappend'beat.txt' 
exit''
)

NB. fork server, run op, and write result to beat.txt
beatone=: 3 : 0
'windows fork needs work'assert IFUNIX
(3!:1 JDP;URL;LOGON;<boxopen y)fwrite 'beat'
ferase 'beat.txt'
a=. ' -js load\''',JDP,'test/util/beat.ijs\'' beatonetask[0 > /dev/null 2>&1'
fork_jtask_ t=: (jpath'~bin/jconsole'),a
)

NB. run op in forked task and write result to beat.txt
beatonetask=: 3 : 0
'JDP url logon ops'=: 3!:2 fread 'beat'
load JDP,'jd.ijs'
jds1=. url jdclient
logon jds1''
d=. 'eok'jds1 ;{.ops
(3!:1 d)fappend 'beat.txt'
exit''
)

NB. get result from beatone
beatoneresult=: 3 : 0
while. _1=d=. fread'beat.txt' do. 6!:3[1 end.
'not an op result'assert 227=a.i.{.d
3!:2 d
)
