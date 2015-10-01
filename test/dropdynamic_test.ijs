NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. dropdynamic tests

foo=: 3 : 0
jdadminx'test'
jd'gen one f 10 3'
jd'gen one g 5 3'
jd'reference f a0 g a1'
)

foo''
assert (<,:'jdreference_a0_g_a1')-:{:{:jd'info reference'
assert (,.'jdhash_a0',:'jdhash_a1')-:>{:{:jd'info hash'

jd'dropdynamic'
assert ''-:,;{:{:jd'info reference'
assert ''-:,;{:{:jd'info hash'

foo''
assert 'jdreference_a0_g_a1'-:,;{:{:jd'info reference'
f=. jdgl_jd_'f'
assert 2=#SUBSCR__f
assert 1=fexist PATH__f,'jdreference_a0_g_a1/datl'
assert 1=fexist PATH__f,'jdreference_a0_g_a1/datr'
g=. jdgl_jd_'g'
assert 2=#SUBSCR__g
r=. jdgl_jd_'f jdreference_a0_g_a1'
assert 5=#datr__r
assert 10=#datl__r

jd'dropdynamic reference f a0 g a1'
assert ''-:,;{:{:jd'info reference'
f=. jdgl_jd_'f'
assert 1=#SUBSCR__f
g=. jdgl_jd_'g'
assert 1=#SUBSCR__g
assert 0=fexist PATH__f,'jdreference_a0_g_a1/datl'
assert 0=fexist PATH__f,'jdreference_a0_g_a1/datr'

jd'dropdynamic hash f a0'



foo''
assert 'domain error'-:jd etx'dropdynamic reference f a0 g a0'

jd'reference f a1 g a2'
jd'dropdynamic reference f a0 g a1'
assert 'jdreference_a1_g_a2'-:,;{:{:jd'info reference'
f=. jdgl_jd_'f'
assert 3=#SUBSCR__f
g=. jdgl_jd_'g'
assert 3=#SUBSCR__g
assert 0=fexist PATH__f,'jdreference_a0_g_a1/datl'
assert 0=fexist PATH__f,'jdreference_a0_g_a1/datr'

foo''
jd'dropdynamic'
jd'reference f a0 a1 g a0 a1'
jd'dropdynamic reference f a0 a1 g a0 a1'
assert ''-:,;{:{:jd'info reference'

foo''
jd'dropdynamic reference f a0 g a1'
jd'dropdynamic hash f a0'
jd'dropdynamic hash g a1'
assert ''-:,;{:{:jd'info reference'
assert ''-:,;{:{:jd'info hash'

foo''
jd'dropdynamic'
jd'createunique f a0'
jd'createunique g a1'
jd'reference f a0 g a1'
jd'dropdynamic reference f a0 g a1'
jd'dropdynamic unique f a0'
jd'dropdynamic unique g a1'
assert ''-:,;{:{:jd'info reference'
assert ''-:,;{:{:jd'info hash'
