
jdadminnew'tutorial'
jd'gen test f 2'
jd'reads from f' NB. labeled cols
jd'read  from f' NB. labeled rows (same as reads /lr)

0 : 0
labeled cols can be convenient for display to the user
but loses some info about the actual data
everything is a matrix even if the actual data is a list
varbyte data is opened
)

$each{:jd'reads from f'        NB. reads data is 2 by N
$each{:"1 jd'reads /lr from f' NB. read  data has actual shape

0 : 0
pairs - list of name,value pairs
pairs are args to insert, update, and other ops
)

[d=: 'a';2 3;'b';2 3$'abcdef' NB. list of name,value pairs
jd'createtable /replace g a int,b byte 3'
jd'insert g';d
[r=: jd'read from g' NB. result
,r NB. ravel of read result is pairs

jd'insert g';'a';23;'b';3 3$'z'   NB. data extends
jd'read from g'
jd'insert g';'a';23;'b';3 2$'a'   NB. byte N col extends with blanks
jd'read from g'
'bad shape'jdae'insert g';'a';23;'b';3 5$'a' NB. byte N data not discarded
