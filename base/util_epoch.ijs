NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jd'

NB. datetime epoch

NB. e unix style epoch but in nanoseconds
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
efs=: 3 : 0
s=. $y
p=. }:s
rows=. */p
cols=. {:s
y=. (rows,cols) ($,) y
r=. (LIBJD_jd_,' efs x x x *c *x *x')cd rows;cols;y;(rows$-1);<<0
'invalid iso 8601 datetime' assert 0=>{.r
p$>4{r
)

NB. same ase efs but ignore errors
efsx=: 3 : 0
s=. $y
p=. }:s
rows=. */p
cols=. {:s
y=. (rows,cols) ($,) y
r=. (LIBJD_jd_,' efs x x x *c *x *x')cd rows;cols;y;(rows$-1);<<0
p$>4{r
)

eofs=: 3 : 0
s=. $y
p=. }:s
rows=. */p
cols=. {:s
y=. (rows,cols) ($,) y
r=. (LIBJD_jd_,' efs x x x *c *x *x')cd rows;cols;y;(rows$-1);rows$-1
(p$>4{r);p$>5{r
)

NB. s from e - efs invers
NB. 0{x is ',' or '.' for hh:mm:ss,nnnnnnnnn
NB. 1{x is 'Z' for a final Z
sfe=: 3 : 0
',Zn'sfe y
:
s=. $y
y=. ,y
r=. #y
c=. ('Z'=1{x)+10 19 23 29{~'dtmn'i.2{x
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
