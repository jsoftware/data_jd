jdadminx'test'

NB. droptable
jd'gen test f 3'
jd'droptable f'
jd'gen test f 3'
jd'createhash f int'
jd'droptable f'
jd'gen test f 3'
jd'gen test g 3'
jd'reference f int g int'
'reference'jdae'droptable f'
'reference'jdae'droptable g'
jd'dropdynamic reference f int g int'
jd'droptable f'
jd'droptable g'

NB. droptable /reset
jd'gen test f 0'
d0=: jd'read from f'
jd'gen test f 3'
d3=: jd'read from f'
jd'droptable /reset f'
assert d0-:jd'read from f'
jd'insert f';,d3
assert d3-:jd'read from f'

jd'gen test g 3'
jd'reference f int g int'
'reference'jdae'droptable f'
'reference'jdae'droptable g'
'reference'jdae'droptable /reset f'
'reference'jdae'droptable /reset g'

jd'dropdynamic'
jd'createhash f int'
jd'createunique f byte4'
jd'droptable /reset f'
assert d0-:jd'read from f'


NB. ptable
jdadminx'test'
jd'createtable f'
jd'createcol f set int'
jd'createcol f a int'
jd'createptable f set'
jd'insert f';'set';(6$2012 2013);'a';i.6
jd'droptable f'
assert 0=#dir'~temp/jd/test/f*'
