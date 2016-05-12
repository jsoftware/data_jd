NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
tx=: 3 : '<.1000*6!:2 y' NB. milli time

hashint=: 3 : 0
DA=: 2e9,i.y-1 NB. avoid J small range special code
DB=: |.DA
NXT=: #DA
jdadminx'test'
jd'createtable f a int,b int,c int,d int,e int'
jd'insert f';'a';DA;'b';DA;'c';DA;'d';DA;'e';DA
)

ins=: 3 : 0
NB. IT=: jdgl'f jdhash_a'
NB. IQ=: #hash__IT
for. i.y do.
 jd'insert f';'a';NXT;'b';NXT;'c';NXT;'d';NXT;'e';NXT
 NXT=: >:NXT
 NB. assert IQ=#hash__IT
end. 
)

insx=: 3 : 0
d=. NXT+i.y
NXT=: NXT+y
jd'insert f';'a';d;'b';d;'c';d;'d';d;'e';d
)

NB. insert required to update hash is slower but not badly so

NB. insert required to update hash/reference is 4 times slower
NB. but time to build hash reference is very slow

NB. quick test for reference

testrefins=: 3 : 0
DA=: 2e9,i.y-1 NB. avoid J small range special code
DB=: |.DA
NXT=: #DA
jdadminx'test'
jd'createtable f a int'
jd'insert f';'a';DA
jd'createtable g a int'
jd'insert g';'a';DB
NB. jd'reference f a g a'
)

insq=: 3 : 0
d=. NXT+i.y
NXT=: NXT+y
jd'insert f';'a';d
)

0 : 0
19 seconds to build reference between tables with 8e6 rows

5.5 to build each hash (total 11 seconds)
8 seconds to build reference

with faster hash this would be 10 seconds instead of 19 - still a bit slow for 
a single insert and then a read


)
