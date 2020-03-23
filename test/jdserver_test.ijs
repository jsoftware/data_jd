NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

0 : 0
jdserver is a cover on jd that has extra parameters
it is intended for use by an http client
see jdserver=: defn in client.ijs for details
)

jsonok=: }:0 : 0
{
"Jd OK":0
}
)

show=: echo
show=: [ NB. use echo to see stuff

'new'jdadmin'test'
assert jsonok-:jdserver'json json;createtable f'
assert jsonok-:jdserver'json json;createcol f a int'
assert jsonok-:jdserver'json json;createcol f b byte'
assert jsonok-:jdserver'json json;createcol f c byte 4'
assert jsonok-:jdserver'json json;insert f;',jsonenc 'a';23;'b';'x';'c';'asdf'
assert (jd'read from f')-:>each jsondec jdserver'json json;read from f'
assert +./'Jd server error'E. jdserver'json json;reads from f'

tests=: <;._2 [ 0 : 0
XXXXdec jdserver'XXXX XXXX;read from f'
XXXXdec jdserver'XXXX XXXX;info summary'
XXXXdec jdserver'XXXX XXXX;insert f;',XXXXenc'a';666;'b';'q';'c';'qewr'
XXXXdec jdserver'XXXX XXXX;insert f;',XXXXenc'a';5 6 6;'b';'fgh';'c';3 4$'qewrasdfzxcv'
XXXXdec jdserver'XXXX XXXX;insert f;',XXXXenc 'a';666
XXXXdec jdserver'XXXX XXXX;update f;',XXXXenc 'a=666';'a';777
XXXXdec jdserver'XXXX XXXX;infox summary'
XXXXdec jdserver'XXXX XXXX;info xsummary'
XXXXdec jdserver'XXXX XXXX;list version'
XXXXdec jdserver'XXXX XXXX;csvreport'
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
