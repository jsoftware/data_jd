NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
jdadminx'test'
jd'createtable f'
jd'createcol f a int _';a=.i.5
jd'createcol f b int';99
jd'createcol f c byte';'x'
jd'createcol f d byte 4';d=.5 4$'asdf134'
assert (a;(5$99);(5$'x');d)-:{:"1 jd'read from f'

jd'createtable g'
jd'createcol g a int'
jd'createcol g b int'
jd'createcol g c byte'
jd'createcol g d byte 4'
jd'insert g';'a';a;'b';99;'c';'x';'d';d

assert (jd'read from f')-:jd'read from g'

jdadminx'test'
jd'createtable f'
jd'createcol f a int'
ESHAPE_jd_ jdae'createcol f b int';23 24 25
jd'reads from f'
0=#'a'jdfrom_jd_ jd'read from f'

jdadminx'test'
jd'createtable f'
jd'createcol f a int';i.5
jd'createcol f b int';23
ESHAPE_jd_ jdae'createcol f c int';23 24 25
ESHAPE_jd_ jdae'createcol f c byte';'xxx'
jd'createcol f c byte 4';'xxxx'
jd'createcol f d byte 4';'xx'
ESHAPE_jd_ jdae'createcol f d byte 4';'xxxqqqqqq'
ESHAPE_jd_ jdae'createcol f d byte 4';2 3$'x'
