NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
E=: 'bad count'

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
E jdae'createcol f b int';23 24 25
jd'reads from f'
0=#'a'jdfrom_jd_ jd'read from f'

jdadminx'test'
jd'createtable f'
jd'createcol f a int';i.5
jd'createcol f b int';23
E jdae'createcol f c int';23 24 25
E jdae'createcol f c byte';'xxx'
jd'createcol f c byte 4';'xxxx'
jd'createcol f d byte 4';'xx'
'bad shape' jdae'createcol f e byte 4';'xxxqqqqqq'
E jdae'createcol f f byte 4';2 3$'x'
