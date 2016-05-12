NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. test droptable dropcol renametable renamecol

test=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f a int _';i.5
jd'createcol f b int _';i.5
jd'createtable g'
jd'createcol g a int _';i.5
jd'createcol g b int _';i.5
)

NB. droptable
test''
jd'droptable f'

test''
jd'createhash f a'
jd'droptable f' NB. works with hash

test''
jd'reference f a g a'
assert 'domain error'-:jd etx'droptable f' NB. fails with reference

NB. dropcol
test''
jd'dropcol f a'

test''
jd'createhash f a b'
'domain error'-:jd etx'dropcol f a' NB. fails with hash

test''
jd'reference f a g a'
'domain error'-:jd etx'dropcol f a' NB. fails with reference

NB. renametable
test''
jd'renametable f foo'
t=. jdgl_jd_'foo'
assert 'foo'-:NAME__t
jd'renametable foo boo'
t=. jdgl_jd_'boo'
assert 'boo'-:NAME__t

test''
jd'createhash f a'
jd'createhash g a b'
jd'renametable f foo' NB. works with hash
jd'renametable g goo'

test''
jd'reference f a g a'
'domain error'-:jd etx'renametable f foo' NB. fails with reference

NB. renamecol
test''
jd'renamecol f a aaa'
jd'renamecol f aaa x'
jd'renamecol f x aaaa'
jd'reads aaaa from f'

'jd'jdae'renamecol f jdindex adsf'
'jd'jdae'renamecol f aaaa    jdadsf'
'not found'jdae'renamecol f asdf qewr'
'already exists'jdae'renamecol f aaaa b'


test''
jd'createhash f a'
assert'domain error'-:jd etx'renamecol f a aaa' NB. fails with hash

test''
jd'reference f a g a'
assert'domain error'-:jd etx'renamecol f a aaa' NB. fails with reference



