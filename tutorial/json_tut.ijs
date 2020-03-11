'new'jdadmin'json'
jd'createtable f'
jd'createcol f i int'
jd'createcol f b byte'
jd'createcol f b4 byte 4'

d=. 'insert f';'i';2;'b';'z';'b4';'abc'
jd d
jd'read from f'
enc_pjson_ d
jd'json ',enc_pjson_ d
jd'read from f'

d=. 'insert f';'i';2;'b';'z';'b4';'abcde'
'bad shape'jdae d
enc_pjson_ d
'bad shape'jdae'json ',enc_pjson_ d

jd'delete f';'jdindex>_1'

d=. 'insert f';'i';3 4;'b';'qw';'b4';2 3$'dgg'
jd d
jd'read from f'
enc_pjson_ d
jd'json ',enc_pjson_ d
jd'read from f'

d=. 'insert f';'i';2;'b';'z';'b4';2 5$'x'
'bad shape'jdae d
enc_pjson_ d
'bad shape'jdae'json ',enc_pjson_ d

NB. need varbyte example (not supported yet)
NB. need json result examples
NB. need example of json result used as pairs arg
