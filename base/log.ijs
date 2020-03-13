NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass'jd'

NB. '' shows index of 1st component and count of components
NB. 0 shows component 0
NB. 0 3 shows components 0 and 3
NB. x selects data row
jdlogijfshow=: 3 : 0
f=. jpath jdpath'log.ijf' NB. ignore damaged or bad jdclass
'log.ijf does not exist'assert fexist f
t=. jsize_jfiles_ f
if. -.1 4 e.~ 3!:0 y do.
 c=. ({.t)+i.1{t
 n=. >":each <"0 c
 n,.sptable {:"1 [2{."2 >jread_jfiles_ f;c
 return.
end.
jread_jfiles_ f;y
)

NB. last y lines of log.txt
jdlogtxtshow=: 3 : 0
f=. 'log.txt',~jdpath'' NB. ignore damaged or bad jdclass
'log.txt does not exist'assert fexist f
r=. fread f
i=. |.(LF=r)#i.#r
if. y>:#i do.
 r
else.
 '...',(y{i)}.r 
end.
)

logsentences=: 0 : 0
isotimestamp 6!:0''
OP
FETAB
FECOL
FEXTRA
FEER
13!:12''
jdlasty
showmap_jmf_''
)

NB. log and mark db as damaged
logijfdamage=: 3 : 0
3 logijf y
)

NB. x 0 log only - 1 log and echo - 2 log and error - 3 log and damage
NB. y 'revert';xtra_data
NB. create .ijf if it does not exist
NB. append log component
logijf=: 4 : 0
if. 0=#DB do. return. end.
try. f=. dbpath DB catchd. return. end.
if. -.fexist f,'/jdclass' do. return. end.
f=. jpath f,'/log.ijf'
a=. boxopen y
type=. ;{.a
xtra=. }.a
'logijf'logtxt type
r=. 1 2$'type';type
for_s. <;._2 logsentences do.
 try.
  r=. r,s,<".>s
 catchd.
  r=. r,s,<'failed: ',13!:12''
 end. 
end.
r=. r,'xtra';<xtra
if. -.fexist f do. jcreate_jfiles_ f end.
n=. (<,.r)jappend_jfiles_ f
select. x
case. 0 do. NB. log only
case. 1 do. NB. log and echo
 echo '!!! ',' !!!',~a
case. 2 do. NB. log and error
 a assert 0
case.   do. NB. log and damage
 jddamage type
end.
i.0 0
)

log_size_limit=: 16e6

NB. log to db log.txt or ~temp/jdlog/log.txt
NB. there is also a log_jdcsv_
logtxt=: 4 : 0
if. ('op'-:x)*.-.LOGOPS do. return. end.
try.
 f=. '/log.txt',~dbpath DB
catchd.
 f=. '~temp/jdlog/log.txt'
end.
logsize f
t=. (isotimestamp 6!:0''),' : ',12{.x
if. 0=L.y do.
 t=. t,y,LF
else.
 t=. t,LF,,(sptable y),.LF
end. 
t fappend f
)

NB. log to ~temp/jd.txt
NB. used by jdtests and other important logs (such as jddamage)
logjd=: 4 : 0
((isotimestamp 6!:0''),' : ',(12{.x),' : ',y,LF)fappend'~temp/jd.txt'
)

NB. limit log growth
logsize=: 3 : 0
if. fexist y do.
 if. log_size_limit<fsize y do.
  ((-<.0.5*log_size_limit){.fread y)fwrite y
 end.
end.
)

NB. jdtests log
logtest=: 4 : 0
mkdir_j_ '~temp/jdlog'
fn=. '~temp/jdlog/logtest.txt'
if. 'test start'-:x do. ''fwrite fn end. NB. kludge to clear test log file
logsize fn
((isotimestamp 6!:0''),' : ',(12{.x),' : ',y,LF)fappend fn
)

