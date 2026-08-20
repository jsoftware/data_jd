NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. 90x has efs/sfe as foreigns

coclass 'jd'

efs=: 6!:17

sfe=: 3 : 0
', 9'sfe y
:
t=. (2{.x),'d039d039'{~'d039dtmn'i.2{x NB. new and old precision
if. (1=#@,y) *. +./_ __="0 1 ,y do.
  t 6!:16 ,(_=,y){0 6342969599999999999 NB. kludge min/max agg empty
else.
  t 6!:16 y
end.
)
