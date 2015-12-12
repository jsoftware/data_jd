NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass'jd'

NB. '' shows index of 1st component and count of components
NB. 0 shows component 0
NB. 0 3 shows components 0 and 3
NB. x selects data row
jdlogijfshow=: 3 : 0
f=. 'log.ijf',~0 jdpath'' NB. ignore damaged or bad jdclass
'log.ijf does not exist'assert fexist f
t=. jsize_jfiles_ f
if. -.1 4 e.~ 3!:0 y do.
 c=. ({.t)+i.1{t
 n=. >":each <"0 c
 n,.showbox_jd_ {:"1 [2{."2 >jread_jfiles_ f;c
 return.
end.
jread_jfiles_ f;y
)

NB. last y lines of log.txt
jdlogtxtshow=: 3 : 0
f=. 'log.txt',~0 jdpath'' NB. ignore damaged or bad jdclass
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
jd_list'version'
jd_info'summary'
jd_info'schema'
jd_info'dynamic'
jd_info'validate'
jd_info'validatebad'
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

NB. log_jd_ - there is also a log_jdcsv_
logtxt=: 4 : 0
try. f=. dbpath DB catchd. return. end.
if. -.fexist f,'/jdclass' do. return. end.
f=. f,'/log.txt'
t=. (isotimestamp 6!:0''),' : ',12{.x
if. 0=L.y do.
 t=. t,y,LF
else.
 t=. t,LF,,(showbox y),.LF
end. 
t fappend f
)
