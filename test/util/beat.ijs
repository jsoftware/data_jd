NB. tools for beating on servers

NB. implicit args
NB. 'https://host:port'
NB. LOGON=: 'logon simple user0 pswd0'

NB. assumes server is running at URL and LOGON is valid

beatsnk=: '~temp/beat'

beatclear=: 3 : 0
rmsub_jd_ beatsnk
mkdir_j_ jpath beatsnk
)

beatwrite=: 3 : 0
y fwrite beatsnk,'/',(":2!:6''),'.txt'
)

beatread=: 3 : 0
d=. fread each 1 dir beatsnk
(>:;d i. each LF){.each d
)

NB. * tasks ; cnt ; ops
NB. * 2;1000;'' NB. node call with no jd call
NB. * 2;1000;'list version'
NB. * 2;1000;'read from t'
NB. * 2;1000;<ops
NB. tasks is number of tasks to run
NB. cnt is number of jd ops to run from ops
NB. ops is 1 or more jd ops
NB. fork tasks and wait for all tasks to complete (write to beatsnk/pid.txt
NB. URL and LOGON are implicit args
NB. time multiple tasks doing ops on server
NB. windows fappend is not safe between tasks - so each task writes to pid.txt
NB. each task loads beat.ijs and runs beattask[0
NB. each task writes its result to ~temp/beat/pid.txt
NB. the pid.txt files are reported
beat=: 3 : 0
'tasks cnt ops'=. y
'too many tasks'assert tasks<80
(3!:1 JDP;tasks;cnt;'https://localhost:3000';LOGON;<boxopen ops)fwrite 'beat'
beatclear''
for_i. i.tasks do.
 beatrun ' -js load\''',JDP,'test/util/beat.ijs\'' beattask[0 > /dev/null 2>&1'
end.
while. 1 do.
 6!:3[1
 if. tasks=#1 dir beatsnk do. break. end. NB. wait for all tasks to finish
end. 
d=. fread each 1 dir beatsnk
t=. ;_1".each d
if. _1 e. t do.
 ;(>:;d i. each LF){.each d
else.
 +/;t
end. 
NB. if. 'Jd error'+./@:E.d do. d return. end.
)

NB. forked run to beat on a server - write to beatsnk/pid.txt
beattask=: 3 : 0
'JDP tasks cnt url logon ops'=: 3!:2 fread 'beat'
load JDP,'jd.ijs'
jds1=. url jdclient
try.
  logon jds1''
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
  r=. ":<.cnt%(z-a)%6!:8''
catch. 
 r=. 13!:12''
end.
beatwrite r
'logoff'jds1''
exit''
)

NB. fork server to run op and write result to beatsml/pid.txt - does not wait for result
beatone=: 3 : 0
(3!:1 JDP;URL;LOGON;<boxopen y)fwrite 'beat'
beatclear''
beatrun ' -js load\''',JDP,'test/util/beat.ijs\'' beatonetask[0 > /dev/null 2>&1'
)

beatrun=: 3 : 0
a=. y
if. IFWIN do. a=. y rplc '\''';'''';'/dev/null';'NULL' end.
jdfork_jd_ t__=:(hostpathsep jpath'~bin/jconsole'),a
)

NB. run op in forked task and write result to beatsnk/pid.txt
beatonetask=: 3 : 0
'JDP url logon ops'=: 3!:2 fread 'beat'
load JDP,'jd.ijs'
jds1=. url jdclient
logon jds1''
d=. 'eok'jds1 ;{.ops
beatwrite 3!:1 d
exit''
)

NB. wait to get result from beatone
beatoneresult=: 3 : 0
while. 0=#1 dir beatsnk do. 6!:3[1 end.
d=. ;fread ;{.1 dir beatsnk
'not an op result'assert 227=a.i.{.d
3!:2 d
)
