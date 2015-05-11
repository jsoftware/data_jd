NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. where is covered in other tutorials - e.g., see reads tutorial

NB. advanced use of where is covered here

NB. multiple cols allows fast hash lookup
jdadminx'test'
jd'createtable f a int,b int'
jd'insert f';'a';d;'b';d=.6$i.3
jd'read from f'

jd'read from f where a=0 and b=0'
jd'read from f where a,b=0,0'

NB. previous where clauses are equivalent
NB. but a,b with hash will use hash lookup and will be faster
NB. a,b syntax is easy for the parser to know to use hash lookup

jd'createhash f a b'
jd'read from f where a=0 and b=0' NB. does not use hash
jd'read from f where a,b=0,0'     NB. uses hash and is faster
jd'read from f where a,b in (1,2),(1,2)' NB. uses hash
jd'read from f where a,b in (1,2),(2)'   NB. uses hash

NB. hash lookup isn't much faster if data is in memory
NB. hash lookup is MUCH faster if it avoids file reads
