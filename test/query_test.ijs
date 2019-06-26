NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test queries, using all datatypes, joins, insertions, and deletes.

NB. following is from old core tests
TYPES_CORE=. TYPES_jd_-.;:'float edate edatetime edatetimem edatetimen int1 int2 int4' NB. core tests not adapted to new datatypes

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
toq  =: ([: ; '"' (' ',~,,[)&.:>"_1 boxopen"1@])`(":@]) @. (isnum@[)

assertfailure =: 3 :0
try. 0[".y catch. 1 end.
)

read =: [: >@{:@{:@jd 'read ' , ]
read1=: [: read 'dat from a' , (' where ' #~ *@#) , ]

testtype =: 3 : 0
100 testtype y
:
jdadminx 'test'

NB. Basic insertion
jd 'createtable';'a';'dat ',y
jd 'insert';'a';'dat'; <dat=. y gen x
assert dat -: read1 ''
assertfailure 'jd arg' [ arg=.'insert';'a';'dat'; 2#"_1 dat

NB. Resizing
jd 'insert';'a';'dat'; <($~3*#)dat
assert (($~4*#)dat) -: read1 ''
NB. Deletion
jd 'delete';'a';'jdindex >= ',":x
assert dat -: read1 ''
NB. Queries
testqueries1 y;<dat
NB. Hidden columns
assert (i.x) -: read 'jdindex from a'

NB. Resize and delete again
jd 'insert';'a';'dat'; <($~3*#)dat
assert (($~4*#)dat) -: read1 ''
jd 'delete';'a';'jdindex >= ',":x
assert dat -: read1 ''

jd 'createtable';'b';'dat ',y
jd 'insert';'b';'dat'; <|.dat
jd 'ref a dat b dat'
assert (,~<dat) -: {:"1 jd 'read from a,a.b'
([: >@{:@{: [: jd 'read from a,a.b where dat'&,) testqueries y;<dat

NB. ref multiple columns
jd 'createtable';'m'; ,@:,.&(<y,',')&.;: nms=.'c0 c1 c2'
jd 'insert';'m'; ,(;:nms) ,. dat3 =. (nms) =. <"_1 y gen 3,x
jd 'createtable';'n'; ,@:,.&(<y,',')&.;: nms
jd 'insert';'n'; ,(;:nms) ,. dat3
jd 'ref m ',nms,' n ',nms
assert (,~dat3) -: {:"1 jd 'read from m,m.n'
)

NB. u is a verb which takes a string 'query arg' and returns a
NB. read result of type y
testqueries =: 1 : 0
old=. 9!:10''
9!:11[18 NB. kludge because toq assumes this for float
q=.#dat [ 'y dat' =. y
toq_m =. [: ([,',',])&:>/ y&toq(<@)"_1
assert ((#~ (-:"_1 _{.)) dat) -: u '=',y toq {.dat
assert ((#~ (-.@-:"_1 _{.)) dat) -: u '<>',y toq {.dat
assert ((#~ (e.3&{.)) dat) -: u ' in ', toq_m 3{.dat
assert ((#~ (-.@e.5&{.)) dat) -: u ' notin ', toq_m 5{.dat
assert (<.@-: q) = # u ' sample ',":<.@-:q
assert (u-:u) ' sample. ',":<.@-:q
if. y -.@e. 'varbyte enum' do.
  assert ((#~ ] (-:/:~)@:({.@],[,}.@])"_1 _ [:/:~3 5&{) dat) -: u ' range ',toq_m /:~3 5{dat
end.
if. NUMERIC e.~ <y do.
  assert ((#~ (< {.)) dat) -: u '< ',y toq {.dat
  assert ((#~ (> {.)) dat) -: u '> ',y toq {.dat
  assert ((#~ (<:{.)) dat) -: u '<=',y toq {.dat
  assert ((#~ (>:{.)) dat) -: u '>=',y toq {.dat
end.
9!:11 old
)
testqueries1 =: ([: read1 'dat'&,) testqueries

testtype@> TYPES_CORE -. ;:'time enum varbyte'
NB. testtype@> ,&' 5'&.> TYPES_CORE -. ;:'float varbyte date datetime' - trailing shapes


NB. bug - ref join where clause empty returns all rows
jdadminx'test'
jd'gen ref2 a 10 0 b 5'
a=. jd'read from a,a.b where b.bref=2'
assert 2 7-:;{:{.a
b=. jd'read from a,a.b where b.bref=22'
assert ''-:;{:{.b
jd'dropcol a jdref_aref_b_bref'
jd'ref a aref b bref'
assert a-:jd'read from a,a.b where b.bref=2'
assert b-:jd'read from a,a.b where a.aref=22'
assert b-:jd'read from a,a.b where b.bref=22' NB. bug - all rows instead of 0 rows
