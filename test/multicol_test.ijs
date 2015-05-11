NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. Test multicolumn queries.

ind =: (2#0,i.5) , (3#i.4) ,: (6#5 6)
cols =: ('c',":)&.> i.3

read =: [: >@{:"1@jd 'read ' , ]
read1=: [: read 'from a' , (' where ' #~ *@#) , ]

testtype =: 3 : 0
jdadminx 'test'

NB. Initial table
jd 'createtable';'a'; ,&(' ',y)&.> cols
jd 'insert';'a';, cols ,. <"_1 dat=. ind { y gen 7
testqueries y;<dat

NB. Add and delete
jd 'insert';'a';, cols ,. <@|."_1 dat
testqueries y;<(,|.)"_1 dat
jd 'delete';'a';'jdindex < ',":{:$dat
testqueries y;<|."_1 dat

NB. Hash all columns
jd 'createhash a';cols
testqueries y;<|."_1 dat

NB. Hash some columns
jd 'createhash a';0 1{cols
testqueries y;<|."_1 dat

NB. Insert/delete again
jd 'insert';'a';, cols ,. <"_1 dat
jd 'delete';'a';'jdindex < ',":+:{:$dat
testqueries y;<dat

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
toq_m =. [: l@, ([: <@('(',')',~l@:~.)^:(1<#) y&toq(<@)"_1)"_1
q =. [: read1 ([:l cols{~[),(('=';' in '){::~1<#@]),[:toq_m dat{~<@;
r =. dat (#"1~*./) ] (]e.{)"_ _1 dat{~[
testinds =. (r -: q)&,
assert testinds&>/"1 INDS

9!:11 old
)

ALLOW_FVE_jd_ =: 1 [ af =. ALLOW_FVE_jd_
testtype@> TYPES_CORE -. ;:'time enum'
NB. testtype@> ,&' 5'&.> TYPES_CORE -. ;:'varbyte date datetime time enum'
ALLOW_FVE_jd_ =: af
