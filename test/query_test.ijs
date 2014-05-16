NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test queries, using all datatypes, joins, insertions, and deletes.

require '~addons/data/jd/test/core/util.ijs'

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
assert (x#1) -: read 'jdactive from a'

NB. Check queries again after hashing
jd'createhash a dat'
testqueries1 y;<dat
NB. Resize and delete again
jd 'insert';'a';'dat'; <($~3*#)dat
assert (($~4*#)dat) -: read1 ''
jd 'delete';'a';'jdindex >= ',":x
assert dat -: read1 ''

NB. Reference
jd 'createtable';'b';'dat ',y
jd 'insert';'b';'dat'; <|.dat
jd 'reference a dat b dat'
assert (,~<dat) -: {:"1 jd 'read from a,a.b'
([: >@{:@{: [: jd 'read from a,a.b where dat'&,) testqueries y;<dat

NB. Reference multiple columns
jd 'createtable';'m'; ,@:,.&(<y,',')&.;: nms=.'c0 c1 c2'
jd 'insert';'m'; ,(;:nms) ,. dat3 =. (nms) =. <"_1 y gen 3,x
jd 'createtable';'n'; ,@:,.&(<y,',')&.;: nms
jd 'insert';'n'; ,(;:nms) ,. dat3
jd 'reference m ',nms,' n ',nms
assert (,~dat3) -: {:"1 jd 'read from m,m.n'
)

NB. u is a verb which takes a string 'query arg' and returns a
NB. read result of type y
testqueries =: 1 : 0
old=. 9!:10''
9!:11[18 NB. kludge because toq assumes this for float
x=.#dat [ 'y dat' =. y
assert ((#~ (-:"_1 _{.)) dat) -: u '=',y toq {.dat
assert ((#~ (-.@-:"_1 _{.)) dat) -: u '<>',y toq {.dat
assert ((#~ (e.3&{.)) dat) -: u ' in ',([,',',])&:>/ y&toq(<@)"_1 ]3{.dat
assert ((#~ (-.@e.5&{.)) dat) -: u ' notin ',([,',',])&:>/ y&toq(<@)"_1 ]5{.dat
assert (<.@-: x) = # u ' sample ',":<.@-:x
assert (u-:u) ' sample. ',":<.@-:x
if. NUMERIC e.~ <y do.
  assert ((#~ (< {.)) dat) -: u '< ',y toq {.dat
  assert ((#~ (> {.)) dat) -: u '> ',y toq {.dat
  assert ((#~ (<:{.)) dat) -: u '<=',y toq {.dat
  assert ((#~ (>:{.)) dat) -: u '>=',y toq {.dat
end.
9!:11 old
)
testqueries1 =: ([: read1 'dat'&,) testqueries

ALLOW_FVE_jd_ =: 1 [ af =. ALLOW_FVE_jd_
testtype@> TYPES -. 'time';'enum'
testtype@> ,&' 5'&.> TYPES -. ;:'varbyte date datetime time enum'
ALLOW_FVE_jd_ =: af


NB. bug - reference join where clause emtpy returns all rows
jdadminx'test'
jd'gen ref2 a 10 0 b 5'
a=. jd'read from a,a.b where b.bref=2'
assert 2 2-:;{:{:a
b=. jd'read from a,a.b where b.bref=22'
assert ''-:;{:{:b
jd'dropdynamic'
jd'reference a aref b bref'
assert a-:jd'read from a,a.b where b.bref=2'
assert b-:jd'read from a,a.b where a.aref=22'
assert b-:jd'read from a,a.b where b.bref=22' NB. bug - all rows instead of 0 rows

