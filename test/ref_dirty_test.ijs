NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
jdadminx'test'
jd'gen ref2 f 5 2 g 3'
c=. jdgl_jd_'f jdref_aref_g_bref'
assert 1=dirty__c
jd'reads from f,f.g'
assert 0=dirty__c

NB. update of uninvolved cols
jd'update f';'jdindex=1';'a0';12{.'new stuff'
assert 0=dirty__c
jd'update g';'jdindex=1';'bb12';12{.'new stuff'
assert 0=dirty__c

NB. update of involved cols
jd'update f';'jdindex=1';'aref';2
assert 1=dirty__c
jd'reads from f,f.g'
assert 0=dirty__c
jd'update g';'jdindex=2';'bref';1;'bb12';12{.'should show'
assert 1=dirty__c
jd'reads from f,f.g'
assert 0=dirty__c

NB. delete right - should mark dirt
jd'delete g';'jdindex=1'
assert 1=dirty__c
jd'reads from f,f.g'

NB. delete left - should not mark dirty
jd'delete f';'jdindex=1'
assert 1=dirty__c
jd'reads from f,f.g'
assert 0=dirty__c

NB. insert left
jd'insert f';'akey';23;'adata';24;'aref';7;'a0';(,:'how now');'a1';,:'brown cow'
assert 1=dirty__c
jd'reads from f,f.g'
assert 0=dirty__c

NB. insert right
jd'insert g';'bref';7;'bb12';,:'hit it'
assert 1=dirty__c
jd'reads from f,f.g'
assert 0=dirty__c

NB. f->g f->h
jdadminx'test'
jd'createtable f'
jd'createcol f a int _';7$i.3
jd'createcol f b int _';7$i.4
jd'createcol f c byte _';'abcdefg'
jd'reads from f'

jd'createtable g'
jd'createcol g d int _';i.3
jd'createcol g e byte _';'qwe'
jd'reads from g'

jd'createtable h'
jd'createcol h n int _';i.4
jd'createcol h m byte _';'zxcv'
jd'reads from h'

jd'createtable i'
jd'createcol i r int _';i.4
jd'createcol i t int _';i.4
jd'createcol i y byte _';'jklm'
jd'reads from i'

jd'ref f a g d'
jd'ref f b h n'
jd'ref f a b i r t'
jd'reads from f,f.g,f.h,f.i'

jd'ref g d f a'
jd'reads from g,g.f'

t=. jd'reads from f,f.g,f.h,f.i'
t
assert 'qweqweq'-:,'g.e'jdfroms_jd_ t
assert 'zxcvzxc'-:,'h.m'jdfroms_jd_ t
assert 'jkl    '-:,'i.y'jdfroms_jd_ t

tf=. jdgl_jd_'f'
tg=. jdgl_jd_'g'
th=. jdgl_jd_'h'
ti=. jdgl_jd_'i'
fg=. jdgl_jd_'f jdref_a_g_d'
fh=. jdgl_jd_'f jdref_b_h_n'
fi=. jdgl_jd_'f jdref_a_b_i_r_t'
gf=.jdgl_jd_'g jdref_d_f_a'

SUBSCR__tf
SUBSCR__tg
SUBSCR__th
SUBSCR__ti
subscriptions__fg
subscriptions__fh
subscriptions__fi
subscriptions__gf

get_subscr_jdtable_=: 3 : 0
ns=. NAMES#~(<'jdref')=5{.each NAMES
for_n. ns do.
 echo n
end.
)


