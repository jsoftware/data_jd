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
jd'ref f a g a'
assert 'domain error'-:jd etx'droptable f'

NB. dropcol
test''
jd'dropcol f a'

test''
jd'ref f a g a'
'domain error'-:jd etx'dropcol f a' NB. fails with ref

NB. renametable
test''
jd'renametable f foo'
t=. jdgl_jd_'foo'
assert 'foo'-:NAME__t
jd'renametable foo boo'
t=. jdgl_jd_'boo'
assert 'boo'-:NAME__t

test''
jd'renametable f foo' NB. works with hash
jd'renametable g goo'

test''
jd'ref f a g a'
'domain error'-:jd etx'renametable f foo' NB. fails with ref

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
jd'ref f a g a'
assert'domain error'-:jd etx'renamecol f a aaa' NB. fails with ref

NB. test drop jdref col
jdadminx'test'
jd'gen ref2 f 6 3 g 3'
assert (,'f')-:,;{.{:jd'info ref'
jd'reads from f,f.g'
jd'dropcol f jdref_aref_g_bref'
assert ''-:,;{.{:jd'info ref'
'not find'jdae'reads from f,f.g'

jdadminx'test'
jd'gen ref2 f 6 3 g 3'
jd'ref g bref f akey'
assert 'fg'-:,;{.{:jd'info ref'
jd'reads from f,f.g'
jd'dropcol f jdref_aref_g_bref'
assert (,'g')-:,;{.{:jd'info ref'
'not find'jdae'reads from f,f.g'
jd'dropcol g jdref_bref_f_akey'
assert ''-:,;{.{:jd'info ref'
'not find'jdae'reads from g,g.f'




