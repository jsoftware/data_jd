NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

tx=: 3 : '<.1000*6!:2 y' NB. milli time

NB. 2e6+1 rows hashes better than 2e6 rows - perhaps related to why hash should be a prime

NB. build int data for J and Jd hashing
NB. 3333333333333333333 avoids J small range special code and (perhaps) ignored columns
NB. x 1 adds extra row (better hash from better residue)
hashint=: 3 : 0
DA=: 3333333333333333333,i.y-1 NB. avoid J small range special code
jdadminx'test'
jd'createtable f a int'
jd'insert f a';DA
)

NB. build byte 35 data for J and Jd hashing
NB. q row avoids (perhaps) ignored columns
NB. x 1 adds extra row (better hash from better residue)
hashbyte=: 3 : 0
t=. <:y
DA=: (35$'q'),((t,13)$'a'),.(9":"0[1e8+i.t),.(t,13)$'b'
jdadminx'test'
jd'createtable f a byte ',":{:$DA
jd'insert f a';DA
)

J=:   'DA&i.'
H=:   'jd''createunique f a'''
MMO=: 'mmo #DA'

timeit=: 3 : 0
jd'dropdynamic'
j=. tx J      NB. J time - hash calculation only
h=. tx H      NB. hash time - hash calculation plus memory management
m=. tx MMO    NB. memory management overhead to do hash
e=. m+j       NB. estimate what hash time should be (mmo + j)
(#DA),j,h,m,e,<.100*h%e
)

NB. memory management overhead (creatjmf/map/init/set)
NB. used to estimate what the Jd hash time should be
NB. hash with memory management overhead and no 0 hash calculation
NB.  hash created and set _1
NB.  hash set to 2
mmo=: 3 : 0
rows=. y
fh=: jpath'~temp/fh.jmf'
jdcreatejmf_jd_ fh;8*2*rows
jdmap_jd_'hash';fh
hash=: (2*rows)#_1
hash=: (2*rows)#2
jdunmap_jd_'hash'
i.0 0
)

hashint 4e6
assert 1000 > (0~:nc<'DLLDEBUG__')*{:timeit''

hashbyte 4e6
assert 1000 > (0~:nc<'DLLDEBUG__')*{:timeit''
