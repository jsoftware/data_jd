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

rxmap=: 0 NB. rx needs map

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

libstitch=: LIBJD_jd_,' stitch > x x x x x x'

NB. stitch table cols into single key col
NB. 'tablename';<'cola';'colb';...
NB. if single col, just return dat
stitch=: 3 : 0
'a b'=. y
t=. jdgl a
if. 1=#b do. dat__w [ w=. getloc__t b return. end.
rows=. Tlen__t
str=. ''
src=. ''
for_n. b do.
 w=. getloc__t n
 src=. src,symdat<'dat__w'
 s=. ((JTYPES i. 3!:0 dat__w){JSIZES)
 str=. str,((JTYPES i. 3!:0 dat__w){JSIZES)**/}.$dat__w
end.
sink=. (rows,+/str)$'u'
'stitch'logjd DB,' ',a,;' ',each b
libstitch cd rows,(symdat<'sink'),(#str),(symdat<'str'),symdat<'src'
sink
)

NB. stitch multiple cols into single key col
NB. data1;data2 ...
stitchx=: 3 : 0
c=. ;#each y
rows=. {.c
'bad row count'assert rows=c
str=. ''
src=. ''
for_i. i.#y do.
 z=. 'a',":i
 (z)=. >i{y
 src=. src,symdat<z
 s=. ((JTYPES i. 3!:0 z~){JSIZES)
 str=. str,((JTYPES i. 3!:0 z~){JSIZES)**/}.$z~
end.
sink=. (rows,+/str)$'u'
'stitchx'logjd DB
libstitch cd rows,(symdat<'sink'),(#str),(symdat<'str'),symdat<'src'
sink
)

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
