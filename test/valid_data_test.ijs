jdadminx'test'
jd'gen test f 2'
'data' jdae'update f';1;'boolean';23
'data' jdae'update f';1;'int';23.5
'data' jdae'update f';1;'int';<<23
'data' jdae'update f';1;'datetime';'b'

ETYPE_jd_ jdae'update f';1;'byte';23
ETYPE_jd_ jdae'update f';1;'byte4';23

ETYPE_jd_ jdae'update f';1;'varbyte';23
ETYPE_jd_ jdae'update f';1;'varbyte';'asdf'
ETYPE_jd_ jdae'update f';1;'varbyte';<2 3$'b'

jdadminx'test'
jd'createtable f i int,b4 byte 4'
jd'insert f';'i';24 25;'b4';'b'
c=. jdgl_jd_'f b4'
'bad'assert 2=countdat__c dat__c
jd'validate'

jdadminx'test'
jd'createtable f i int,b4 byte 4'
jd'insert f';'i';24 25;'b4';'bbb'
c=. jdgl_jd_'f b4'
'bad'assert 2=countdat__c dat__c
jd'validate'

jdadminx'test'
jd'createtable f i int,i1 int1,i2 int2,i4 int4'
jd'insert f';'i';24 25;'i1';24 25;'i2';24 25;'i4';24 25
c=. jdgl_jd_'f i'
'bad'assert 2=countdat__c dat__c
c=. jdgl_jd_'f i1'
'bad'assert 2=countdat__c dat__c
c=. jdgl_jd_'f i2'
'bad'assert 2=countdat__c dat__c
c=. jdgl_jd_'f i4'
'bad'assert 2=countdat__c dat__c
jd'validate'

jdadminx'test'
jd'createtable f a int'
jd'insert f';'a';23
jd'reads from f'


jdadminx'test'
jd'createtable f i int'
jd'insert f';'i';1 2 3
jd'createcol f b4 byte 4'
jd'insert f';'i';1 2 3;'b4';(3 4$'asx')
jd'createcol f var varbyte'
jd'insert f';'i';1 2 3;'b4';(3 4$'asx');'var';<'ab';'asdf';'qwerqwer'
jd'insert f';'i';7 8 9;'b4';(3 4$'asx');'var';<<'xxab' NB. extend varbyte

jdadminx'test'
jd'createtable f var varbyte'
jd'insert f';'var';<<'abc'

jdadminx'test'
jd'createtable ddt d date,dt datetime'
jd'insert ddt';'d';19991010;'dt';20121010121212

d=. i.6 4
i=. ,1
23            i}d
(24 24 24 24) i}d
(1 4$25)      i}d
i=. 1 2
23            i}d
(24 24 24 24) i}d
(2 4$25)      i}d
NB. (1 4$26)      i}d NB. note error

jdadminx'test'
jd'createtable f a int,b int,b4 byte 4'
jd'insert f';'a';2 3 4 5 6;'b';2 3 4 5 6;'b4';5 4$'z'
jd'insert f';'a';4 5;'b';4;'b4';2 3$'z'


NB. simple errors
w=. 2 3
jdadminx'test'
jd'createtable f a int,b int,b4 byte 4'
jd'insert f';'a';2 3 4 5 6;'b';2 3 4 5 6;'b4';5 4$'z'
EDUPLICATE_jd_ jdae'insert f';'a';2 3;'b';4 5;'a';5 6;'b4';2 4$'g'
EDUPLICATE_jd_ jdae'update f';w;'a';2 3;'a';4 5
ENOTJD_jd_     jdae'insert f';'a';2 3;'jdindex';4 5
ENOTJD_jd_     jdae'update f';w;'a';2 3;'jdindex';4 5
EUNKNOWN_jd_   jdae'insert f';'a';2 3;'gg';23 24
EUNKNOWN_jd_   jdae'update f';w;'a';2 3;'gg';23 24
EMISSING_jd_   jdae'insert f';'a';2 3;'b4';2 4$'g'

NB. simple update conformability
NB. ,23 and 1 3$'a' do NOT extend
w=. 2 3
jdadminx'test'
jd'createtable f a int,b int,b4 byte 4'
jd'insert f';'a';2 3 4 5 6;'b';2 3 4 5 6;'b4';5 4$'z'
jd'update f';w;'a';4 5;'b';4 5
jd'update f';w;'a';4 5;'b';23
jd'update f';w;'a';4 5;'b4';2 3$'q'
jd'update f';w;'a';4 5;'b4';'q'
jd'update f';w;'a';4 5;'b4';'qq'

NB. ,23 and 1 3$'a' do extend
jd'update f';w;'a';4 5;'b';,23
jd'update f';w;'a';4 5;'b4';1 3$'q'

NB. simple insert conformability
w=. 2 3
jdadminx'test'
jd'createtable f a int,b int,b4 byte 4'
jd'insert f';'a';4 5;'b';4 5;'b4';2 3$'z'
jd'insert f';'a';4 5;'b';23;'b4';2 3$'z'
jd'insert f';'a';4 5;'b';6 7;'b4';2 3$'q'
jd'insert f';'a';4 5;'b';6 7;'b4';'q'
jd'insert f';'a';4 5;'b';6 7;'b4';'qq'

NB. ,23 and 1 3$'a' do extend
ETALLY_jd_ jdae'insert f';'a';4 5;'b';(,23);'b4';5 4$'z'
jd'insert f';'a';4 5;'b';6 7;'b4';1 3$'q'

NB. varbyte validate
jdadminx'test'
jd'createtable f i int,var varbyte'
NB. jd'insert f';'i';2;'var';23



jdadminx'test'
jd'createtable f i int,b byte,b4 byte 4,var varbyte'
N=: 'i';'b';'b4';'var'
W=: 'jdindex<2'
E=: 'bad count'
jd'insert f';,N,.23;'x';'qwer';<<'abc'                      NB. insert scalars
jd'insert f';,N,.24 25;'rt';(2 4$'hhhhjjjj');<'ddd';'hhhhh' NB. insert 2 rows
jd'insert f';,N,.26 27;'rt';(2 3$'mmmnnn');<'ddd';'hhhhh'   NB. insert 2 rows - byte4 overtake

jd'insert f';,N,.24 25;'r';'bbb';<<'ddd'                    NB. insert 2 rows - scalar extend

jd'update f';'jdindex=1';,N,.66;'x';'qwer';<<'abc'                      NB. insert scalars
jd'update f';'jdindex<2';,N,.67 68;'rt';(2 4$'hhhhjjjj');<'ddd';'hhhhh' NB. insert 2 rows
jd'update f';'jdindex<2';,N,.69 70;'rt';(2 3$'mmmnnn');<'ddd';'hhhhh'   NB. insert 2 rows - byte4 overtake
jd'update f';'jdindex<2';,N,.69 70;'rt';(1 3$'mmmnnn');<'ddd';'hhhhh'   NB. insert 2 rows - bad count
jd'update f';'jdindex<2';,N,.99;'r';'bbb';<<'ddd'                       NB. insert 2 rows - scalar extend
jd'insert f';,N,.24 25;'rt';(1 4$'hhhhjjjj');<'ddd';'hhhhh'     NB. insert 2 rows

NB. errors
E jdae'insert f';,N,.24 25 26;'rt';(2 4$'hhhhjjjj');<'ddd';'hhhhh'  NB. insert 2 rows
E jdae'insert f';,N,.24 25;'rtx';(2 4$'hhhhjjjj');<'ddd';'hhhhh'    NB. insert 2 rows
E jdae'insert f';,N,.24 25;'rt';(3 4$'hhhhjjjj');<'ddd';'hhhhh'     NB. insert 2 rows
E jdae'insert f';,N,.24 25;'rt';(2 4$'hhhhjjjj');<'ddd';'hhhhh';'x' NB. insert 2 rows

E jdae'update f';W;,N,.24 25 26;'rt';(2 4$'hhhhjjjj');<'ddd';'hhhhh'
E jdae'update f';W;,N,.24 25;'rtx';(2 4$'hhhhjjjj');<'ddd';'hhhhh'
E jdae'update f';W;,N,.24 25;'rt';(3 4$'hhhhjjjj');<'ddd';'hhhhh'  
jd'update f';W;,N,.24 25;'rt';(1 4$'hhhhjjjj');<'ddd';'hhhhh'
E jdae'update f';W;,N,.24 25;'rt';(2 4$'hhhhjjjj');<'ddd';'hhhhh';'x'


jdadminx'test'
jd'createtable f b4 byte 4'
jd'insert f';'b4';6 4$'z'
jd'update f';'jdindex=2';'b4';'abcd'
jd'update f';'jdindex=2';'b4';'gg'
jd'update f';'jdindex=2';'b4';'x'
ESHAPE_jd_ jdae'update f';'jdindex=2';'b4';'abcdef'
jd'update f';'jdindex=2';'b4';1 4$'hhhh'
jd'update f';'jdindex=2';'b4';1 2$'hh'
ESHAPE_jd_ jdae'update f';'jdindex=2';'b4';1 6$'hhhh'


jd'update f';'jdindex<2';'b4';'hhhh'
jd'update f';'jdindex<2';'b4';'aa'
ESHAPE_jd_ jdae'update f';'jdindex<2';'b4';'xxyyyyhhhh'

jd'update f';'jdindex<2';'b4';2 4$'y'
jd'update f';'jdindex<2';'b4';2 4$'hhhh'
EINDEX_jd_ jdae'update f';_1;'b4';1 4$'hhhh'
EINDEX_jd_ jdae'update f';23;'b4';1 4$'hhhh'

jdadminx'test'
jd'createtable f a int,b int,b4 byte 4'
jd'insert f';'a';2 3 4 5 6;'b';2 3 4 5 6;'b4';5 4$'z'
jd'update f';w;'a';2 3;'b';23
jd'update f';w;'a';2 3;'b4';'x'
jd'update f';w;'a';2 3;'b4';'xx'
jd'update f';w;'a';2 3;'b';,23
jd'update f';w;'a';2 3;'b4';1 4$'q'
