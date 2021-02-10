jdjson=: 3 : 0
if. L.y do.
 jds'json json;',(;{.y),LF,jsonenc}.y
else.
 jds'json json;',y
end.
)

'new'jdadmin'json'
jdjson 'createtable f' NB. {} json empty dictionary - instead of J empty array i.0 0
jdjson 'createcol f i int'
jdjson 'createcol f b byte'
jdjson 'createcol f b4 byte 4'

jdjson 'insert f';'i';2;'b';'z';'b4';'abc'
jdjson 'read from f'

jdjson 'insert f';'i';2;'b';'z';'b4';'abc'
jdjson 'insert f';'i';3 4 5;'b';'abc';'b4';3 4$'abcdefghijkl'
jdjson 'read from f'  NB. json always returns a dictionary
jdjson 'reads from f' NB. reads is an error

jdjson'insert f';'i';2;'b';'z';'b4';'abcde' NB. error returned as json dictionary
jdlast

jdjson'delete f';'jdindex>_1'
jdjson'info summary'

jdjson'insert f';'i';3 4;'b';'qw';'b4';2 3$'dgg'
jdjson'read from f'
jdjson'insert f';'i';2;'b';'z';'b4';2 5$'x' NB. error bad shape

jdjson'delete f';'jdindex>_1'
jdjson'createcol f v varbyte'
jdjson'insert f';'i';23;'b';'x';'b4';'abc';'v';<<'abc'
jdjson'read from f'
jdjson'insert f';'i';23 24;'b';'xy';'b4';(2 3$'abcdef');'v';<'qwer';'asdfasdf'
jdjson'read from f'
jdjson'info summary'

jdjson'createtable g'
jdjson'read from g'

NB. json result is a dictionary
NB. dictionary can be converted to a list
NB. sometimes you need the list encoding and not the dictionary
NB. e.g if you want to feed the json result of a read to an insert

lfromd=: 3 : 0 NB. json - list from dictionary
d=. }.}:<;.2 y,LF
'[',']',~;(d i.each ':') (','"_`[`])} each d
)

d=. jdjson 'read from f'
[lfromd d
NB. t already has the json encoded pairs so can't use jdjson helper verb
jds 'json json;insert f',LF,lfromd d
jdjson 'read from f'

jdjson'update f';'i=23';'b';'+'
jdjson'read from f'

jdjson'delete f';'i=23'
jdjson'read from f'

jdjson'list version'
