0 : 0
Jd op can take argument as json list and return result as json dictionary
Jd op that is a string that starts with 'json ' has json arg and result
)

'new'jdadmin'json'

jdjson_jd_ NB. 

jdjson'createtable f' NB. {} json empty dictionary - instead of J empty array i.0 0
jdjson'createcol f i int'
jdjson'createcol f b byte'
jdjson'createcol f b4 byte 4'

[d=. 'insert f';'i';2;'b';'z';'b4';'abc'
[enc_pjson_ d
jdjson d
jd'read from f'
jdjson'read from f'
jdjson'reads from f' NB. json always returns dictionary - reads is the same as read

jdjson'insert f';'i';2;'b';'z';'b4';'abcde' NB. error returned as json dictionary
jdlast

jdjson'delete f';'jdindex>_1'
jdjson'info summary'

jdjson'insert f';'i';3 4;'b';'qw';'b4';2 3$'dgg'
jdjson'read from f'
jdjson'insert f';'i';2;'b';'z';'b4';2 5$'x'

jdjson'delete f';'jdindex>_1'
jdjson'createcol f v varbyte'
jdjson'insert f';'i';23;'b';'x';'b4';'abc';'v';<<'abc'
jdjson'read from f'
jdjson'insert f';'i';23 24;'b';'xy';'b4';(2 3$'abcdef');'v';<'qwer';'asdfasdf'
jdjson'read from f'
jdjson'info summary'

NB. json result is a dictionary
NB. a dictionary can be converted to a list
NB. sometimes you need the list encoding and not the dictionary
NB. e.g if you want to feed the json result of a read to an insert

NB. json - list from dictionary
lfromd=: 3 : 0
d=. }.}:<;.2 y,LF
;(d i.each ':') (','"_`[`])} each d
)

[d=. jdjson'read from f'
[t=. lfromd d
[d=. '[',']',~('"insert f",'),LF,t
jd'json ',d NB. already json encoded
jdjson'read from f'

jdjson'update f';'i=23';'b';'+'
jdjson'read from f'

jdjson'delete f';'i=23'
jdjson'read from f'

jdjson'list version'
