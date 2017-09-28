NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

NB. y is pcol type
bld=: 3 : 0
jdadminx'test'

jd'createtable j'
jd'createcol   j a int _';i.4
jd'createcol   j v int _';1000+i.4

jd'createtable f'
jd'createcol   f set ',y
jd'createcol   f val int'
jd'createcol   f a   int'
jd'ref   f a j a'

jd'createptable f set'

jd'createtable base'
jd'createcol   base set ',y
jd'createcol   base val int'
jd'createcol   base a   int'
jd'ref         base a j a'
)

nv=. 'set';2011 2011 2011 2012 2012 2012;'val';(6$i.2);'a';6$i.4

bld'int'
jd'insert base';nv
jd'insert f';nv
a=: jd'reads from base,base.j order by base.set'
b=: jd'reads from f,f.j'
assert ({:a)-:{:b

assert 2011 2012-:;{:{:jd'read from f^'
jd'insert f';'set';2016;'val';22;'a';23
assert 2011 2012 2016-:;{:{:jd'read from f^'
jd'insert f';'set';2009;'val';22;'a';23
assert 2009 2011 2012 2016-:;{:{:jd'read from f^' NB. f; is sorted

bld'edate'
nv=. 'set';(sfe_jd_ efs_jd_ 6 4$'201120112011201220122012');'val';(6$i.2);'a';6$i.4
jd'insert f';nv
jd'insert base';nv
assert (jd'reads from base')-:jd'reads from f'

nv=. 'set';0;'val';23;'a';24
jd'insert f';nv
jd'insert base';nv
assert (jd'reads from base order by set')-:jd'reads from f order by set'

nv=. 'set';(efs_jd_ '2016',:'2017');'val';27 28;'a';29 30
jd'insert f';nv
jd'insert base';nv
assert (jd'reads from base order by set')-:jd'reads from f order by set'

nv=. 'set';(1 4$'2020');'val';30;'a';31
jd'insert base';nv
jd'insert f';nv
assert (jd'reads from base order by set')-:jd'reads from f order by set'

nv=. 'set';(2 4$'20302031');'val';30 31;'a';31 32
jd'insert base';nv
jd'insert f';nv
assert (jd'reads from base order by set')-:jd'reads from f order by set'

nv=. 'set';('2030');'val';30;'a';31
jd'insert base';nv
jd'insert f';nv
assert (jd'reads from base order by set')-:jd'reads from f order by set'

