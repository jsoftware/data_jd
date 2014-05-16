NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
db=: 'testhash'

t1=: 3 : 0
jdadminx db
d=: i.5
jd'createtable f a int, b int'
jd'insert f';'a';d;'b';d
jd'createtable g a int,b int'
jd'insert g';'a';d;'b';d
)

tr=: 3 : 0
jd'reference f a g a'
)

tru=: 3 : 0
jd'createunique f a'
jd'createunique g a'
jd'reference f a g a'
)

t2=: 3 : 0
jd'update f';'a=1';'b';23
jd'update g';'a=2';'b';24
jd'delete f a=3'
jd'insert f';'a';3;'b';25
jd'delete g a=4'
jd'insert g';'a';4;'b';26
jd'reads from f,f.g order by f.a'
)

NB. reference f a g a - one to one
NB. r random updates of f - preserving f.a
NB. r random updates of g - preserving g.a
t3=: 3 : 0
'r c'=. y
d=. i.c
jdadminx db
jd'createtable f a int, b int'
jd'insert f';'a';d;'b';d
jd'createtable g a int,b int'
jd'insert g';'a';d;'b';d
jd'reference f a g a'

fb=. i.c
gb=. i.c


n=. c
for_i. r$c?c do.
 n=. >:n
 jd'update f';('a=',":i);'b';n
 fb=. n i}fb
end.

n=. c
for_i. r$c?c do.
 n=. >:n
 jd'update g';('a=',":i);'b';n
 gb=. n i}gb
end.

q__=: t=. (<,.i.c),(<,.fb),(<,.i.c),<,.gb
assert t-:   ,}.jd'reads from f,f.g order by f.a'
)

NB. reference f a b g a b - one to one
NB. r random updates of f - preserving f.a
NB. r random updates of g - preserving g.a
t4=: 3 : 0
'r c'=. y
d=. i.c
jdadminx db
jd'createtable f a int,b int,c int'
jd'insert f';'a';d;'b';d;'c';d
jd'createtable g a int,b int,c int'
jd'insert g';'a';d;'b';d;'c';d
jd'reference f a b g a b'

fc=. i.c
gc=. i.c

n=. c
for_i. r$c?c do.
 n=. >:n
 jd'update f';('a=',":i);'c';n
 fc=. n i}fc
end.

n=. c
for_i. r$c?c do.
 n=. >:n
 jd'update g';('a=',":i);'c';n
 gc=. n i}gc
end.

q__=: t=. (<,.i.c),(<,.i.c),(<,.fc),(<,.i.c),(<,.i.c),<,.gc
assert t-:   ,}.jd'reads from f,f.g order by f.a'
)

NB. reference f a g a - many to one
NB. r random updates of f - preserving f.a
NB. r random updates of g - preserving g.a
t5=: 3 : 0
'r c'=. y
d=. i.c
dd=. (3*c)$i.c
jdadminx db
jd'createtable f a int, b int'
jd'insert f';'a';dd;'b';i.3*c
jd'createtable g a int,b int'
jd'insert g';'a';d;'b';d
jd'reference f a g a'

fb=. i.c
gb=. i.c

n=. c
for_i. r$c?c do.
 n=. >:n
 jd'update f';('a=',":i);'b';3#n
 fb=. n i}fb
end.

n=. c
for_i. r$c?c do.
 n=. >:n
 jd'update g';('a=',":i);'b';n
 gb=. n i}gb
end.

q__=: t=. (<,.3#i.c),(<,.3#fb),(<,.3#i.c),<,.3#gb
assert t-:   ,}.jd'reads from f,f.g order by f.a'
)

t3 200 100
t4 200 100
t5 200 100





