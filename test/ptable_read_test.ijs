NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

require JDP,'tools/ptable.ijs'

chk=: 3 : 0
'select where xtra'=: y
if. (0~:#where)*.0~:#xtra do. xtra=. ' and ',xtra end.
s1=: 'reads      ',select,' from ptab where ',where,' ',xtra
a=: jd s1
s2=: 'reads ',select,' from f    where ',where,' ',xtra
b=: jd s2
if. -.a-:b do.
 assert (,.&.> tsort_jd_ {:a)-:,.&.> tsort_jd_ {:b
end.

s1x=: 'reads /lr      ',select,' from ptab where ',where,' ',xtra
ax=: jd s1x
s2x=: 'reads /lr ',select,' from f    where ',where,' ',xtra
bx=: jd s2x
if. -.ax-:bx do.
 axs=. ({."1 ,: [:tocolumn_jd_{:"1)ax
 bxs=. ({."1 ,: [:tocolumn_jd_{:"1)bx
 assert (,.&.> tsort_jd_ {:axs)-:,.&.> tsort_jd_ {:bxs
end.
''
)

NB. compare F with f
ts=: 0 : 0
'';'';t
'';'val<=10';t
'';'val>10';t
'avg val';'';t
'count val:count val,sum val:sum val,avg val:avg val';'';t
'count val:count val,sum val:sum val,avg val:avg val by byp1:p1';'';t
'count val:count val,sum val:sum val,avg val:avg val by byp1:p1,byp2:p2';'';t
)

bigchk=: 3 : 0
assert (ttally_jd_ {:jd'reads from ptab')=ttally_jd_ {:jd'reads from f'
assert (ttally_jd_ {:jd'reads from ptab where ',y)=ttally_jd_ {:jd'reads from f where ',y

NB. check when all partitions are read 
t=. ''

chk each ".each<;._2 ts

NB. check when only some partions are read
t=. y
chk each ".each<;._2 ts

NB. check after partition rows shuffled
tabs=. (<'f',PTM_jd_),each ;{.getparts_jd_'f'
jdshuffle_jd_ each tabs

NB. read all partitions with shuffled data
t=. ''
chk each ".each<;._2 ts

NB. check when only some partions are read with shuffled data
t=. y
chk each ".each<;._2 ts

NB. check that order by works
chk '';'';'order by val'
chk '';'';'order by val desc'
chk 'sum val by p1';'';'order by val'
chk 'sum val by p1';'';'order by val desc'
)

ptabletst'int'
ptablebld'int'
bigchk 'p=2012 or p in (2014,2016)'

ptabletst'edate'
ptablebld'edate'
bigchk 'p="2012" or p in ("2014","2016")' NB. big check on de (date epoch col)

ptabletst'edatetime'
ptablebld'edatetime'
bigchk 'p="2012" or p in ("2014","2016")' NB. big check on de (date epoch col)

assert({:jd'reads from f,f.j where p="2016" order by f.sort')-:{:jd'reads from ptab,ptab.j where p="2016" order by ptab.sort'

jd'reads from ptab order by sort'
jd'reads from ptab,ptab.j order by ptab.sort'

jd'reads from f order by sort'
jd'reads from f,f.j order by f.sort' NB. partition alias in order by clause

NB. jdindex - part and row
ptablebld'int'
d=. ;{:,jd'read jdindex from f'
assert d-:i.#d
assert 2015004=;{:jd'reads sort from f where jdindex=12'
assert 2015004=;{:jd'reads sort from f where jdindex=12 and p=2015'

NB. info parts
jd'reads from ptab'
assert _1='parts' jdfroms_jd_ jd'info last'
jd'reads from f'
assert (ttally_jd_ {:jd'reads from f',PTM_jd_)='parts' jdfroms_jd_ jd'info last'
jd'reads from f where p in (2015,2016)'
assert 2='parts' jdfroms_jd_ jd'info last'

NB. misc bits
ptablebld'int'
jd'renamecol ptab val foo'
jd'renamecol f    val foo'
assert (jd'reads from ptab')-:jd'reads from f'

ptablebld'int'
jd'dropcol ptab b'
jd'dropcol f b'
assert (jd'reads from ptab')-:jd'reads from f'
assert'pcol'jdae'dropcol f p'

ptablebld'int'
assert'ptable'jdae'createcol f foo int _';i.5
jd'createcol ptab foo int'
jd'createcol ptab boo byte 4'
jd'createcol f foo int'
jd'createcol f boo byte 4'
assert (jd'reads from ptab')-:jd'reads from f'

ptablebld'int'
t=. {:jd'info ref'
t=. <"1(>{.t),.' ',.>{:t
t=. (<'dropcol '),each t

jd'dropcol f jdref_p2_j_p2'
jd'renametable f boo'
assert (jd'reads from ptab')-:jd'reads from boo'

ptablebld'int'
a=. jd'reads from f,f.j'
jd'dropcol f jdref_p2_j_p2'
assert (jd'reads from ptab')-:jd'reads from f'
jd'ref f p2 j p2'
assert a-:jd'reads from f,f.j'



NB. empty
jd'reads from f where p=2020'
jd'createtable g'
jd'createcol g a int'
jd'createptable g a'
jd'reads from g'


