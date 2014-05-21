NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
APIRULES_jd_=: 0 NB. run with locale rather than api rules

PATH =. jpath'~addons/data/jd/test/core/'
load PATH,'util.ijs'

jdadminx'testall'

test =. 0!:3@:<@:(PATH,,&'.ijs')

TESTS=. ;:'datatype hash key joins reference unique summary query'
bad =. -. test@> TESTS

echo (+./bad){::'';'failed testall.ijs tests:'
echo ;LF,~each(<'.ijs'),~each(<PATH),each bad#TESTS

Close_jd_ f

assert 0=+./bad
