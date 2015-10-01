NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. createunique creates a dynamic col based on 1 or more cols
NB. similar to createhash except duplicates are not allowed
NB. unique col can be used in a reference - see join tutorial
NB. where clause lookup uses unique col for fast lookup

jdadminx'unique'
jd'createtable f'
jd'createcol f a1 int _';i.1000
jd'createcol f a2 int _';10000+i.1000
jd'reads from f where jdindex<10'

NB. where reads all data from disk for 1000 comparisons
jd'reads from f where a1=4'

jd'createunique f a1' NB. create dynamic unique col for fast lookup

jd'reads from f where a1=4' NB. hashed lookup is much faster

NB. timing difference with small table with data in memory is minimal
NB. timing difference with big table with data not in memory is significant


NB. create table for hashed lookup tests
NB. takes a minute if not already created
cr=: 3 : 0
t=. '~temp/hashed'
if. fexist t,'/h50e6/jdhash_bh/hash' do. jdadmin t return. end.
jdadminx t
n=. 50e6
t=. 'h50e6'
jd'droptable ',t
jd'createtable ',t
jd('createcol ',t,' a  int _');13*i.n
jd('createcol ',t,' au int _');13*i.n
c=. 10000<.2>.<.n%10
jd('createcol ',t,' b int _');13*n$i.c
jd('createcol ',t,' bh int _');13*n$i.c
jd'createunique ',t,' au'
jd'createhash '  ,t,' bh'
)

cr'' NB. create table if it does not already exist

NB. for more interesting results in hashed lookup performance
NB. shutdown and restart your system and then restart or resume the tutorial
NB. this will show how hashed lookup can avoid slow reads of disk

jd'info summary'
jd'info schema h50e6'
jd'info unique'
jd'info hash'

txau=. jdtx'reads from h50e6 where au=13000' NB. hashed - not in ram if restart
txa=. jdtx'reads from h50e6 where a=13000'   NB. normal - not in ram if restart
txa%txau NB. factor that hashed is faster than normal lookup - after restart

txau=. jdtx'reads from h50e6 where au=13000' NB. hashed - in ram
txa=. jdtx'reads from h50e6 where a=13000'   NB. normal - in ram
txa%txau NB. factor that hashed is faster than normal with data in ram

txbh=: jdtx'reads count jdindex from h50e6 where bh=13000' NB. hashed - not in ram if restart
txb=:  jdtx'reads count jdindex from h50e6 where b=13000'  NB. normal - not in ram if restart
txb%txbh NB. factor hashed is faster than normal - after restart

NB. scattered reads of link gives very bad performance
NB. reading in link first makes a big difference
NB. sequential read of link takes 4 seconds and scattered reads takes 14

txbh=: jdtx'reads count jdindex from h50e6 where bh=13000' NB. hashed - in ram
txb=:  jdtx'reads count jdindex from h50e6 where b=13000'  NB. normal - in ram
txb%txbh NB. factor hashed is faster than normal with data in ram

NB. createunique signals a warning error if not unique
NB. the error warns that older rows which are dups have been deleted

NB. insert signals a warning error if not unique
NB. the error warns that older rows (possibly in the new rows)
NB. which are dups have been deleted

NB. createunique on an empty col
jdadminx'test'
jd'createtable g a int'
jd'createunique g a'
jd'insert g a';i.5
jd'reads jdindex,a from g'
jd etx'insert g a';2 NB. 2 duplicates older row
;1{jdlast
jd'reads jdindex,a from g' NB. jdindex 2 deleted


NB. createunique on a col
jdadminx'test'
jd'createtable g a int'
jd'insert g a';i.5
jd'createunique g a'

NB. createunique on a col that has dups
jdadminx'test'
jd'createtable g a int'
jd'insert g a';2,i.5
jd etx 'createunique g a'
;1{jdlast
jd'reads jdindex,a from g' NB. jdindex 0 deleted

NB. createunique on multiple cols
jdadminx'test'
jd'createtable g a int,b byte'
jd'insert g';'a';1 2 3;'b';'abc'
jd'createunique g a b'
jd etx'insert g';'a';4 2;'b';'db'
;1{jdlast
jd'reads jdindex,a,b from g' NB. jdindex 1 deleted
