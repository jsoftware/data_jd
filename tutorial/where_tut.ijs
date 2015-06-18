NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. where is covered in other tutorials - e.g., see reads tutorial

NB. advanced use of where is covered here

NB. multiple cols allows fast hash lookup
jdadminx'test'
jd'createtable f a int,b int'
jd'insert f';'a';(i.4);'b';4+i.4
jd'read from f'

jd'read from f where a=0 and b=4'
jd'read from f where a,b=0,4'

NB. previous where clauses are equivalent
NB. but a,b with hash will use hash lookup and will be faster
NB. a,b syntax is easy for the parser to know to use hash lookup

jd'createhash f a b'
[a=. jd'read from f where a=1 and b=5' NB. does not use hash
[b=. jd'read from f where a,b=1,5'     NB. uses hash and is faster
assert a-:b
[a=.jd'read from f where (a=1 and b=5) or (a=3 and b=7)' 
[b=. jd'read from f where a,b in (1,5),(3,7)' NB. uses hash
assert a-:b

NB. hash lookup isn't much faster if data is in memory
NB. hash lookup is MUCH faster if it avoids file reads
