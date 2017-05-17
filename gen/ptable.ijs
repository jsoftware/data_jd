NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

NB. ptablebld type - int edate edatetime - pcol type

ptablecreate=: 4 : 0
jd'createtable ',x
jd'createcol  ',x,' p ',y        NB. partition col
jd'createcol  ',x,' val  int'
jd'createcol  ',x,' p1   int'
jd'createcol  ',x,' p2   int'
jd'createcol  ',x,' sort int'
jd'createcol  ',x,' b    byte'
jd'createcol  ',x,' b1   byte 1'
jd'createcol  ',x,' b2   byte 2'
jd'createcol  ',x,' e    edate'
)

ptabledata=: 4 : 0
c=. jdgl_jd_'base p'
select. typ__c 
case.'int' do.
 d=. x#y
case.'edate' do.
 d=. x$efs_jd_":y
case.'edatetime' do.
 d=. x$efs_jd_":y
end.
nv=. 'p';d;'val';(?.x$20);'p1';(x$i.6);'p2';(x$i.4);'sort';(1000*y)+i.x
nv=. nv,'b';(x{.AlphaNum_j_);'b1';((x,1)$AlphaNum_j_);'b2';((x,2)$AlphaNum_j_)
q=: nv=. nv,'e';efs_jd_>(":each 10+i.x),~each x$<'2012-10-'
)

ptableinsert=: 4 : 0
c=. jdgl_jd_'base p'
select. typ__c 
case.'int' do.
 d=. x#y
case.'edate' do.
 d=. x$efs_jd_":y
case.'edatetime' do.
 d=. x$efs_jd_":y
end.
nv=. 'p';d;'val';(?.x$20);'p1';(x$i.6);'p2';(x$i.4);'sort';(1000*y)+i.x
nv=. nv,'b';(x{.AlphaNum_j_);'b1';((x,1)$AlphaNum_j_);'b2';((x,2)$AlphaNum_j_)
q=: nv=. nv,'e';efs_jd_>(":each 10+i.x),~each x$<'2012-10-'
jd 'insert base';nv
)

ptablebld=: 3 : 0
jdadminx'test'
jd'createtable j'
jd'createcol j p2 int _';4?4
'base' ptablecreate y
jd'ref base p2 j p2'
3  ptableinsert 1999
1  ptableinsert 2012
2  ptableinsert 2013
5  ptableinsert 2014
10 ptableinsert 2015
6  ptableinsert 2016
jd'droptable f'
'f'ptablecreate y
jd'ref f p2 j p2'
jd'createptable f p'
jd'insert f';,jd'read from base'
assert ({:jd'reads from base,base.j')-:{:jd'reads from f,f.j'
)

NB. test ptable insert/delete/update/modify where/modify index
ptabletst=: 3 : 0
ptablebld y
nv=. 3 ptabledata 2017
jd'insert base';nv
jd'insert f'   ;nv
nv=. 3 ptabledata 2012
jd'insert base';nv
jd'insert f'   ;nv
assert ({:jd'reads from base,base.j order by base.sort')-:{:jd'reads from f,f.j order by f.sort'

jd'delete base';'val=8'
jd'delete f'   ;'val=8'
assert ({:jd'reads from base,base.j order by base.sort')-:{:jd'reads from f,f.j order by f.sort'

jd'update base';'val=6';'val';4#123
jd'update f'   ;'val=6';'val';4#123
assert ({:jd'reads from base,base.j order by base.sort')-:{:jd'reads from f,f.j order by f.sort'

jd'update base';'val=123';'val';666
jd'update f'   ;'val=123';'val';666
assert ({:jd'reads from base,base.j order by base.sort')-:{:jd'reads from f,f.j order by f.sort'

jd'reads jdindex from base where val=666'
i=. ;{:{:jd'read jdindex from base where val=666'
jd'update base';i;'val';777
i=. ;{:{:jd'read jdindex from f where val=666'
jd'update f';i;'val';777
assert ({:jd'reads from base,base.j order by base.sort')-:{:jd'reads from f,f.j order by f.sort'
)


