NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
1[0 : 0
test where queries that use C routines (util.c)
support is in 2 areas: integrated regex and fast vartype
C routines are used for the following:
 int, datetime,... types (based on J INT type)
  like/unlike
 byte N type
   like/unlike
 vartype
  like/unlike
  eq/ne
  in/notin
  eq/ne col  (column in same table)
  eq/ne colf (column in another table)
tests assume generate table is alwyas the same
and that if int col is correct that the result is correct

int1/int2/int4 like/unlike not supported
)

jdadminx'test'

getx=: 3 : 0
,'x'jdfroms_jd_ y
)

all=. i.10
jd'gen test tab 10'
assert all-:getx jd'reads from tab'

NB. int - like/unlike
r=.jd'reads from tab where datetime like "^199"'
assert 0 1 7 8 9       -:getx r
r=. jd'reads from tab where datetime unlike "^199"'
assert (all-.0 1 7 8 9)-:getx r 

NB. byte - like/unlike
r=.jd'reads from tab where byte4 like "^[Ag]"'
assert 0 8      -:getx r
r=. jd'reads from tab where byte4 unlike "^[Ag]"'
assert (all-.0 8)-:getx r

NB. varbyte - like/unlike
r=. jd'reads from tab where varbyte    like "^[Ax]"'
assert 0 8      -:getx r
r=. jd'reads from tab where varbyte    likeci "^[aX]"'
assert 0 8      -:getx r
r=. jd'reads from tab where varbyte unlike "^[Ax]"'
assert (all-.0 8)-:getx r
r=. jd'reads from tab where varbyte unlikeci "^[ax]"'
assert (all-.0 8)-:getx r

NB. varbye - eq/ne
r=. jd'reads from  tab where varbyte eq "YZabc"'
assert (,4)    -:getx r
r=. jd'reads from  tab where varbyte ne "YZabc"'
assert (all-.4)-:getx r 

NB. varbyte - in/notin
r=. jd'reads from tab where varbyte in ("YZabc","xyz012")'
assert 4 8      -:getx r 
r=. jd'reads from tab where varbyte notin ("YZabc","xyz012")'
assert (all-.4 8)-:getx r


NB. varbyte - eq/ne col
assert (,8)    -:getx jd'reads from tab where varbyte eq "xyz012"'
assert (all-.8)-:getx jd'reads from tab where varbyte ne "xyz012"'


NB. this test needs lots of work and expansion to other cases
NB. following tests disabled as there is no tabx table

NB. varbyte - eq/ne col in another table
NB. note row 5 from joined row of nulls
NB. assert (,2)    -:getx jd'reads from tab,tab.tabx where v1 eq "tabx.dvx"'
NB. assert (all-.2 5)-:getx jd'reads from tab,tab.tabx where v1 ne "tabx.dvx"'
NB. row 5 not included with tab,tab-tabx
NB. (all-.2)-:getint jd'reads from tab,tab.tabx where v1 ne "tabx.dvx"'
