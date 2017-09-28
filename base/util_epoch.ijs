NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
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
efs=: 3 : 0
0 0 0 efs y
:
s=. $y
p=. }:s
rows=. */p
cols=. {:s
y=. (rows,cols) ($,) y
if. 1=2{x do.  off=. rows$-1 else. off=. <0 end.
r=. (LIBJD_jd_,' efs x x x *c *x *x x')cd rows;cols;y;(rows$-1);off;1{x
if. 1~:{.x do. 'invalid iso 8601 datetime' assert 0=>{.r end.
if. 1={:x do. (p$>4{r);p$>5{r else. p$>4{r end.
)

efsx=: 1 0 0&efs NB. allow errors, do not ignore offset, do not return offset

eofs=: 0 0 1&efs NB. do not allow errors, do not ignore offset, return offset

NB. s from e - efs invers
NB. 0{x is ',' or '.' for hh:mm:ss,nnnnnnnnn
NB. 1{x is 'Z' for a final Z
sfe=: 3 : 0
', n'sfe y
:
s=. $y
y=. ,y
r=. #y
c=. ('Z'=1{x)+10 19 23 29{~'dtmn'i.2{x

NB. kludge display of min/max aggregation of epchdt cols
if. (1=#y)*.+./_ __="0 1 y do.
 y=. ,(_=y){0 6342969599999999999
end.

s$>3{(LIBJD_jd_,' sfe x x x *c *x *c')cd r;c;((r,c)$' ');y;x
)

NB. stuff for old sylte datetime yyyymmddhhmmss

NB. e from yyyymmddhhmmss
eft=: 3 : 0
r=. #y
t=. 0=$$y
r=. >2{(LIBJD_jd_,' eft x x *x *x')cd r;(r$2-2);,y
if. t do. r=. ''$r end.
)
