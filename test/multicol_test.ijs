NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. Test multicolumn queries.

NB. following is from old core tests
TYPES_CORE=. TYPES_jd_-.;:'edate edatetime edatetimem edatetimen int1 int2 int4' NB. core tests not adapted to new datatypes

toloc =. 'jdt'&,&.>

NB. x is type, y is length
gen =: 4 :0
('r_',({.~i.&' ')x)~  y , ".(}.~i.&' ')x
)

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

NUMERIC =: (#~ ((<'jdtnumeric') e. copath@toloc)"0) TYPES_CORE
isnum =: NUMERIC e.~ <@:({.~i.&' ')

ind =: (2#0,i.5) , (3#i.4) ,: (6#5 6)
cols =: ('c',":)&.> i.3

read =: [: >@{:"1@jd 'read ' , ]
read1=: [: read 'from a' , (' where ' #~ *@#) , ]

testtype =: 3 : 0
arg=. y
jdadminx 'test'
jd 'createtable';'a'; ,&(' ',arg)&.> cols
jd 'insert';'a';, cols ,. <"_1 dat=. ind { arg gen 7
testqueries arg;<dat
jd 'insert';'a';, cols ,. <@|."_1 dat
testqueries arg;<(,|.)"_1 dat
jd 'delete';'a';'jdindex < ',":{:$dat
testqueries arg;<|."_1 dat
jd 'insert';'a';, cols ,. <"_1 dat
jd 'delete';'a';'jdindex < ',":{:$dat
testqueries arg;<dat
EMPTY
)

INDS =: ".;._2 ]0 :(0)
(i.3);0
(i.3);_1
1 2;6
0 1;8
(i.3);2 3 4
0 2;0 3 6 11
)

testqueries =: 3 : 0
old=. 9!:10''
9!:11[18

'y dat' =. y
l =. ([,',',])&.>/(>@:)
toq =. ([: ; '"' (,,[)&.:>"_1 boxopen"1@])`(":@]) @. (isnum@[)
toq_m =. [: l@, ([: <@('(',')',~l)^:(1<#) y&toq(<@)"_1)"_1
q =. [: read1 ([:l cols{~[),(('=';' in '){::~1<#@]),[:toq_m [:|:dat{~<@;
r =. dat #"1~ ] (]e.{) [:|:dat{~[
testinds =. (r -: q)&,
assert testinds&>/"1 INDS

9!:11 old
)

testtype@> TYPES_CORE -. <'varbyte'
