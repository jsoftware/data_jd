NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. timings for ref2 tables csv dump/restore

0 : 0
test arows acols brows
test 10    1     5

jd'gen ref2 arows acols brows' create tables a and b
tables are csv dumped and restored
operations are timed and reported
useful in stress testing larger data against hardware (particularly ram)

test 10    2  3     NB. creats small tables and runs quickly
test 50e6  10 10000 NB. runs in a few minutes with 6gb
test 300e6 10 10000 NB. runs in a few minutes with 24gb - thrashes with less
)

f=: 3 : 'y,~'' '',~6j1 ":timex ''jd y'''

CSVFOLDER=: '~temp/jd/csv/junk'

test=: 3 : 0
jddeletefolder_jd_ CSVFOLDER
assert 3=#y
assert y>:10 0 3
assert ({.y)>:{:y
'arows acols brows'=. 10":each y
jd'close'
jdadmin 0
jdadminx'test'
r=. 0 2$''
r=. r,f 'gen ref2 a ',arows,' ',acols,' b ',brows
r=. r,f s  NB. first may be slow as akey/adata/aref need to be read from disk
r=. r,f s
r=. r,f s
assert 12 4-:,;{:jd s
r=. r,f 'csvdump'
jdadminx'test'
r=. r,f 'csvrestore'
r=. r,f s  NB. first may be slow as akey/adata/aref need to be read from disk
r=. r,f s
r=. r,f s
assert 12 4-:,;{:jd s NB. first may be slow as akey/adata/aref need to be read from disk
r=. r,(6j1":+/;".each 6{.each <"1 r),' total'
r=. r,' '
r=. r,(14j9 ": 1e9%~fsize CSVFOLDER,'a.csv'),' GB - fsize a.csv'
r=. r,(14j9 ": 1e9%~fsize CSVFOLDER,'b.csv'),' GB - fsize b.csv'
r
)

