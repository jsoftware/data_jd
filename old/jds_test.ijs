NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

0 : 0
jds is a cover on jd that has extra parameters
it is intended for use by an http client
see jds=: defn in client.ijs for details
)

jsonok=: }:0 : 0
{
"Jd OK":0
}
)

show=: echo
show=: [ NB. use echo to see stuff

'new'jdadmin'test'
assert jsonok-:jds'json json test u/p;createtable f'
assert jsonok-:jds'json json test u/p;createcol f a int'
assert jsonok-:jds'json json test u/p;createcol f b byte'
assert jsonok-:jds'json json test u/p;createcol f c byte 4'
assert jsonok-:jds'json json test u/p;insert f',LF,jsonenc 'a';23;'b';'x';'c';'asdf'
assert (jd'read from f')-:>each jsondec jds'json json test u/p;read from f'
assert +./'Jd server error'E. jds'json json test u/p;reads from f'

tests=: <;._2 [ 0 : 0
XXXXdec jds'XXXX XXXX test u/p;read from f'
XXXXdec jds'XXXX XXXX test u/p;info summary'
XXXXdec jds'XXXX XXXX test u/p;insert f',LF,XXXXenc'a';666;'b';'q';'c';'qewr'
XXXXdec jds'XXXX XXXX test u/p;insert f',LF,XXXXenc'a';5 6 6;'b';'fgh';'c';3 4$'qewrasdfzxcv'
XXXXdec jds'XXXX XXXX test u/p;insert f',LF,XXXXenc 'a';666
XXXXdec jds'XXXX XXXX test u/p;update f',LF,XXXXenc 'a=666';'a';777
XXXXdec jds'XXXX XXXX test u/p;infox summary'
XXXXdec jds'XXXX XXXX test u/p;info xsummary'
XXXXdec jds'XXXX XXXX test u/p;list version'
XXXXdec jds'XXXX XXXX test u/p;csvreport'
)

run=: 3 : 0
for_n. y do.
 show '                                        ',t=. (;n) rplc 'XXXX';'jbin'
 show a=. ".t
 show '                                        ',t=. (;n) rplc 'XXXX';'json'
 show b=. ".t
 'jbin and json differ' assert (a-:b)+.(a-:>each b)+.(a-:>each |:b)+.'Jd server error'-:;{.{.a
end.
)

run tests
