NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. mtm demo tests

msrx=: 3 : 0
echo y
r=. msr y
echo r
r
)

NB. drop all tables and create table f 
clean=: 3 : 0
t=.;{:msrx'info table'
for_a. t do. msrx'droptable ',a end.
msrx'createtable f'
msrx'createcol f a int'
)

test=: 3 : 0
clean''
msrx'insert f';'a';i.5
assert (i.5)-:>{:{:q=:msr'read from f'
msrx'delete f';'jdindex < 3'
assert 3 4-:>{:{:msr'read from f'
msrx'delete f';'jdindex ge 0'
assert (,:'')-:>{:"1 msr'read from f'
msrx'insert f';'a';i.3
assert (,:i.3)-:>{:"1 msr'read from f'
msrx'update f';'a=1';'a';23
assert (,:0 23 2)-:>{:"1 msr'read from f'
msrx'createtable g'
assert'fg'-:,>{:msrx'info table'
msrx'droptable g'
assert(,'f')-:,>{:msrx'info table'

NB. test derived col
msrx'createtable g'
msrx'createcol g a byte 4'
msrx'insert g';'a';3 4$'abcdefghijklmonop'
msrx'createdcol g b byte 2 bfroma'
msrx'reads from g'
msrx'insert g';'a';'zzzz'
msrx'reads from g'
msrx'update g';'a="ijkl"';'a';'qqqq'
msrx'reads from g'
assert 'abefqqzz'-:,>{:msr'reads b from g'


a=. 10 10 10 2 #i.4
a=. a{~(#a)?#a
d=: 0
msrx each ". each jobs
i.0 0
)

jobs=: <;._2 [0 : 0
'info summary'
'read count a from f'
'insert f';'a';d[d=: >:d
'update f';'jdindex=1';'a';23
)

NB. drive 1000
drive=: 3 : 0
pid=. 2!:6''
for. i.y do.
 for. i.10 do.
  msr'insert f';'a';pid
 end.
 echo msr'read count a from f'
end.
)

