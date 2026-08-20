NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
NB. test scalar extension
jdadminx'test'
jd'createtable f a int,b byte 4'

jd'insert f';'a';(0);'b';'b'
jd'insert f';'a';(,1);'b';,'b'

jd'insert f';'a';2 3;'b';'b'
jd'insert f';'a';4 5;'b';,'b'
jd'insert f';'a';6 7;'b';'abc'
jd'insert f';'a';8 9;'b';1 3$'abc'
jd'insert f';'a';10 11;'b';2 3$'abc'

jd'insert f';'a';12 13;'b';'abcd'
jd'insert f';'a';14 15;'b';2 4$'abcd'

'bad shape'jdae'insert f';'a';12 13;'b';'abcde'
'bad shape'jdae'insert f';'a';14 15;'b';2 5$'abcde'
jd'reads from f'

assert (i.16)=,'a'jdfroms_jd_ jd'reads from f'
assert((6#,:'b   '),(6#,:'abc'),4#,:'abcd')-:'b'jdfroms_jd_ jd'reads from f'

jdadminx'test'
jd'createtable g a int'
'shape'jdae'insert g';'a';i.2 3 4
