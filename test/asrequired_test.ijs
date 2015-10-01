NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. tests for as required mapping/readstate/writestate

NB. opening a db does no readstates and no mappings
NB. using a table creates locales for all tables and does readstate for each
NB. using a col creates locales for all cols and does a readstate for each
NB. col files are mapped as required


jdadminx'test'
n=. i.3
jd'createtable f'
jd'createcol f a int'
jd'createcol f b int'
jd'createcol f c int'
jd'createcol f d int'
jd'insert f';'a';n;'b';n;'c';n;'d';n
jd'createhash f a'
jd'createunique f b'
jdadmin 0
jdadmin'test'
assert 0=#mappings_jmf_
jd'reads a from f'
NB. hash/link/unique and dynamic referenced cols are mapped
NB. c and d are not mapped as they are not required
assert 6=#mappings_jmf_

jd'close'
jdadmin 0
cntsclear_jd_''
jdadminx'test'
assert 0 0 0 0-:q=:4{.cntsclear_jd_''
jd'createtable f'
assert 3 0 1 0-:q=:4{.cntsclear_jd_'' 
jd'createcol f a int'
assert 1 0 1 0-:q=:4{.cntsclear_jd_''
assert 2=#mappings_jmf_
jd'insert f a';i.3
assert 0 0 0 0-:q=:4{.cntsclear_jd_''
jd'createcol f b int'
assert 1 0 1 0-:q=:4{.cntsclear_jd_''
assert 3=#mappings_jmf_
jd'insert f';'a';6;'b';7
assert 0 0 0 0-:q=:4{.cntsclear_jd_''

jd'createtable g'
assert 3 0 1 0-:q=:4{.cntsclear_jd_'' 
jd'createcol g a int'
assert 1 0 1 0-:q=:4{.cntsclear_jd_''
assert 5=#mappings_jmf_
jd'insert g a';i.3
assert 0 0 0 0-:q=:4{.cntsclear_jd_''
jd'createcol g b int'
assert 1 0 1 0-:q=:4{.cntsclear_jd_''
assert 6=#mappings_jmf_
jd'insert g';'a';6;'b';7
assert 0 0 0 0-:q=:4{.cntsclear_jd_''

jd'createtable h'
assert 3 0 1 0-:q=:4{.cntsclear_jd_'' 
jd'createcol h c int'
assert 1 0 1 0-:q=:4{.cntsclear_jd_''
assert 8=#mappings_jmf_
jd'insert h c';i.2
assert 0 0 0 0-:4{.cntsclear_jd_''

jd'reference f a g a'
assert 12 0 2 0-:q=: 4{.cntsclear_jd_'' NB. some unnecessary writestates, but they are cheap
assert 14=#mappings_jmf_

jd'close'
assert 0 0 0 0-:q=: 4{.cntsclear_jd_''
assert 0=#mappings_jmf_

jdadmin 'test'
assert 0 3 0 0-:q=: 4{.cntsclear_jd_''
assert 0=#mappings_jmf_

jd'reads a from f'

NB. hash/link mapped
assert 1 6 4 0-:q=: 4{.cntsclear_jd_'' NB. readstate each table and each col in f
assert 4=#mappings_jmf_            NB. only jdactive and a mapped

jd'close'
jd'reads c from h'
assert 0 6 2 0-:q=: 4{.cntsclear_jd_'' NB. readstate each table and each col in h
assert 2=#mappings_jmf_            NB. only jdactive and c mapped

jd'close'
assert 0 0 0 0-:q=: 4{.cntsclear_jd_''
assert 0=#mappings_jmf_

NB. f 3 4 - create 3 tables each with 4 cols
f=: 3 : 0
'tc cc'=. y
for_i. i.tc do.
 tn=.  't',":100000+i
 jd'createtable ',tn
 for_j. i.cc do.
  cn=. 'c',":100000+j
  jd('createcol ',tn,' ',cn,' int _');i.2
 end.
end.
)

jdadminx'test'
f 3 3
assert 18 0 12 0-:q=:4{.cntsclear_jd_''
assert 12=#mappings_jmf_
jdadmin 0
assert 0 0 0 0-:q=:4{.cntsclear_jd_''
assert 0=#mappings_jmf_

jdadmin'test'
assert 0 3 0 0-:q=:4{.cntsclear_jd_''
assert 0=#mappings_jmf_
jd'read c100000 from t100000'
assert 0 5 2 0-:q=:4{.cntsclear_jd_''
assert 2=#mappings_jmf_

jdadmin 0
assert 0 0 0 0-:q=:4{.cntsclear_jd_''
assert 0=#mappings_jmf_
