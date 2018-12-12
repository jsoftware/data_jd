jdadminnew'test'

bld=: 3 : 0
jd'createtable a id int,name byte'
jd'createtable b id int,amt float,name byte,cate byte'
)

bld''
jd'ref b id a id'
jd'reads from b,b.a'
jd'reads from b,b.a where a.id="b"'
jd'reads from b,b.a where b.id="b"' NB. should not be error
