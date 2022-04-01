NB. Copyright 2018, Jsoftware Inc.  All rights reserved.
coclass 'jddatabase'
coinsert 'jdquery'
coinsert 'jd'

CLASS =: <'jddatabase'
CHILD =: <'jdtable'

STATE=: <;._2 ]0 :0
REPLICATE
RLOGFOLDER
RLOGINDEX
)

NB. initial state values
REPLICATE =: 0     NB. 1 for source, 2 for sink
RLOGFOLDER=: ''    NB. folder for log files
RLOGINDEX =: _1    NB. snk db index in file of next record 

NB. values not in state
RLOGFH    =: 0     NB. src/snk rlog file handle
RLOGBLOCK =: 0     NB. count lock collisions

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
readstate''
if. REPLICATE~:0 do. RLOGFH=: 1!:21<jpath RLOGFOLDER,'rlog' end. 
aggcreate''
f=. PATH,'custom.ijs'
if. fexist f do. load f end.
openallchildren y
)

testcreate=: ]

create=: 3 : 0
jdversion fwrite PATH,'jdversion'
''fwrite PATH,'log.txt'
p=. }:PATH
(defaultadmin rplc 'D';}.(p i: '/')}.p)fwrite PATH,'admin.ijs'
aggcreate''
writestate''
)

close=: 3 : 0
if. RLOGFH~:0 do. RLOGFH=: 0[1!:22 RLOGFH end.
)

addagg=: 2 : 0
 assert. _2~:4!:0&< v NB. right argument (aggregate function name) is not invalid as a j name
 assert. 3=4!:0&< 'u' NB. left argument (aggregate function verb) is a verb
 if. (<v) e. {."1 AGGFCNS NB. if this aggregate function name already exists
  do. assert. (5!:1 <'u') -: ({:"1 AGGFCNS) {~ (<v) i.~ {."1 AGGFCNS NB. assert the verbs are identical
 else.
  AGGFCNS=: AGGFCNS , v ; 5!:1 <'u' NB. else add it
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
 src=. src,15!:14<'dat__w'
 s=. ((JTYPES i. 3!:0 dat__w){JSIZES)
 str=. str,((JTYPES i. 3!:0 dat__w){JSIZES)**/}.$dat__w
end.
sink=. (rows,+/str)$'u'
libstitch cd rows,(15!:14<'sink'),(#str),(15!:14<'str'),15!:14<'src'
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
 src=. src,15!:14<z
 s=. ((JTYPES i. 3!:0 z~){JSIZES)
 str=. str,((JTYPES i. 3!:0 z~){JSIZES)**/}.$z~
end.
sink=. (rows,+/str)$'u'
libstitch cd rows,(15!:14<'sink'),(#str),(15!:14<'str'),15!:14<'src'
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
Modify
)

Reads=: ({."1 ,: [:tocolumn{:"1)@:Read


NB. replicate routines

rops=:      ;:'delete insert update upsert sort ref intx'
rops=: rops,;:'createcol createtable createptable'
rops=: rops,;:'dropcol droptable'
rops=: rops,;:'renamecol renametable'

NB. some ops are trouble - createdb table... csv... ???

NB. src db - write next rlog record
rlog=: 4 : 0
if. 1~:REPLICATE do. return. end.
if. -.(<x) e. rops do. return. end.
a=. 3!:1 x;<y
d=. 'RLOGRLOG',(3 ic #a),a
'rlog write failed' assert _1-.@-:d fappend RLOGFH
setrlogend''
writestate''
)
