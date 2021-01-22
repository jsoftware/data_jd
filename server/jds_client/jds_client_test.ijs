NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. mtm demo tests

CONTEXT=: 'jbin jbin http u/p;'

msrx=: 3 : 0
echo y
r=. msr y
echo r
r
)

NB. drop all tables and create table f 
clean=: 3 : 0
t=. ;{:{:msr'info table'
for_a. t do. msrx'droptable ',;a end.
msrx'createtable f'
msrx'createcol f a int'
)

test=: 3 : 0
clean''
msrx'insert f';'a';i.5
assert (i.5)-:>{:{:msr'read from f'
msrx'delete f';'jdindex < 3'
assert 3 4-:>{:{:msr'read from f'
msrx'delete f';'jdindex ge 0'
assert (,:'')-:>{:"1 msr'read from f'
msrx'insert f';'a';i.3
assert (,:i.3)-:>{:"1 msr'read from f'
msrx'update f';'a=1';'a';23
assert (,:0 23 2)-:>{:"1 msr'read from f'
msrx'createtable g'
assert'fg'-:;;{:{: msrx'info table'
msrx'droptable g'
assert(,'f')-:;;{:{: msrx'info table'


a=. 10 10 10 2 #i.4
a=. a{~(#a)?#a
d=: 0
msrx each ". each jobs

NB. varbyte col
msrx'createcol f v varbyte'
msrx'insert f';'a';7 8 9;'v';<'abc';'d';'efgh'
assert'abcdefgh'-:;;{:{: msr'read from f'
i.0 0
)

jobs=: <;._2 [0 : 0
'info summary'
'read count a from f'
'insert f';'a';d[d=: >:d
'update f';'jdindex=1';'a';23
)

msrpid=: 3 : 0
msr y rplc'PID';PID
)

drive=: 3 : 0
echo PID=: ":2!:6''
msrpid'droptable PID'
msrpid'createtable PID'
msrpid'createcol PID  i int'
msrpid('insert ',PID,' ');'i';100000$i.1000
msrpid'read count i from PID where i=',":?1000
for. i.y do.
 msrpid 'read count a from f'
 msrpid('insert ',PID,' ');'i';?1000
 msrpid 'read count a from f'
 msrpid 'read count a from f'
 msrpid 'read count a from f'
 msrpid('insert ',PID,' ');'i';?1000
end.
)

NB. drive 1000
drive1=: 3 : 0
pid=. 2!:6''
for. i.y do.
 for. i.10 do.
  msr'insert f';'a';pid;'v';<<":pid
 end.
 echo msr'read count a from f'
end.
)

drive2=: 3 : 0
i=. 0
for. i.y do.
 NB. echo msr'update f';'jdindex=1';'a';i
 echo msr'read a from f where jdindex=',":i
 i=. >:i
end.
)

drive3=: 3 : 0
for_i. i.y do.
 echo i
 connect''
end.
)

 

