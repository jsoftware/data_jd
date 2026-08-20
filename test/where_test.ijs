NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
f =. fixwhere_jdtable_
m =. <@:(<;._1)@[ -: f@]

assert '|a|qequal|"   a   b   "' m 'a="   a   b   "'

assert '|a|qequal|"a and i=23"' m 'a="a and i=23"'

assert 0:@:f :: 1: 'a="abc'

assert '|a|qequal|"abc"' m 'a="abc"'

NB. f'a eq"abc"'        NB. should this be allowed (that is blank not required before quote)?


NB. test not
NB. not prior to 3.2 (2016 feb 20) gave wrong answers

g=: 4 : 0
assert x          ='a'jdfrom_jd_ jd'read from f where ',y
assert (t-.x)='a'jdfrom_jd_ jd'read from f where not ',y
)

t=: i.10 NB. all rows

jdadminx'test'
jd'createtable f'
jd'createcol f a int _';i.10

5     g 'a =      5'
5 7   g 'a in    (5,7)'
4 5 6 g 'a range (4,6)'

jd'delete f';'a=5'
t=: t -. 5
4 6 g 'a range (4,6)'





