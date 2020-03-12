'new'jdadmin'json'
jd'createtable f'
jd'createcol f i int'
jd'createcol f b byte'
jd'createcol f b4 byte 4'

d=. 'insert f';'i';2;'b';'z';'b4';'abc'
jd d
jd'read from f'
[r=. jd'json read from f'
assert '{'={.r NB. json string result
[r=. jd'json reads from f'
assert '{'={.r NB. json string result
[r=. jd'json info summary'
assert '{'={.r NB. json string result

enc_pjson_ d
[r=. jd'json ',enc_pjson_ d NB. string starting with json assumes arg is json string
assert '{}'-:r NB. json string result

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

jd'delete f';'jdindex>_1'
jd'createcol f v varbyte'
jd'insert f';'i';23;'b';'x';'b4';'abc';'v';<<'abc'
jd'read from f'

d=. enc_pjson_ 'insert f';'i';23;'b';'x';'b4';'abc';'v';<<'abc'
jd'json ',d
jd'read from f'

d=. enc_pjson_ 'insert f';'i';23 24;'b';'xy';'b4';(2 3$'abcdef');'v';<'qwer';'asdfasdf'
jd'json ',d
jd'read from f'

jd'json read from f' NB. returns json dictionary
jd'json info summary'

NB. json result is a dictionary
NB. a dictionary can be converted to a list
NB. sometimes you need the list encoding and not the dictionary
NB. e.g if you want to feed the json result of a read to an insert

NB. json - list from dictionary
lfromd=: 3 : 0
d=. }.}:<;.2 y,LF
;(d i.each ':') (','"_`[`])} each d
)

[t=. '[',LF,']',~(enc_pjson_ 'insert f'),',',LF,lfromd jd'json read from f'
jd'json ',t
jd'read from f'

NB. check json results for other ops
assert (i.0 0)-:jd'update f';'i=3';'b';'+'
assert '{}'-:jd'json ',enc_pjson_ 'update f';'i=23';'b';'+'
assert '{}'-:jd'json ',enc_pjson_ 'delete f';'i=23'






