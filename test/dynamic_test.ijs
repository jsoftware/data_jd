NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. dynamic tests - hash unique reference

db=: 'unique'
de=: 'domain error'
ue=: 'not unique'
fe=: 'float not allowed'
ve=: 'varbyte not allowed'
ne=: 'not unique'

NB. float (tolerance) and varbyte not allowed in unique
jdadminx db
jd'gen test f 5'
assert de-:jd etx'createunique f float'
assert fe-:  ;1{jdlast
assert de-:jd etx'createunique f varbyte'
assert ve-:  ;1{jdlast
assert de-:jd etx'createunique f int float'
assert fe-:  ;1{jdlast
assert de-:jd etx'createunique f int varbyte'
assert ve-:  ;1{jdlast

NB. float (tolerance) and varbyte not allowed in hash
jdadminx db
jd'gen test f 5'
assert de-:jd etx'createunique f float'
assert fe-:  ;1{jdlast
assert de-:jd etx'createunique f varbyte'
assert ve-:  ;1{jdlast
assert de-:jd etx'createunique f int float'
assert fe-:  ;1{jdlast
assert de-:jd etx'createunique f int varbyte'
assert ve-:  ;1{jdlast

NB. float (tolerance) and varbyte not allowed in reference
jdadminx db
jd'gen test f 5'
jd'gen test g 5'
assert de-:jd etx'reference f float g float'
assert fe-:  ;1{jdlast
assert de-:jd etx'reference f varbyte g varbyte'
assert ve-:  ;1{jdlast
assert de-:jd etx'reference f int float g int float'
assert fe-:  ;1{jdlast
assert de-:jd etx'reference f int varbyte g int float'
assert ve-:  ;1{jdlast


NB. unique int
jdadminx db
jd'createtable f a int'
jd'insert f a';3,i.5
assert de-:jd etx'createunique f a'
assert ne-:;1{jdlast

jdadminx db
jd'createtable f a int'
jd'createunique f a'
jd'insert f a';i.5
jd'insert f a';23 24 25
assert de-:jd etx'insert f a';26 27 26
assert ue-:(#ue){.;1{jdlast
assert de-:jd etx'insert f a';26 27 3
assert ue-:(#ue){.;1{jdlast

NB. unique byte 2
jdadminx db
jd'createtable f b byte 2'
jd'insert f b';'ef',5 2$'abcdefghij'
assert de-:jd etx'createunique f b'
assert ne-:;1{jdlast

jdadminx db
jd'createtable f b byte 2'
jd'createunique f b'
jd'insert f b';5 2$'abcdefghij'
jd'insert f b';5 2$'bcdefghijk'
assert de-:jd etx'insert f b';3 2$'zzxxzz'
assert ue-:(#ue){.;1{jdlast
assert de-:jd etx'insert f b';3 2$'zzxxcd'
assert ue-:(#ue){.;1{jdlast

NB. unique int byte2
jdadminx db
jd'createtable f a int,b byte 2'
jd'insert f';'a';(2,i.5);'b';'ef',5 2$'abcdefghij'
assert de-:jd etx'createunique f b'
assert ne-:;1{jdlast

jdadminx db
jd'createtable f a int,b byte 2'
jd'createunique f a b'
jd'insert f';'a';(i.5);'b';5 2$'abcdefghij'
jd'insert f';'a';(10++i.5);'b';5 2$'abcdefghij'
assert de-:jd etx'insert f';'a';2 3 2;'b';3 2$'zzxxzz'
assert ue-:(#ue){.;1{jdlast
assert de-:jd etx'insert f';'a';2 3 3;'b';3 2$'zzxxgh'
assert ue-:(#ue){.;1{jdlast

NB. reference 
jd'close' NB. no mappings
jdadminx db
jd'gen ref2 f 10 0 g 5'
jd'dropdynamic'
a=. jd'reads from f'
a=. jd'reads from g'
c=: #mappings_jmf_

NB. reference that will create hash for both sides
jd'reference f aref g bref'
assert (c+6)=#mappings_jmf_ NB. hash aref,link aref,hash bref, link bref, datl, datr 

NB. reference with hash and unique alrady created
jd'dropdynamic'
jd'createhash f aref'
jd'createunique g bref'
jd'reference f aref g bref'
a=. jd'reads from f'
a=. jd'reads from g'
assert (c+5)=#mappings_jmf_ NB. hash aref, link aref, unique bref, datl, datr 

NB. reference g unique that will created required f hash
jd'dropdynamic'
jd'createunique g bref'
jd'reference f aref g bref'
a=. jd'reads from f'
a=. jd'reads from g'
assert (c+5)=#mappings_jmf_ NB. hash aref, link aref,unuiqe bref, datl, datr 

NB. reference with both unique
jd'close'
jdadminx db
jd'gen test f 5'
jd'gen test g 5'
c=: #mappings_jmf_
jd'createunique f int'
jd'createunique g int'
jd'reference f int g int'
a=. jd'reads from f'
a=. jd'reads from g'
assert (c+4)=#mappings_jmf_ NB. unique f, unique g, datl, datr 

NB. reference with shuffle
jdadminx db
jd'gen ref2 f 1000 0 g 100'
jd'dropdynamic' NB. ref vs reference
jd'reference f aref g bref'
jd'reference g bref f aref'
dfg=.  jd'reads from f,f.g order by f.adata'
dgf=.  jd'reads from g,g.f order by f.adata'
dgfo=. jd'reads from g,g=f order by f.adata'

jdshuffle_jd_'f'
jdshuffle_jd_'g'
assert dfg -:jd'reads from f,f.g order by f.adata'
assert dgfo-:jd'reads from g,g=f order by f.adata'

jdshuffle_jd_'f'
jdshuffle_jd_'g'
assert dfg -:jd'reads from f,f.g order by f.adata'
assert dgfo-:jd'reads from g,g=f order by f.adata'

jdshuffle_jd_'f'
jdshuffle_jd_'g'
assert dfg -:jd'reads from f,f.g order by f.adata'
assert dgfo-:jd'reads from g,g=f order by f.adata'

NB. unigue insert after delete
jdadminx db
jd'gen ref2 f 10 0 g 3'
jd'dropdynamic' NB. ref vs reference
jd'createunique g bref'
jd'reference f aref g bref'
d=. jd'reads from f,f.g order by f.aref'
t=. jd'read from f where jdindex=7'
jd'delete f';'jdindex=7'
jd 'insert f';,t
t=. jd'read from g where jdindex=2'
jd'delete g';'jdindex=2'
jd 'insert g';,t
assert d-: jd'reads from f,f.g order by f.aref'

NB. unique shuffle 
jdadminx db
jd'gen ref2 f 1000 0 g 100'
jd'dropdynamic' NB. ref vs reference
jd'createunique g bref'
jd'reference f aref g bref'
jd'reference g bref f aref'
dfg=.  jd'reads from f,f.g order by f.adata'
dgf=.  jd'reads from g,g<f order by f.adata'
dgfo=. jd'reads from g,g=f order by f.adata'

jdshuffle_jd_'f'
jdshuffle_jd_'g'
assert dfg -:jd'reads from f,f.g order by f.adata'
assert dgf  -:jd'reads from g,g<f order by f.adata' NB. < join as . join will be different
assert dgfo-:jd'reads from g,g=f order by f.adata'

jdshuffle_jd_'f'
jdshuffle_jd_'g'
assert dfg -:jd'reads from f,f.g order by f.adata'
assert dgf  -:jd'reads from g,g<f order by f.adata'
assert dgfo-:jd'reads from g,g=f order by f.adata'

jdshuffle_jd_'f'
jdshuffle_jd_'g'
assert dfg -:jd'reads from f,f.g order by f.adata'
assert dgf  -:jd'reads from g,g<f order by f.adata'
assert dgfo-:jd'reads from g,g=f order by f.adata'

