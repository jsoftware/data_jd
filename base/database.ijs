NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jddatabase'
coinsert 'jd'

CLASS =: <'jddatabase'
CHILD =: <'jdtable'

STATE=: ''

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
writestate''
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

libstitch=: LIBJD_jd_,' stitch > x x x x x x'
gad=: 15!:14

NB. 'tablename';<'cola';'colb';...
NB. ref uses for multiple cols
stitch=: 3 : 0
'a b'=. y
t=. jdgl a
rows=. Tlen__t
str=. ''
src=. ''
for_n. b do.
 w=. getloc__t n
 src=. src,gad<'dat__w'
 s=. ((JTYPES i. 3!:0 dat__w){JSIZES)
 str=. str,((JTYPES i. 3!:0 dat__w){JSIZES)**/}.$dat__w
end.
sink=. (rows,+/str)$'u'
libstitch cd rows,(gad<'sink'),(#str),(gad<'str'),gad<'src'
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
InsertCols
DeleteCols
Readr
Modify
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
