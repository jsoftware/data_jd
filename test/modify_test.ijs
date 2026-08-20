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

jd'update f';'jdindex=0';'boolean';1;'int';2;'float';2.2;'byte';'b';'byte4';(1 4$'bbbb');'edatetime';efs_jd_'2000'
assert (jd'reads from f where jdindex=0')-:jd'reads from f where jdindex=3'

NB. all pairs with correct #
jd'update f';'jdindex in (1,2)';'boolean';1 1;'int';2 2;'float';2.2 2.2;'byte';'bb';'byte4';(2 4$'bbbb');'edatetime';2$efs_jd_'2000'
assert (jd'reads from f where jdindex in (1,2)')-:jd'reads from f where jdindex in (4,5)'


NB. some pairs with correct # and scalar extension in fixpairs
jd'update f';'jdindex in (1,2)';'boolean';1 ;'int'; 2;'float';2.2 2.2;'byte';'bb';'byte4';(2 4$'bbbb');'edatetime';2$efs_jd_'2000'
assert (jd'reads from f where jdindex in (1,2)')-:jd'reads from f where jdindex in (4,5)'

NB. all pairs scalar with extension done in update (after we know how many are required)
jd'update f';'jdindex in (1,2)';'boolean';1 ;'int'; 2;'float';  2.2;'byte';'b';'byte4';(1 4$'bbbb');'edatetime';1$efs_jd_'2000'
assert (jd'reads from f where jdindex in (1,2)')-:jd'reads from f where jdindex in (4,5)'

NB. shape and scalar extension
jd'update f';'jdindex in (0,1,2)';'boolean';1;'int';2;'float';2.2;'byte';'b';'edatetime';efs_jd_'2000'
jd'update f';'jdindex in (0,1,2)';'boolean';1;'int';2;'float';2.2;'byte';'b';'edatetime';efs_jd_'2000'
jd'update f';'jdindex in (0,1,2)';'byte4';'xxxx'
jd'update f';'jdindex in (0,1,2)';'byte4';3 4$'xxxx'
jd'update f';'jdindex in (0,1,2)';'byte4';1 4$'qqqq'
jd'update f';'jdindex in (0,1,2)';'byte4';'mmmm'

assert de-:jd etx 'update f';'jdindex in (0,1,2)';'byte4';2 4$'xxxx'

jd'update f';'jdindex in (0,1,2)';'int';23
jd'update f';'jdindex in (0,1,2)';'int';,23

NB. edatetimen
jd'update f';'jdindex=0';'edatetime';efs_jd_'2000'
jd'update f';'jdindex=0';'edatetime';'2000'

jd'update f';'jdindex in (0,1,2)';'edatetime';efs_jd_'2000'
jd'update f';'jdindex in (0,1,2)';'edatetime';'2000'

jd'update f';'jdindex in (0,1,2)';'edatetime';'2000'
assert de-:jd etx 'update f';'jdindex in (0,1,2)';'edatetim';,efs_jd_ '2000'

jd'update f';'jdindex in (0,1,2)';'edatetime';0

jd'update f';'jdindex in (0,1,2)';'edatetime';'2000-01-01T00:00:00.123456789' NB. extra precision discarded

NB. types
jd'update f';'jdindex=0';'boolean';1
jd'update f';'jdindex=0';'boolean';2-1
jd'update f';'jdindex=0';'int';0

modifygen''
jd'gen one g 5 1'
jd'ref f int g a0'
jd'update f';'jdindex=0';'float';23.23

modifygen''
jd'update f';'byte4 = "bbbb"';'int';6 7 8
a=. jd'reads from f'
modifygen''
i=. >{:"1 jd'read jdindex from f where byte4="bbbb"'
jd'update f';i;'int';6 7 8
b=. jd'reads from f'
assert a-:b


NB. bug modify works, but truncates the data:
jdadminx 'test'
jd 'createtable tab'
jd 'createcol tab size int _';3 5 7
jd 'createcol tab name byte 3';3 3$'bobsamtom'
a=. jd 'reads jdindex,* from tab'
'bad shape' jdae 'update tab';2;'name';,:'david'
assert a-: jd 'reads jdindex,* from tab'

jdadminx'test'
jd'gen test f 4'
assert (,:'EFGHIJ')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=1'
jd'update f';'jdindex=1';'varbyte';<<'abcdef' NB. same size
assert (,:'abcdef')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=1'
jd'update f';'jdindex=1';'varbyte';<<'abc' NB. smaller
assert (,:'abc')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=1'
jd'update f';'jdindex=1';'varbyte';<<'xxxyyyzzz' NB. bigger
assert (,:'xxxyyyzzz')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=1'
jd'update f';'jdindex<3';'varbyte';<'111';'22222222244';'12345678'
assert (,:'111')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=0'
assert (,:'22222222244')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=1'
assert (,:'12345678')-:'varbyte'jdfroms_jd_ jd'reads from f where jdindex=2'
