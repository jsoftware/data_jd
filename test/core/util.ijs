NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Utilities for testing JD

HASH=: 0

TYPES =: TYPES_jd_

toloc =. 'jdt'&,&.>
NUMERIC =: (#~ ((<'jdtnumeric') e. copath@toloc)"0) TYPES

NB. random generators
NB. y is shape
r_boolean =: ?@$&2
r_int     =: ?@$&1e5
r_float   =: 1e5 * ?@$&0
r_byte    =: a. {~ 97+?@$&26
r_enum    =: r_byte
r_varbyte =: [:r_byte&.> ?@$&10
r_date    =: 1e7  + ?@$&9e7
r_datetime=: 1e13 + ?@$&9e13
r_time    =: 1e5  + ?@$&9e5

NB. x is type, y is length
gen =: 4 :0
('r_',({.~i.&' ')x)~  y , ".(}.~i.&' ')x
)
NB. x is (type;shape)
gen1 =: 4 :0"1 0
('r_',0{::x)~  y , 1{::x
)

isnum =: NUMERIC e.~ <@:({.~i.&' ')
toq  =: ([: ; '"' (' ',~,,[)&.:>"_1 boxopen"1@])`(":@]) @. (isnum@[)
genq =: toq  ,@:{.@gen&1

assertfailure =: 3 :0
try. 0[".y catch. 1 end.
)
