NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtable'

CLASS=: <'jdtable'
CHILD=: <'jdcolumn'

NB. =========================================================
Padvar=: 1.5     NB. ratio to increase by on resize

NB. =========================================================
NB. State
STATE=: <;._2 ]0 :0
Tlen
SUBSCR
SUMMARYTABLE
SUMMARYMASTER
)

NB. =========================================================
HIDCOL=: (<'jd') ,&.> ;:'active index'
getvisible=: #~ 3 :'visible__y'@getloc@>^:(*@#)
getvisiblestatic=: #~ 3 :'visible__y *. static__y'@getloc@>^:(*@#)
getallvisible=: HIDCOL -.~ [: getvisible ".@:('NAMES'"_)

open=: 3 : 0
openallchildren ''
3 :'(2}.y)=:getloc y'@> HIDCOL
Tlen=: #dat__active
)

testcreate=: 4 : 0
'cols data'=. 2{.y,2#a:
cols =. ({.~ i.&' ')&.> cutcoldefs toJ cols
if. *@# data do.
  assert. ((2=#@$)*.2={:@$) cols&,.`,:@.((1=#cols)*.2=#)^:(2>#@$) data
end.
)
create=: 3 : 0
Tlen=: 0
SUBSCR=: 0 3$a: NB. see dynamic/base.ijs
SUMMARYTABLE=: 0
SUMMARYMASTER=: ''
writestate''
active=: Create 'jdactive' ;'boolean';$0
index=: Create 'jdindex' ;'autoindex' ;$0

'cols data'=. 2{.y,2#a:

cols=.getallvisible'' [ InsertCols^:(*@#) cols
Insert@:(cols&,.`,:@.((1=#cols)*.2=#)^:(2>#@$))^:(*@#) data
)

close =: ]

NB. SECTION col

NB. =========================================================
DeleteCols=: 3 : 0
Drop@> ~. cutnames y
)

NB. =========================================================
InsertCols=: [: InsertCol@> [: cutcoldefs toJ
cutcoldefs=: a: -.~ [: (<@deb;._2~ e.&(',',LF)) ,&LF

InsertCol=: 3 : 0
cutsp =. i.&' ' ({.;}.) ]
'nam typ'=. cutsp y
'typ shape'=. cutsp deb typ
if. ifhash =. typ-:'hash' do.
  'typ shape'=. cutsp }.shape
end.
shape =. ,".shape

if. (<typ) -.@e. DATATYPES -. APIRULES#'time';'enum' do.
  throw '101 Invalid datatype: ',typ
end.

Create nam;typ;shape
if. ifhash do. MakeHashed nam end.
)

NB. SECTION delete

NB. =========================================================
NB. delete v delete rows from table
Delete=: 3 : 0
delete1 getwhere ,y
)
delete1=: 3 : 0
update_subscr ''
empty dat__active =: 0 y} dat__active
)

NB. SECTION insert
NB. =========================================================
NB. Insert
NB. argument is (column names),.(new data)
Insert=: 3 : 0
N=.,&.> {."1 y
if. #i =. (#~ -.@~:) N do.
  throw 'Duplicated columns to insert: ',>([,', ',])&.>/ i
end.
if. #i =. N (e.#[) HIDCOL do.
  throw 'Cannot insert to hidden columns: ',>([,', ',])&.>/ i
end.
if. #i =. getvisiblestatic NAMES -. HIDCOL,N do.
  throw 'Missing columns to insert: ',>([,', ',])&.>/ i
end.
dat=. 4 : 'fixvalue__x y [ x=.getloc x'&.>/"1 y
if. 1~:#len=.~. #`($:@{.)@.(0<L.)@> dat do.
  throw 'Columns passed to insert are not the same length'
end.
len=.{.len
if. len=0 do. return. end.

NB. step 0: insert static columns
cols0=. 'jdactive' ; N
step0=. getloc@> cols0
dat0=. (,<len$1); dat

NB. calculate (global) dependencies
getdeplocs=. 3 : 'getalldeps__y $0'"0
stats=. getloc@> 'jdindex';cols0 NB. static columns
NB. utilities for the poset of dependencies
deps =. ~. getdeplocs(<@)"0(;@:) stats
sorted =. (((,~>@{.) ,&< ((]#~(-.@e.~{."1))>@{:))~ (~.@,-.{:"1)@>@{:)^:_ '';<deps
if. #>{:sorted do. throw 'cyclic dependency found' end.
sorted =. stats ~.@, sorted
deps =. sorted (] /: (i.{."1)) deps

NB. step 1: insert subsribers to static columns only
step1=. ~. ({:"1 (*./@:e.&stats/. # ~.@[) {."1) deps NB. dependent only on static columns
subs1=. step1 (] {~ [ i.~ getloc@>@:({."1)@]) SUBSCR NB. find relevant entry in SUBSCR
dat1=. (1&{ <@, [: (((,<Tlen+i.len);dat0){~('jdindex';cols0)&i.)&.> {:)"1 subs1

NB. step 2: reset other dependents (in order)
step2=. ~.&.|. step1 -.~ {:"1 deps NB. dependent on some dynamic columns (still in order)

NB.! kill off TestInsert (only for unique)
NB.! step1  4 :'empty TestInsert__x >y'"0  dat1 NB. Test inserts to subscribing columns

Tlen=: Tlen + len
try.
  step0  4 :'Insert__x >y'"0  dat0 NB. step 0: insert static columns
  step1  4 :'Insert__x >y'"0  dat1 NB. step 1: insert subsribers to static columns only
  for_j. step2 do. dynamicreset__j'' end. NB. step 2: reset other dependents (in order)
catchd.

  echo'!!!!!!!!!!!!!!!!!!!!! Revert !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  
  NB.! kill off revert - buggy - perhaps mark table as damaged
  NB.!  Revert Tlen-len
  throw (}.@{.~ i.&':') 13!:12 ''
end.

EMPTY
)

remove_jd=: 3 : 0
y#~-.;(<'jd')-:each 2{.each y
)

Append=: 3 : 0
snk=. remove_jd NAMES
src=. remove_jd NAMES__y
m=. 'Append: tables not conformable - '
if. +./0~:(#snk-.src),#src-.snk do. throw m,' name' end.
'to from' =. (getloc@> ,&< getloc__y@>) snk
for_l. to,.from do. 't f'=.<"0 l
  if. typ__t -.@-: typ__f     do. throw m,' type' end.
  if. shape__t -.@-: shape__f do. throw m,' shape' end.
end.
act=. getloc__y'jdactive'
all=. I.dat__act
total=. #all
n=. 1e4 NB.! rows to add in each insert
ins=. 0
while. #all do.
 c=. n<.#all
 p=. c{.all
 all=. c}.all
 r=. 0 2$''
 for_f. from do.
  r=. r,(<NAME__f),<select__f p
 end.
 Insert r
 ins=. ins+c
 logprogress 'Append - ',(":<.0.5+100*ins%total),' % done - ',(":ins),' rows inserted',LF
end.
i.0 0
)

NB. =========================================================
NB. Read is found in read.ijs
Readr=: getwhere
Reads=: ({."1 ,: [:tocolumn{:"1)@:Read

NB. Write table to the given csv file.
WriteCsv =: 3 : 0
if. 4<# y=.,boxopen y do. throw 'Too many arguments to WriteCsv' end.
y =. (4{.y)  {.@:-.&a:@,"0  '';2;(getallvisible'');I.dat__active
'file headers nms rws' =. y
l =. #cols =. getloc@> nms

byte =. (;:'byte enum') e.~ typ =. 3 :'<typ__y'"0 cols
sh1 =. byte }:@]^:[&.> shape =. 3 :'<shape__y'"0 cols
torow =. LF _1} (TAB,~deb)&.>(;@:)
fmt =. [ ` (, '_jdstitch' , [: =&' '`(,:&'_')} ":) @. (0<+/@])
h1 =. ;nms (<@fmt"_ 1 ,/^:(0>.2-~#@$)@:(#:i.))&.> sh1
h2 =. (*/@> sh1) # typ ,&.> byte ((*. *@#) # ' ',":@{:@])&.> shape
(; <@torow"1 headers {. h1 ,: h2) 1!:2 <f =. jpath file

t =. 3|>: (;:'varbyte enum') i. typ
ind =. +/\ 0,}:t{1 2 2
rws =. pointer_to_name 'rws'
col =. pointer_to_name@> ; 3 :'ExportMap__y $0'&.> <"0 cols
lib =. LIBJD,' writecsv > n *c x *x *x x *x'
empty lib cd f;l;t;ind;rws;col
)


NB. SECTION transaction handling

NB. =========================================================
NB. revert database to length y
Revert=: 3 : 0
if. y >: Tlen do. return. end.
Tlen=: y
NB. Revert is handled in the type classes
3 :'Revert__y Tlen'"0  CHILDREN
)

NB. SECTION update

NB. =========================================================
NB. y is (rws;data) where data is of the form passed to Insert.
NB. data does not have to cover all columns.
Update=: 3 : 0
'rws dat'=. y
update1 (getwhere rws),&<dat
)

Updatebyindices=: 3 : 0
if. (+./@:>:&Tlen +. +./@:<&0) 0{::y do. throw 'Index error' end.
update1 y
)

NB. mark subscribers to y cols ('' for all cols) as dirty
update_subscr=: 3 : 0
for_subs. SUBSCR do.
 if. (''-:y) +. y e. >{: subs do.
  c=. ;{.subs
  if. '^'={.c do.
   'x t c'=. <;._2 c,'.'
   w=. getdb''
   w=. getloc__w t
   w=. getloc__w c
  else.
   w=. getloc c
  end.
  if. typ__w-:'refleft1' do. Update__w'' end.
 end.
end.
)

NB. new update that calls jd_insert
NB. should be changed to do in-place update
NB. in-place update needs to do update_subscr
NB. in-place update should update only changed data
NB. read of all old data could be avoided if cols required by datatune was known 
update1=: 3 : 0
'rws dat'=.y
if. +.(#rws)~:;#each {:"1 dat do. throw 'jde: update rows and data counts differ' end.
if. 0=#rws do. return. end.
n=. {."1 dat
e=. NAMES
e=. (-.(<'jd')=2{.each e)#e
e=. e-.n
keep=.getloc&> e
a=. e,.keep 4 :'ExportRows__x y'"0 _ rws
active=. getloc'jdactive'
dat__active =: 0 rws}dat__active NB. delete now - undo if insert error 
try.
 jd_insert_jd_ NAME;,dat,a NB. calls update_subscr
catchd.
 dat__active =: 1 rws}dat__active NB. undo delete as there was an error
 t=. 13!:12''
 throw }.(t i.LF){.t  NB. rethrow
 NB. rethrow''
end.
EMPTY
)

NB. SECTION Dynamic columns

NB. =========================================================
NB. x is a dynamic column type, and y is a list of column names.
AddProp =: 4 : 0
y=. ,boxopen y   [   x=. ;: :: (,@boxopen) x
if. #f=.x FindProp y do. {.f return. end.
x =. >{.x
Create ('jd',x,;'_'&,&.>y);x;< ,:NAME;<y
)
MakeHashed =: 'hash unique'&AddProp
MakeUnique =: 3 : 0
col =. 'unique hash' AddProp y
if. 'hash'-:typ__col do.
  if. _1 +./@:~: link__col do.
    throw 'Cannot convert existing hash to unique column: repeated elements'
  else.
    unmapcolfile__col 'link'
    erase link__col
    1!:55<PATH__col,'link'
    coinserttofront__col 'jdtunique'
    typ__col =: 'unique'
    writestate__col ''
  end.
end.
col
)

filterbytype =: ] #~ ,@boxopen@[ e.~ 3 :'<typ__y'"0@]

NB. Same arguments as AddProp, except x can be a list of types.
NB. Return a matching list of summary columns.
FindProp =: 4 : 0
x filterbytype getloc@> SUBSCR ({."1@[ #~ {:"1@[ -:&(/:~)&> ]) <,boxopen y
)

NB. x is referenced (table;cols) , y is referencing cols (in this table).
MakeRef =: 4 : 0
MakeRef__PARENT (NAME;y),:x
)

NB. y is a referenced table name. Find the reference columns to it.
FindRef =: 3 : 0
s =. (;:'reference refleft1') filterbytype getloc@> {."1 SUBSCR
(#~ ({.boxopen y) = 3 : '{.{:subscriptions__y'"0) s
)

NB. y is the query locale
MakeSum =: 3 : 0
NB. name=. ('jdsummaryset_',":)`($:@>:)@.(NAMES e.~'jdsummaryset_'<@,":) 0
loc=. boxopen > {. y
name=. 'jdsummaryset_'&, ; ([,&:>'_',&:>])/ '.'&taketo&.|.&.> }. cnms__loc
Create name;'summaryset';< y
)
