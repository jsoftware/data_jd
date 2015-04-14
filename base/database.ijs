NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jddatabase'
coinsert 'jd'

CLASS =: <'jddatabase'
CHILD =: <'jdtable'

STATE=: '' NB. used to have AGGFCNS

NB. define aggregation functions
aggcreate=: 3 : 0
AGGFCNS=: 0 2$<''
 (+/%#) addagg 'avg'
 #  addagg 'count'
 (#@~.) addagg 'countunique'
 {.  addagg 'first'
 {:  addagg 'last'
 (>./) addagg 'max'
 (<./) addagg 'min'
 (+/) addagg 'sum'
)

open=: 3 : 0
aggcreate''
f=. PATH,'/custom.ijs'
if. fexist f do. load f end.
openallchildren y
)

testcreate=: ]

create=: 3 : 0
aggcreate''
)

close =: ]

addagg=: 2 : 0
 assert. _2~:4!:0&< y NB. right argument (aggregate function name) is not invalid as a j name
 assert. 3=4!:0&< 'u' NB. left argument (aggregate function verb) is a verb
 if. (<y) e. {."1 AGGFCNS NB. if this aggregate function name already exists
  do. assert. (5!:1 <'u') -: ({:"1 AGGFCNS) {~ (<y) i.~ {."1 AGGFCNS NB. assert the verbs are identical
 else.
  AGGFCNS=: AGGFCNS , y ; 5!:1 <'u' NB. else add it
 end.
 NB. writestate''
 EMPTY
)

NB. =========================================================
NB. y is (name);(column names);(data to import)
NB. x is optional JD type data
NB. TODO
ImportTable=: 3 : 0
getjdtype=.(1 4 2 3 _1{~1 2 4 8 i.3!:0)`(5 6 _1{~2 4 i.(3!:0)@>@{.)@.(0<L.)
(getjdtype@> >{:y) ImportTable y
:
'name colmap dat'=.y
if. -. x *./@:e. 1 2 3 4 5 6 do. throw 'Invalid column types' end.
typ =. x { ;:'boolean int float byte varbyte enum'
shape =. (typ = <'varbyte') ($@{.@])`(}:@$@{.@>@{.@])@.[&.> dat
colmap=.;: ;:^:_1^:(0<:L.) colmap
columns =. ; <@(LF,~;:^:_1)"1 colmap,.typ,.":&.>shape
Create name;columns,&<dat
)

NB. no longer used
libstitch=: LIBJD_jd_,' stitch > x x x x x x x'
gad=: 15!:14

NB. no longer used
NB. table;cols
NB. stitch jdactive and cols 
NB. x 1 to map jdactive 0 to 2
stitch=: 4 : 0
'a b'=. y
t=. getloc a
w=. getloc__t<'jdactive'
rows=. #dat__w
str=. 1 NB. jdactive stride
src=. gad<'dat__w'
for_n. b do.
 w=. getloc__t n
 src=. src,gad<'dat__w'
 s=. ((JTYPES i. 3!:0 dat__w){JSIZES)
 str=. str,((JTYPES i. 3!:0 dat__w){JSIZES)**/}.$dat__w
end.
sink=. (rows,+/str)$'u'
libstitch cd rows,x,(gad<'sink'),(#str),(gad<'str'),gad<'src'
sink
)

NB. no longer used
NB. stich1 - all active new data (not in mapped files)
NB. data
stitch1=: 3 : 0
y=. boxopen y
n=. (#y){.<"0 Alpha_j_
(n)=. y 
rows=. #A
active=: rows$1
src=. gad<'active'
src=. src,gad n
str=.  1,((JTYPES i. ;3!:0 each y){JSIZES)*;*/each}.each $each y
sink=. (rows,+/str)$'u'
libstitch cd rows,1,(gad<'sink'),(#str),(gad<'str'),gad<'src'
sink
)

NB. =========================================================
NB. The following names can be called with arguments (table;data)
NB. to be called in the correct table.
template=. 0 : 0
'tab val'=. y
loc=. getloc tab
name__loc val
:
'tab val'=. y
loc=. getloc tab
x name__loc val
)
definetemplate =. 4 : 0
(y) =: 3 : (x rplc 'name';y)
EMPTY
)
template&definetemplate;._2 ]0 : 0
Insert
Delete
Append
InsertCols
DeleteCols
AddProp
FindProp
MakeHashed
MakeUnique
Readr
Update
Modify
Updatebyindices
)

NB. =========================================================
MakeRef =: 3 : 0
('jdreference', ;'_'&,&.> ; boxopen&.> }.,y) MakeRef y
:
y =. ,&.>@:,@:boxxopen"1 y
loc=. getloc {.{.y
if. # r =. (#~ (y -: 3 :'subscriptions__y')"_1) FindRef__loc {.{:y
  do. {.r return. end.
Create__loc x;'reference';<y
)

NB. =========================================================
newqueryloc=: 3 : 0
 loc =. cocreate ''
 coinsert__loc 'jdquery'
 coinsert__loc LOCALE
 getloc__loc =: ('getloc_',(>LOCALE),'_')~
 executescript100__loc=: 0!:100
 executescript100__loc y
 loc
)
MakeSumR=: MakeSum @: ( ('Read ','''',,&'''')&.> @: {. , }. ) @: boxopen
MakeSum=: 3 : 0
 loc=. newqueryloc > {. boxopen y
 assert. 'jdindex' -: '.'&taketo&.|. > {. cnms__loc
 tab=. 3 : 'PARENT__y' {. cloc__loc
 assert. NAME__tab -: '.'&taketo > {. cnms__loc
 MakeSum__tab loc;y
)
MakeSumRTable=: MakeSumTable @: ( {. , ('Read ','''',,&'''')&.> @: (1&{) , 2&}. )
MakeSumTable=: 3 : 0
 loc=. newqueryloc > 1{ y
 tab=. Create > 0{ y
 SUMMARYTABLE__tab=: 1
 tab,MakeSum__tab loc; }.y
)

NB. =========================================================
Reads=: ({."1 ,: [:tocolumn{:"1)@:Read
Read=: 3 : 0
loc =. cocreate ''
coinsert__loc 'jdquery'
coinsert__loc LOCALE
getloc__loc =: ('getloc_',(>LOCALE),'_')~
r=. Read__loc y
coerase loc
r
)
