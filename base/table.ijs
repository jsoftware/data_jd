NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
coclass 'jdtable'

throw=: 13!:8&101 NB. jd not in our path

CLASS=: <'jdtable'
CHILD=: <'jdcolumn'

NB. =========================================================
Padvar=: 1.5     NB. ratio to increase by on resize

NB. =========================================================
NB. State
STATE=: <;._2 ]0 :0
Tlen
S_ptable
SUBSCR
ROWSMIN
ROWSXTRA
ROWSMULT
)

Tlen=: 0
S_ptable=: 0
SUBSCR=: 0 3$a: NB. see dynamic/base.ijs
ROWSMIN=:  2000
ROWSXTRA=: 0
ROWSMULT=: 1.5

NB. =========================================================
HIDCOL=: <'jdindex'
getvisiblestatic=: #~ 3 :'visible__y *. static__y'@getloc@>^:(*@#)

NB. column_create_order routines
cco_read=: 3 : 0
f=. PATH,'column_create_order.txt'
d=. fread f
d=. ;(_1={.d){d;''
if. LF~:{:d do. d rplc ' ';LF else. d end.
)

cco_write=: 3 : 0
if. 'jd'-:2{.y do. return. end.
y fwrite PATH,'column_create_order.txt'
)

cco_remove=: 3 : 0
d=. <;.2 cco_read''
cco_write ;d-.<y,LF
)

getdefaultselection=: 3 : 0
n=. NAMES
n=. n#~-.bjdn n
d=. cco_read''
if. optionsort +. ''-:d do.
 /:~n
else. 
 con=. ~.n,~<;._2 d
 (con e. n)#con
end.

)
setTlen=: 3 : 0
Tlen=: y
writestate''
)

openflag=: 0 NB. old style tests

open=: 3 : 0
openflag=: 1
)

testcreate=: [ NB. validation is done in api

NB. only old style testall calls have data
create=: 3 : 0
'cols data alloc'=. 3{.y,3#a:
'bad table create args'assert (cols-:'')*.data-:''
if. 3~:#alloc do. alloc=. ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_ end.
'ROWSMIN ROWSMULT ROWSXTRA'=: 4 1 0>.alloc
writestate''
index=: Create 'jdindex' ;'autoindex' ;$0
)

close =: ]

DeleteCols=: 3 : 0
Drop@> ~. cutnames y
)

ICol=: 3 : 0
'nam typ'=. y
'typ shape'=. cutsp deb typ
shape =. ,".shape
if. (<typ) -.@e. DATATYPES do. throw '101 Invalid datatype: ',typ end.
Create nam;typ;shape
)

NB. x is rows to add to each col
NB. y is (column names),.(new data)
Insert=: 4 : 0
dat=. {:"1 y
step0=. getloc@> {."1 y
rows=. Tlen
setTlen Tlen+x  NB. 
update_subscr'' NB. mark ref cols dirty
try.
 step0  4 :'Insert__x >y'"0  dat NB. step 0: insert static columns
 1+FORCEREVERT#'a'
catchd.
 FORCEREVERT_jd_=: 0
 NB. this could/should be fixed to repair the table
 NB. needs to jam all columns to have original Tle
 NB. needs to mark dynamic cols dirty
 NB. has to do everything that repair would do
 NB. for now, just mark the db damaged and let repair do the hard work
 setTlen rows NB. original rows
 jddamage'insert failed'
end.
EMPTY
)

NB. y is index of rows to compress out
NB. jdref col marked dirty
Delete=: 3 : 0
 1 update_subscr''
 b=. -.(i.Tlen)e.y
 for_i. i.#CHILDREN do.
  c=. i{CHILDREN
  if. (<'jdindex')=i{NAMES do.
   continue.
  elseif. bjdn i{NAMES do.
   setdirty__c 1
  elseif. derived__c do.
   setderiveddirty__c''
  elseif. 1 do.
   getloc NAME__c NB. map as required
   dat__c=: (b#~datcount__c 1)#dat__c
  end. 
 end.
 Tlen=: +/b NB. change after all cols are adjusted
 writestate'' NB. Tlen
i.0 0
)

markderiveddirty=: 3 : 0
bdn=. 3 : 'derived__y' "0 CHILDREN NB. derived names
(3 : 'setderiveddirty__y 1') "0 bdn#CHILDREN NB. mark derived names dirty
)

Reads=: ({."1 ,: [:tocolumn{:"1)@:Read

NB. Write table to the given csv file
NB. t parameter to writecsv c routine is:
NB.  0 J data, 1 varbyte, 2 enum, 3 int1, 4 int2, 5 int4
WriteCsv =: 3 : 0
'file headers nms rws epoch new'=. y
l =. #cols =. getloc@> nms
byte =. (;:'byte enum') e.~ typ =. 3 :'<typ__y'"0 cols
sh1 =. byte }:@]^:[&.> shape =. 3 :'<shape__y'"0 cols
torow =. LF _1} (TAB,~deb)&.>(;@:)
fmt =. [ ` (, '_jdstitch' , [: =&' '`(,:&'_')} ":) @. (0<+/@])
h1 =. ;nms (<@fmt"_ 1 ,/^:(0>.2-~#@$)@:(#:i.))&.> sh1
h2 =. (*/@> sh1) # typ ,&.> byte ((*. *@#) # ' ',":@{:@])&.> shape
f =. jpath file
if. new do. (; <@torow"1 headers {. h1 ,: h2) jdfwrite f end.
t =. 3|>: (;:'varbyte enum') i. typ
if. epoch do.
 et=. (#typ)#0
 seputc=. (2*#typ)$' '
else.
 et=. 5|>: TYPES_E i.typ
 seputc=. ,3 : 'try.sep__y,utc__y,''''catch.'',Z''end.' "0 cols
end. 
ind=. +/\ 0,}:t{1 2 2
a=. (;:'int1 int2 int4')i.typ
t=. t>. (a~:3)*3+a
rws=. memhad 'rws'
col=. memhad@> ; 3 :'ExportMap__y $0'&.> <"0 cols
lib=. LIBJD,' writecsv > n *c x *x *x *c *x x *x'
empty lib cd f;l;t;et;seputc;ind;rws;col
)

NB. SECTION transaction handling

NB. =========================================================
NB. revert database to length y
Revert=: 3 : 0
if. y >: Tlen do. return. end.
setTlen y NB. revert
NB. Revert is handled in the type classes
3 :'Revert__y Tlen'"0  CHILDREN
)

NB. mark subscribers to y cols ('' for all cols) as dirty
NB. x 1 for delete - avoid dirty for left
update_subscr=: 3 : 0
0 update_subscr y
:
for_subs. SUBSCR do.
 if. (''-:y) +. y e. >{: subs do.
  c=. ;{.subs
  if. '^'={.c do.
   'x t c'=. <;._2 c,'.'
   w=. getloc__dbl t
   w=. getlocx__w c
   a=. 1 NB. right ref
  else.
   if. x do. continue. end. NB. delete left ref - do not mark dirty
   w=. getlocx c
   a=. 0 NB. left ref
  end.
  setdirty__w 1
 end.
end.
)

filterbytype =: ] #~ ,@boxopen@[ e.~ 3 :'<typ__y'"0@]

NB. y is a referenced table name. Find the reference columns to it.
FindRef =: 3 : 0
s =. (<'ref') filterbytype getlocref@> {."1 SUBSCR
(#~ ({.boxopen y) = 3 : '{.{:subscriptions__y'"0) s
)

getpcol=: 3 : 0
'not pcol table' assert PTM={:NAME
t=. NAMES#~-.bjdn NAMES
'pcol table with more than 1 col' assert 1=#t
;t
)
