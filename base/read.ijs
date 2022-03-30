NB. Copyright 2018, Jsoftware Inc.  All rights reserved.
coclass 'jdquery'
coinsert 'jddatabase'

rdsplit=: 4 : 0
x=. ' ',x,' '
y=. ' ',y,' '
i=. 1 i:~ x E. blankquoted_jd_ y
a=. (i{.y);(i+#x)}.y
)

sel_parse=: 3 : 0
'y order'=.     'order by'  rdsplit y
'y where'=.     'where'     rdsplit y
'y from'=.      'from'      rdsplit ' ',y
'sel by'=.      'by'        rdsplit y
from=. deb from
'from clause missing or empty'assert 0~:#from
(dltb sel);(deb by);from;(dltb where);deb order
)

AGG_NUMERIC_jd_=: ;:'avg count countunique sum'

Read=: 3 : 0
'sel by from where order'=. sel_parse y
From from
SelBy sel;by

if. (1=#tnms)*.(''-:where)*.-.OP-:'readptable' do.
 simplequery''
 Order order
 read=: memu each read
else.
 Where where
 Query ''
 Order order
end. 

NB. cnms has by cols before agg cols
n=. (#cnms)-#AGG_jd_

for_i. i.#cnms do.
 c=. i{cloc
 NB. edate converted to string - except for /e and agg count 
 if. 'edate'-:5{.typ__c do.
  if. -.option_e do.
   if. i<n do. b=. 1 else. b=. -.((i-n){AGG_jd_)e.AGG_NUMERIC end.
   if. b do.
     t=. sep__c,utc__c,'d039'{~TYPES_E i.<typ__c
     read=: (<t sfe,>i{read) i}read
   end. 
  end.
 end. 
end.

NB. complications getting agg type
if. option_types do.
 t=. ''
 for_i. i.#cnms do.
  c=. i{cloc
  a=. ;i{cnms
  b=. typ__c,(-.''-:shape__c)#' ',":shape__c
  if. -.i<n do.
   agg=. (i-n){AGG_jd_
   if. agg e. AGG_NUMERIC do.
    b=. ;(agg=<'avg'){'int';'float'
   end. 
  end. 
  t=. t,<a,'(',b,')'
 end.
 cnms=: t
end.
cnms,.read
)

ACCESSED=: 0 2$a: NB. List of table name, column name pairs accessed

access=: 3 : 0
a=. NAME__PARENT__y;NAME__y NB. avoid ~.... in original code
if. -. a e. ACCESSED do. ACCESSED=: ACCESSED,a end.
EMPTY
)

NB. y is a boxed list of column locales, x is the rows
readselect=: 4 : 0 "1 0
ind =. _1 I.@:= x
sel =. select__y x
if. *@# ind do. sel =. DATAFILL__y ind} sel end.
access y
< sel
)

NB. ***** FROM *****
NB. y is from.
NB. Build table data:
NB.   tnms, the name of each table
NB.   tloc, the corresponding table locale
From=: 3 : 0
n =. #ex =. 'exact '
if. exact =: 0:`(','~:n&{)@.(ex-:n&{.) y do. y=.n}.y end.
from =. sortfrom ':'&(_2 {. strsplit)@> ',' strsplit y
tnms =: $0 for_f. from do. addtablepathnoind f end.
tnms
)

NB. Marshall email to change
NB.  paths=. {~^:(<@<:@#) (,#) parents
NB.   to
NB.  paths=. {~^:(<@<:@#@])~ (,#) parents

NB. Sort y (list of alias,table pairs) to fix dependencies.
sortfrom=: 3 : 0
getname =. [: (}.~ '.-><=' >:@(1 i:~ e.~) ]) '.'&,
y =. (getname@[&.>^:(a:=])~/ , {:)"1 deb&.> y  NB. Default alias
if. +./ r=.-.~:{."1 y do.
  throw 'Repeated table names (try using alias, e.g., a:b,a.b) : ',_2}.;,&', '&.> r#{."1 y
end.
NB. list of parent table indices
getroot =. [: (}.~>:@i:&' ')^:(' '&e.) ({.~ # | '.-><='&(1 i.~ e.~))
parents =. (i. getroot&.>)/ |:y
if. 1 ~: n=.(+/@:=#)parents do.
 throw 'Expected exactly one root table and received ',":n
end.
paths=. {~^:(<@<:@#@])~ (,#) parents
if. -. (#parents) +./@:= {:paths do.
  throw 'Tables are not connected by references'
end.
y /: }: (i.{:)"_1 |: paths
)

NB. y is (alias;path). Update tnms, tloc, and tpath.
addtablepathnoind =: 3 : 0
'a p' =. y
'nms root' =. (}: ,&< {:) |. (<;.1~ 1,2 +./\ e.&'.-><=') p
if. -. (-: 0 1$~$) (;:'.-><=') e.~ nms do.
  throw 'Ill-formed join: ',p
end.
'jointype root' =. (,<)/ _2{. (<'default'),' 'strsplit>root

if. 0=#tnms do.
  tnms =: ,<a [ tloc =: ,getloc root
  tpath =: ,<0 2$a:
  tparent =: ,0
  return.
end.

'nms joins' =. <"_1|:_2]\ nms
joins =. (jointype;;:'inner left right outer') {~ (;:'.-><=') i. joins

tparent =: tparent, i =. tnms i. root
findref =. 4 : '(< ,~ getreferenced__ref) ref=. getreadref__y x'
't refs' =. ({:@[ ,&< }.@])/ |:|.> (findref {.)&.>/\. nms , a: <@,~ i{tloc
access@> refs
tloc =: tloc , t
tnms =: tnms, <NAME__t"_^:(0=#) a
tpath =: tpath , <refs,.joins
)

sel_split=: <"_1 @: |: @: ((_2 {. strsplit)&:>"_ 0)

NB. y is sel;by
NB. Build column information:
NB.   cnms, the list of names (aliases) of columns
NB.   cloc, the corresponding list of locales
NB.   inds, the table index of each column
NB. inds indexes into indices.
NB. If sel is empty, add all visible columns
SelBy=: 3 : 0
'sel by'=.y
sel=. sel rplc ' ,';',';', ';',' NB. remove blanks around ,
nt =. #tloc
if. 0=#sel do. sel =. (1<nt){::'*';'*.*' end.
'a agg1 path' =. ({. , ' 'sel_split (deb each@>@{:)) ':' sel_split ',' strsplit sel

a=. jdremq each a NB. remove quotes around alias

NB. readtset avg must have count - add if necessary
if. (OP_jd_-:'readptable') *. (-.(<'count')e.agg1) *. (<'avg')e.agg1 do.
 a=.    a,<'readtsetautocount'
 agg1=. agg1,<'count'
 path=. path,{.path
end.
AGG_jd_=: agg =: agg1
NB. Include by columns
nby=:0 if. #by do.
  nby =: #>{. b=. ':' sel_split ',' strsplit by
  'a path' =. (a,&<path) ,~&.> b
end.
't c' =. <"_1|: '.'&(_2 {. strsplit)@> path
c=. jdremq each c

NB. expand * tables
mask =. t = <,'*'
'c a' =. (c;<a) #~&.> <mask { 1,nt
t =. ; mask tnms"_^:[&.> <"0 t

NB. table lookup
inds =: (a: ,~ tnms) i. t
if. +./ m=.(>:nt) = inds do.
  throw 'Could not find table: ',([,', ',])&>/ m#t
end.
tl =. tloc {~ inds=:nt|inds

NB. expand * columns
'c nc' =. (; ,&< #@>) tl ([:< 4 :'getdefaultselection__x y'^:((<,'*')=]))"0 c
tl =. nc#tl  [  t =. nc#t  [  inds=:nc#inds
cnms=: {.@:(-.&a:)"1  stripsp&.> (nc#a),. t([,('.'#~*@#@[),])&.>c
cloc=: tl  4 :'getloc__x y'"0  c
EMPTY
)

NB. Build indices, a shape (#tloc),len matrix of indices for each table.
NB.! very slow for cases with lots of indices - might be better to use booleans to do or and avoid /:~
Where=: 3 : 0
indices=: /:~@:~.&.|: > ,.&.>/ andqueries&.> toSoP fixwhere_jdtable_ y
)

NB. Take a list of queries, each on an individual table.
NB. Return a set of indices for which they are all true.
andqueries=: 3 : 0
'e y' =. ((#~ ,&< (#~-.)) ((<'exists')={.@>@{:)@>) y
e =. tnms ((<'qnot') <:@+:@~: {.@>@])`(i. {:@>@{:@>)`(0"0@[)} e

getind =. (access"0@:(0&{::) ] 1&{::)@lookupcol@>  NB. Index of table
if. #y do. inds =. (getind@{. , getind :: _1:@{:)@>@{:@> y
else. inds=.0 2$0 end.
NB. Filter out multi-table queries
inds =. ({."1 inds) #~ mask =. (=/"1 +. _1={:"1) inds
NB. Group queries by table and evaluate
tabqueries =. inds ((,~i.@#) <@({&(mask#y))@}./. ,~&(i.@#)) tloc
q =. (<"0 tloc) eval_q&.> tabqueries
indices =. q  getindices~  getorder`((i.#tnms)"_)@.exact  q
if. 1 0-:$indices do. indices =. ,: _1,i.Tlen__t [ t=.{.tloc end.
if. (-:_1$~$) {."1 indices do. indices=.}."1 indices end.
if. +./|e do. indices =. (#"1~ e *./@:(2~:3|+) =&_1) indices end.
for_q. (-.mask)#y do. indices =. indices mgetwherex2 >q end.
indices
)

NB. x is the order to use
NB. y is a list of query results, one for each table
getindices=: 4 : 0
order=.x [ q=.y
if. -. order -: i.#tnms do.
  edges =. (i.@# (~: *"1 ,:) (i. {&tparent)) order
  par =. (<./:>.)/ edges
  path =. edges (>./@[ /:~ </@[ |.@]^:[&.> ]) order{tpath
  ts =. |.(par<@{order{tloc) ,. (order{q) ,. path ,. <"0 par
else.
  ts =. |.(tparent<@{tloc) ,. q ,. tpath ,. <"0 tparent
end.
indices =. order /:~ ts  addtableindices~ reduce  i.0 0
)

NB. Sum-of-products utilities
simplifySoP=: [: (#~ 1>: [:+/ *./@:e.&>/~) [: ~. ~.&.>
toSoP =: 3 : 0
if. 0=#y do. <'' return. end.
y =. ({. , toSoP&.>^:(*@#)@}.) y
if. 1=#y do. <,<,y
elseif. 2=#y do.
  simplifySoP ,{ 'qnot'&;`}.@.((<'qnot')={.)L:_2 >{:y
elseif. 3=#y do.
  'h y' =. ({.,&<}.) y
  simplifySoP  ; ` ([: , ,&.>/&>/) @. ((;:'qor qand')i.h)  y
end.
)

NB. Evaluate query y on table x
eval_q=: ($0)"_ ` (4 : 0) @. (*@#@])

t=.x [ q=.y
striptab =. ([}.~[:(+*)#@[|i:)&'.'
'not q' =. <@:>"_1 |: (((<'qnot')-:{.) ,&< (striptab&.>@{.,}.)&.>@{:)@> q
q =. >qand__t&.>/ not qnot__t^:[&.> getwheresimp__t&.> q
_1&,^:(_1~:{.) q
)
NB. y is (locale;queries;path;parent) for a table; x is indices.
NB. Return updated indices.
addtableindices =: 4 : 0
'p q path i' =. y
if. 0=#x do. ,:q return. end.

't j' =. ((,.~(<q){.~#)|.path)  addref reduce  p ; ,:~.i{x
j combinejoins~ (,i&{) x
)


NB. =========================================================
NB. x is (reference name; join type), y is the current (locale;join).
NB. Update y.
addref=: 4 : 0
't j'=. y
'q ref u'=. x
c =. (-.flip =. t ~: PARENT__ref) { PARENT__ref , getreferenced__ref ''
join =. (u,'_join__ref')~ ` ((u,'_join__ref')~&.|.) @. flip
if. 0={:$j do.
  j=. join ({:j);q
elseif. (-.flip) *. u-:'default' do.
  new =. >({:j) readselect ref
  j=. (#"1~ q e.~{:)^:(*@#q) ({.j),:new
elseif. 1=#j do.
  j=. join ({:j);q
elseif. do.
  j=. j combinejoins join (~.{:j);q
end.
c ; j
)
NB. y is a table name. Turn into a reference column locale.
getreadref_jdtable_=: 3 : 0
if. NAMES e.~ <y do.
  if. 'ref' -: 3 : 'typ__y' l=.getloc y do. l return. end.
end.
r=.FindRef y
if. 1=#r do. {.r return. end.
if. 1<#r do.
 ('Ambiguous reference to table ',y)assert 1=#~.r
 {.r
 return.
end.
throw 'Could not find table ',y,' from table ',NAME
)

NB. Combine two joins by assuming ({:x) and ({.y) are from the same table.
combinejoins =: 4 : 0
if. 0={:$x do. y return. end.
NB. comb =. 2 $~ x (+&<:&# , {:@[ (i. +/@:{ ((i.~~.) { #/.~)@[) {.@]) y
lib =. LIBJD,' combinejoins_len > x x x'
comb =. 2 $~ (x+&<:&#y) , lib cd memhad&.> ;:'x y'
lib =. LIBJD,' combinejoins > n x x x'
comb [ lib cd memhad&.> ;:'comb x y'
)

NB. Assume the query is on columns from two different tables.
mgetwherex2=: 4 : 0
'col0 fn col1'=. >{:y
'col0 ind0 col1 ind1' =. ; lookupcol&.> col0;<col1
sel =. getwheref__col0 fn;col1; {&x&.>ind0;ind1
if. (<'qnot')={.y do. sel =. (i.{:@$x) -. sel end.
x {"1~ sel
)

lookupcol=: 3 : 0
col =. y
if. (<col) e. cnms do.
  i=. cnms i. <col
  (i{cloc);i{inds
else.
  'tab col'=.<"_1 ]_2{.'.'strsplit >y
  if. a:=tab do. tab=.{.tnms end.
  if. -.tab e. tnms do. throw 'Not found: table ',>tab end.
  tab =. tloc {~  ind=.tnms i. tab
  ind ;~ getlocq__tab@> {.^:(1=#) cutcommas >col
end.
)

lookupcolind=: 3 : 0
'order by col not in selection' assert (<y) e. cnms
cnms i. <y
)

NB. do NOT do join order stuff - not fully understood - note 1 +.
NB. give a join order for the given query
getorder =: 3 : 0
if. 1 +. (2>:#tloc) +. a:*./@:=y do. i.#tloc return. end.
adj =. <@I. (+|:) (=/ i.@#) _1(0})tparent
geto =. (, (-.~ ;@:{&adj))^:_@,
NB. number of rows to sample
n =. ((> 100%~>./) * (*<&10) >. ] <. +:@>.@%:) len =. 3 :'Tlen__y'"0 tloc
n =. n-.0  [  i =. (* # i.@#) n  [  len =. (*n)#len
sample =. n (_1 , ?)&.> len
q0 =. (#tloc) $ <$0
NB. sampling of rows
ind =. ; i <@(geto@[ |:@:getindices ]`[`(q0"_)}"0)"0 sample
tparent  orderfromw  (|:ind) (_:`(+/@:e.)@.(*@#@]) >)"1 0 y
)

NB. Convert from weights y to an ordering for tree x
orderfromw =: 4 : 0
adj =. <@I. (+|:) (=/ i.@#) _1(0})x
(, ({~ (i.<./)@:({&y))@:(-.~ ;@:{&adj))^:(<:#x) ,(i.<./)y
)


NB. =========================================================
NB. ***** QUERY *****
NB. Perform selection and aggregate, placing the results in read
Query=: 3 : 0
indices =: (-. _1"0@{.)&.|: indices
read =: (inds{indices) readselect cloc
if. nby do. read =: nby (agg aggregate) read
elseif. #;agg do. read =: agg  4 :'x getagg  y'&.>  read
end.
)

NB. simple read with single table and empty where and not ptable
simplequery=: 3 : 0
read=: ''

try.

for_c. cloc do.
 select. typ__c
 case. 'autoindex' do. read=: read,<i.Tlen__c
 case. 'varbyte'   do. read=: read,<val__c (<;.0~ ,."1) dat__c
 case. 'int1'      do. read=: read,<ifromi1_jdtnumeric_ dat__c
 case. 'int2'      do. read=: read,<ifromi2_jdtnumeric_ dat__c
 case. 'int4'      do. read=: read,<ifromi4_jdtnumeric_ dat__c
 case.             do. read=: read,<dat__c
 end. 
end.
if. nby do. read =: nby (agg aggregate) read
elseif. #;agg do. read =: agg  4 :'x getagg  y'&.>  read
end.
read=: forcecopy each read NB. careful with map ref counts

catchd.
 erase'read' NB. might have map refs 3
 rethrow''
end.
)

NB. aggregation
getagg=: 1 : 0
if. (<u) -.@e. {."1 AGGFCNS do.
  throw 'Unrecognized aggregate function: ',u
end.
(({:"1 AGGFCNS) {~ (<u) i.~ {."1 AGGFCNS) 5!:0
)

NB. nby (agg aggregate) res
NB. aggregate by 1 col is fast because it can use ~.
aggregate=: 1 : 0
:
if. 1=x do.
 d=. >{.y
 nub=. ~.d
 c=. nub i. d
 (<nub) , u (c 1 :(':';'u (x getagg)/. y'))&.> x}.y
else.
 c=. i.~|: i.~@> x{.y       NB. indices used to group columns
 ((~.c)&{&.> x{.y) , u (c 1 :(':';'u (x getagg)/. y'))&.> x}.y
end.
)

NB. Sort by order
Order=: 3 : 0
if. 0 = #ord=. cutcommas y do. return. end.
ifdesc=. (<'desc') = _4 {.&.> ord
ord=. ifdesc (_4 stripsp@}. ])^:[&.> ord
ndx=. lookupcolind@> ord
for_nd. |. ndx,.ifdesc do.
  'n d'=.nd
  read=: read {&.>~ < /:`\:@.d n{::read
end.
)
