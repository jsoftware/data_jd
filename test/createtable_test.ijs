NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

fd=: 3 : 0
jd'droptable f'
)

jdadminx'test'
jd'createtable f'                [fd''
jd'createtable f a int'          [fd''
jd'read a from f'
jd'createtable f a int,b int'    [fd''
jd'read a,b from f'
jd'createtable f a int,b byte 3' [fd''
jd'read a,b from f'
jd'createtable f';'a int';'b byte 2' [fd''
jd'read a,b from f'

jd'gen test g 3'
jd'createtable /pairs f';,jd'read from g' [fd''
assert (jd'read from f')-:jd'read from g'

jd'createtable /types /pairs f';,jd'read /types from g' [fd''
assert (jd'read from f')-:jd'read from g'

jd'createcol g e edate';>3#<'1990-12-06'
jd'createtable /types /pairs f';,jd'read /types from g' [fd''
assert (jd'read from f')-:jd'read from g'

jd'createtable /pairs f';'a';23;'b';3 3$'abcdefghi' [fd''

