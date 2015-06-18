NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. modify

modifygen=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f boolean boolean _';0 0 0 1 1 1
jd'createcol f int int _';       0 0 0 2 2 2
jd'createcol f float float _';   0 0 0 2.2 2.2 2.2
jd'createcol f byte byte _';     'aaabbb'
jd'createcol f byte4 byte 4';    6 4$'aaaaaaaaaaaabbbbbbbbbbbb'
jd'createcol f edatetime edatetime _';(3$efs_jd_'1970'),3$efs_jd_'2000'
)

de=. 'domain error'

modifygen''

jd'modify f';'jdindex=0';'boolean';1;'int';2;'float';2.2;'byte';'b';'byte4';(1 4$'bbbb');'edatetime';efs_jd_'2000'
assert (jd'reads from f where jdindex=0')-:jd'reads from f where jdindex=3'

jd'modify f';'jdindex in (1,2)';'boolean';1 1;'int';2 2;'float';2.2 2.2;'byte';'bb';'byte4';(2 4$'bbbb');'edatetime';2$efs_jd_'2000'
assert (jd'reads from f where jdindex in (1,2)')-:jd'reads from f where jdindex in (4,5)'

NB. shape and scalar extension
jd'modify f';'jdindex in (0,1,2)';'boolean';1;'int';2;'float';2.2;'byte';'b';'edatetime';efs_jd_'2000'
jd'modify f';'jdindex in (0,1,2)';'boolean';1;'int';2;'float';2.2;'byte';'b';'edatetime';efs_jd_'2000'
jd'modify f';'jdindex in (0,1,2)';'byte4';'xxxx'
jd'modify f';'jdindex in (0,1,2)';'byte4';3 4$'xxxx'
assert de-:jd etx 'modify f';'jdindex in (0,1,2)';'byte4';2 4$'xxxx'
assert de-:jd etx'modify f';'jdindex in (0,1,2)';'byte4';1 4$'xxxx'

jd'modify f';'jdindex in (0,1,2)';'int';23
assert de-:jd etx 'modify f';'jdindex in (0,1,2)';'int';,23

NB. edatetimen
jd'modify f';'jdindex=0';'edatetime';efs_jd_'2000'
jd'modify f';'jdindex=0';'edatetime';'2000'

jd'modify f';'jdindex in (0,1,2)';'edatetime';efs_jd_'2000'
jd'modify f';'jdindex in (0,1,2)';'edatetime';'2000'

jd'modify f';'jdindex in (0,1,2)';'edatetime';'2000'
assert de-:jd etx 'modify f';'jdindex in (0,1,2)';'edatetim';,efs_jd_ '2000'

jd'modify f';'jdindex in (0,1,2)';'edatetime';0

de-:jd etx'modify f';'jdindex in (0,1,2)';'edatetime';'2000-01-01T00:00:00.123456789'
assert 'extra precision'-:;1{jdlast


NB. types
jd'modify f';'jdindex=0';'boolean';1
assert de-:jd etx'modify f';'jdindex=0';'boolean';2-1
jd'modify f';'jdindex=0';'int';0

NB. can not modify col data with dynmaic
jd'createhash f int'
jd'modify f';'jdindex=0';'float';23.23
assert de-:jd etx'modify f';'jdindex=0';'int';1

modifygen''
jd'gen one g 5 1'
jd'reference f int g a0'
jd'modify f';'jdindex=0';'float';23.23
assert de-:jd etx'modify f';'jdindex=0';'int';1

modifygen''
jd'gen one g 5 1'
jd'ref f int g a0'
jd'modify f';'jdindex=0';'float';23.23
assert de-:jd etx'modify f';'jdindex=0';'int';1

modifygen''
jd'modify f';'byte4 = "bbbb"';'int';6 7 8
a=. jd'reads from f'
modifygen''
i=. >{:"1 jd'read jdindex from f where byte4="bbbb"'
jd'modify f';i;'int';6 7 8
b=. jd'reads from f'
assert a-:b


