NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. Test small-range column

read =: [: >@{:@{:@jd 'read ' , ]
read1=: [: read 'dat from a' , (' where ' #~ *@#) , ]
gensm =: _52354 + (3<.@%:{:@]) | gen

testtype =: 3 : 0
100 testtype y
:
jdadminx 'test'

NB. Create, insert, resize, delete
jd 'createtable';'a';'dat ',y
jd 'insert';'a';'dat'; <dat=.y gensm x
jd 'insert';'a';'dat'; <($~3*#)dat
jd 'delete';'a';'jdindex >= ',":x

NB. Check queries again after hashing
jd'createsmallrange a dat'
testqueries1 y;<dat
NB. Resize and delete again
assertfailure 'jd arg' [ arg=.'insert';'a';'dat';(2*x)+y gensm 1
assertfailure 'jd arg' [ arg=.'insert';'a';'dat';(_2*x)+y gensm 1
jd 'insert';'a';'dat'; <($~3*#)dat
assert (($~4*#)dat) -: read1 ''
jd 'delete';'a';'jdindex >= ',":x
assert dat -: read1 ''

NB. Reference (one side is hashed normally)
jd 'createtable';'b';'dat ',y
jd 'insert';'b';'dat'; <|.dat
jd 'reference a dat b dat'
assert (,~<dat) -: {:"1 jd 'read from a,a.b'
([: >@{:@{: [: jd 'read from a,a.b where dat'&,) testqueries y;<dat

NB. Reference multiple columns
jd 'createtable';'m'; ,@:,.&(<y,',')&.;: nms=.'c0 c1 c2'
jd 'insert';'m'; ,(;:nms) ,. dat3 =. (nms) =. <"_1 y gensm 3,x
jd 'createsmallrange m ',nms
jd 'createtable';'n'; ,@:,.&(<y,',')&.;: nms
jd 'insert';'n'; ,(;:nms) ,. dat3
jd 'reference m ',nms,' n ',nms
assert (,~dat3) -: {:"1 jd 'read from m,m.n'
)

NB. u is a verb which takes a string 'query arg' and returns a
NB. read result of type y
testqueries =: 1 : 0
x=.#dat [ 'y dat' =. y
toq_m =. [: ([,',',])&:>/ y&toq(<@)"_1
assert ((#~ (-:"_1 _{.)) dat) -: u '=',y toq {.dat
assert ((#~ (-.@-:"_1 _{.)) dat) -: u '<>',y toq {.dat
assert ((#~ (e.3&{.)) dat) -: u ' in ', toq_m 3{.dat
assert ((#~ (-.@e.5&{.)) dat) -: u ' notin ', toq_m 5{.dat
)
testqueries1 =: ([: read1 'dat'&,) testqueries

testtype@> 'int';'int 3'
