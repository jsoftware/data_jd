NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
f =. fixwhere_jdtable_
m =. <@:(<;._1)@[ -: f@]

assert '|a|qequal|"   a   b   "' m 'a="   a   b   "'

assert '|a|qequal|"a and i=23"' m 'a="a and i=23"'

assert 0:@:f :: 1: 'a="abc'

assert '|a|qequal|"abc"' m 'a="abc"'

NB. f'a eq"abc"'        NB. should this be allowed (that is blank not required before quote)?
