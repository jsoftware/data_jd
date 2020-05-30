NB. Copyright 2018, Jsoftware Inc.  All rights reserved.
coclass'jd'

NB. admin lock routines

lockopen=: 3 : 0
y=. jpath y
if. IFWIN do.
 h=. 1!:21 <y
else.
 h=. (LIBC,' open > i *c i')cd y;2
end.
assert 0<h
h
)

lockclose=: 3 : 0
if. 0=y do. return. end.
if. IFWINE do. 1!:22 ::0: y return. end.
if. IFWIN do.
 1!:22 y
else.
 (LIBC,' close i i')cd y
end.
)

NB. define locklock/lockfree to get and release lock - minimize locked time
3 : 0''
if. IFWIN do.
 locklock=: 13 : '1!:31 y,0 2'
 lockfree=: 13 : '1!:32 y,0 2'
else.
 locklock=: 13 : '0=(LIBC,'' lockf > i i i i'')cd y,2 0' NB. F_TLOCK 2
 lockfree=: 13 : '0=(LIBC,'' lockf > i i i i'')cd y,0 0' NB. F_ULOCK 0
end.
i.0 0
)

NB. type lock file- return 1 success and 0 failure
NB. x - x (unlock), r (readonly), or w (read/write)
NB. y - path to jdlock file
NB. assert error if it fails
lock=: 4 : 0
f=. jpath y,'/jdlock'
'lock not a file' assert (2~:ftypex) f
if. ('x'~:{.x) *. -.fexist f do.'rw'fwrite f[jdcreatefolder y end.
lf=. (<f) e. {:"1 LOCKED
select. x

case.'w'do.
 if. lf do. return. end.
 h=. lockopen f
 if. locklock h do.
  LOCKED_jd_=: LOCKED,h;f
 else. 
  lockclose h
  assert 0['lock w failed - another task has database locked'
 end.
  
case.'r' do.
 if. lf do. 1 return. end.
 LOCKED_jd_=: LOCKED,0;f

case.'c' do.
 if. lf do. 1 return. end.
 LOCKED_jd_=: LOCKED,0;f

case.'x'do.
 if. lf do.
  i=. ({:"1 LOCKED)i.<f
  lockclose  ;{.i{LOCKED
  LOCKED_jd_=: LOCKED-.i{LOCKED
 end.
 
case. do.
 assert 0['lock not wrcx'
end. 
)

NB. replicate get/set end locks
NB. complications between file names, linux handles, and windows handles

NB. under lock, set value in end file
setrlogend=: 3 : 0
f=. RLOGFOLDER,'end'
s=. 3 ic fsize RLOGFH
h=. lockopen f
while. 1 do. if. locklock h do. break. end. 6!:3[0.001[RLOGBLOCK=: >:RLOGBLOCK end.
if. IFWIN>IFWINE do. s fwrite h else. s fwrite f end.
lockfree  h
lockclose h
)

NB. y is RLGOFOLDER
NB. under lock, read end file
getrlogend=: 3 : 0
f=. y,'end'
h=. lockopen f
while. 1 do. if. locklock h do. break. end.
 6!:3[0.001[RLOGBLOCK__dbl=: >:RLOGBLOCK__dbl
end.
if. IFWIN>IFWINE do. r=. fread h else. r=. fread f end.
lockfree  h
lockclose h
_3 ic r
)
