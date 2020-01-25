NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. mtm test DB - server and client 

custom=: 0 : 0 rplc'RPAREN';')' NB. defn for dervive verb
derive_dc=: 3 : 0
{."1 jd_get'g b'
RPAREN
)


custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verbs
derive_bfroma=: 3 : 0
2{."1 jd_get'g a'
RPAREN
)

createmtmdb=: 3 : 0
'new'jdadmin'mtm'
custom fappend jdpath_jd_'custom.ijs'
jdadmin 0
)

NB. y is DB to serve
NB. start new jconsole session and run to start server
runserver=: 3 : 0
load'~Jddev/mtm/mtm.ijs'
init config 'mtm'
)

runclient=: 3 : 0
load'~Jddev/mtm/mtm_client.ijs'
init''
echo'see verb test for examples'
)

NB. tests

msrx=: 3 : 0
echo y
echo msr y
)

test=: 3 : 0

t=.;{:msr'info table'
for_a. t do. msr'droptable ',a end.

msrx'createtable f'
msrx'createcol f a int'
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
assert'fg'-:,>{:msr'info table'
msrx'droptable g'
assert(,'f')-:,>{:msr'info table'

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
mgetw each ;msnd each ".each a{jobs
mgetw msnd'droptable done'

assert 0=#rids
assert 0=#results
i.0 0
)

jobs=: <;._2 [0 : 0
'info summary'
'read count a from f'
'insert f';'a';d[d=: >:d
'update f';'jdindex=1';'a';23
)

