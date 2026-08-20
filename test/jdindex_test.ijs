NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. Test queries on the jdindex column.

jdadminx 'test'

jd 'createtable t index int'
jd 'insert t index';i.10

test =: 'jdindex'&, -:&jd&('read from t where '&,) 'index'&,

NB. Ignore the first test (equality with negative index)
assert *./ }. , test@:;@> { ' = < <= > >=' ,&<&(<;.1) ' -3 6 12'

assert test ' range 1,4,6,7'
assert test ' range -2,4,6,12'
assert test ' range 4,4,8'
