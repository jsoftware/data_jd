NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
coclass 'jd'

NB. datetime epoch

NB. e unix style epoch but in nanoseconds with 2000-01-01 base
NB. s iso 8601 (relaxed/stricter rules)

NB. conversion utils preserve rank

NB. e from s
NB. efs '2014-06-07T08:09:10.123456789+05'
NB. efs '2014-06-07T08:09:10.123Z'
NB. efs '2014-06-07T08:09:10.123'
NB. efs '2014-06-07T08:09:10+05'
NB. efs '2014-06-07'
NB. delimiter (-T:+-Z or blank) ends field, but is not validated
NB. 7:8:9 treated same as 07:08:09
NB. x is allow errors, ignore offset, return offset

NB. x is from d039
efs=: 3 : 0
'9' efs y NB. changed (with 6!:17) to allow errors
:
s=. $y
p=. }:s
rows=. */p
cols=. {:s
r=. (LIBJD_jd_,' efs x x x *c *x *x x')cd rows;cols;((rows,cols) ($,) y);(rows$-1);(<0);0
d=. p$>4{r
b=. d~:IMIN NB. don't adjust bad values
select. x
case. 'd' do. d=. d-b*(86400*1e9)|d
case. '0' do. d=. d-b*1e9|d
case. '3' do. d=. d-b*1e6|d
case. '9' do.
end.
d
)

NB. s from e - efs invers
NB. 0{x is ',' or '.' for hh:mm:ss,nnnnnnnnn
NB. 1{x is 'Z' for a final Z
NB. 2{x is d for date, t or 0 for time, m or 3 for millis, n or 9 for nanos
sfe=: 3 : 0
', 9'sfe y
:
s=. $y
r=. #@,y
c=. ('Z'=1{x)+10 19 23 29{~'d039'i.'d039d039'{~'d039dtmn'i.2{x NB. old and new style
y=. ,y

NB. kludge display of min/max aggregation of epchdt cols
if. (1=#y) *. +./_ __ e. y do.
  s$>3{(LIBJD_jd_,' sfe x x x *c *x *c')cd A__=:  r;c;((r,c)$' ');(,(_=y){0 6342969599999999999);x
else.
 s$>3{(LIBJD_jd_,' sfe x x x *c *x *c')cd r;c;((r,c)$' ');y;x
end.
)

NB. stuff for old style datetime yyyymmddhhmmss

NB. e from yyyymmddhhmmss
eft=: 3 : 0
r=. #y
t=. 0=$$y
r=. >2{(LIBJD_jd_,' eft x x *x *x')cd r;(r$2-2);,y
if. t do. r=. ''$r end.
)

3 : 0''
try. load JDP,'base/util_epoch_901.ijs'['d'6!:17'2000' catch. end.
)
