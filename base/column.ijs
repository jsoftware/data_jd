NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass 'jdcolumn'

throw=: 13!:8&101 NB. jd not in our path

NB. There are 3 col types: static, dynamic, and summary (which may be killed off)

CLASS=: <'jdcolumn'
CHILD=: a:

derived=: 0        NB. mark special
derived_mapped=: 0 NB. mark special
dverb=: ''

STATE=: <;._2 ]0 : 0
typ
shape
derived
derived_mapped
dverb
)

setderiveddirty=: 3 : 0
if. derived do.
 erase'dat'
 0 update_subscr__PARENT '' NB. mark refs dirty
end. NB. so next getloc/mapcol will derive new values
)

NB. map as required
open=: 3 : 0
Cloc=: '_',(>LOCALE),'_'
coinserttofront 'jdt',typ
NB. writestate''
)

close=: 3 : 'unmapcolfile"0 MAP'

NB. y is typ;shape
testcreate=: 4 : 0
'typ shape' =: y
if. (t=.<'jdt',typ) -.@e. conl 0 do. throw 'Invalid column type: ',typ end.
x testcreate__t shape
)

create=: 3 : 0
'typ shape' =: y
open''
makecolfiles ''
cco_write__PARENT (cco_read__PARENT''),NAME,LF NB. column create order 
)

NB. refcount problems
NB. multiple processes mapping same file have problems with refcount
NB. normal mapping jams refcount to 2 - perhaps wrong for the other task
NB. unmapping reduces refcount to 1 - unmap in another task crashes on 4!:55 erase
NB. try using sharename to avoid these problems
NB. sharename causes jamming refcount high
NB. this means we miss detection (unmap result 2) of oprhans
NB. also refcount is added so it generally climbs which is not good
NB. could jam sharename to avoid some of these problems
NB. db lock enforces only 1 task mapping so these issues can be ignored

NB. called from geloc when dat is not defined
mapcolfile=: 3 : 0
if. -.derived do.
 jdmap (,&Cloc ; PATH&,) >y
 NB. consider validation here simliar to derive
else.
 FETAB_jd_=: NAME__PARENT
 FECOL_jd_=: NAME
 if. 3=nc<dverb do.
  d=. fixtypex dverb~''
 else.
  NB. derive_verb vs derived_verb mess when derived_mapped introduced
  d=. fixtypex ('derive',(dverb i.'_')}.dverb)~''
 end.
 'derived bad count'assert Tlen=#d
 'derived bad trailing shape'assert shape-:}.$d
 'derived bad type'assert (3!:0 d)-:3!:0 DATAFILL
 dat=: d
end.
)

unmapcolfile=: 3 : 0
jdunmap (>y),Cloc
)

NB. x is (type;shape), y is the name of the file
makecolfile=: 4 : 0
typ=.<'jdt',typ  [  'typ shape' =. x
r=. ROWSMIN>.Tlen
jdcreatejmf (PATH,y);r*DATASIZE__typ**/shape
jdmap (y,Cloc);PATH,y
select. typ__typ
 case. 'int1' do. (y)=: Tlen#  {.a.
 case. 'int2' do. (y)=: Tlen#2#{.a.
 case. 'int4' do. (y)=: Tlen#4#{.a.
 case.        do. (y)=: (($,)~ Tlen,shape,$@]) DATAFILL__typ
end.
)

NB. resize single mapped name
resizemap=: 3 : 0
'name size' =. y
t=. (name,Cloc);size
NB. 'resizemap'logtxt NAME__PARENT,' ',NAME
jdunmap (name,Cloc);size
mapcolfile name
)

resize=: 3 : 0
'name data'=. y
c=. #name~ NB. must be in its own sentence so ref count is up and then back down
resizemap name;(getbytes{.data)*ROWSMIN>.>.ROWSMULT*ROWSXTRA+c+#data
)

appenddat=: 3 : 0
try. 
 dat=: dat,y
catch. 
 resize 'dat';y
 dat=: dat,y
end.
i.0 0
)

appendval=: 3 : 0
try. 
 val=: val,y
catch. 
 resize 'val';y
 val=: val,y
end.
i.0 0
)

getbytes=: 3 : 0
((JTYPES i. 3!:0 y){JSIZES)**/$y
)

NB. Export column to boxes
ExportMap=: 3 :'MAP ,&.> <Cloc'
Export=: [: ".&.> [: ". 'MAP'"_
NB. ExportRows=: (({&.:>{.),}.@]) Export

NB. ExportRows above has 2 nasty varbyte bugs
NB.  returned ptr to val (increase ref count)
NB.   if a resize was required this prevented unmap/remap
NB.   resulting in damaged table
NB.  entire val was appended to val so size doubled with update

NB. ExportRows below is a brute force fix to the above problems
NB.  rather than export efficient internal varbyte format
NB.  it exports list of boxes

NB. conversion of varbyte external <-> internal should be done in C
ExportRows=: 3 : 0
if. typ-:'varbyte' do.
 ,<select y
else. 
 y (({&.:>{.),}.@]) Export''
end. 
)

NB. mtm stuff to adjust RO task for changes made in RW task

NB. RD task runs this before read to handle insets
NB. WR task may have inserted rows in tables
NB. remap if fsize has changed
NB. set new tlen in table locale and mapped dat file headers
NB. set filesize in mapped val file headers (easier than calculating from dat)
NB. care taken to avoid fsize race between WR and RO tasks
mtmfix_jd_=: 3 : 0
if. ''-:y do. return. end. 
't r'=. y

NB. remap cols that have changed filesize - does not touch header
a=. (fsize MAPFN_jmf_{"1 mappings_jmf_)~:>MAPFSIZE_jmf_{"1 mappings_jmf_
remap_jmf_ each a#MAPNAME_jmf_{"1 mappings_jmf_

NB. adjust table locale tlen and headers for mapped files
for_tab. conl 1  do.
 if. 0~:nc<'CLASS__tab' do. continue. end. 
 if. -.'jdtable'-:;CLASS__tab do. continue. end.
 i=. t i. <NAME__tab
 'info_summary table not found'assert i<#t
 s=. i{r
 if. Tlen__tab~:s do.
  NB. table has new rows - files have been remapped - adjust headers
  p=. PATH__tab
  b=. (<p)=(#p){.each 1{"1 mappings_jmf_
  b=. b#mappings_jmf_
  mt=. ;(<'dat')=3{.each{."1 b
  dats=. mt#b     NB. dat headers to adjust
  vals=. (-.mt)#b NB. val headers to adjust. 
  Tlen__tab=: s
  
  NB. adjust dat headers with new */$dat and #dat
  for_n. dats do. NB. set new */$dat and #dat
   n=. ;6{n
   s memw n,HADS_jmf_,1,JINT             NB. {.$dat
   c=. getHADR_jmf_ n
   if. 2=c do.
    (s*memr n,(8+HADS_jmf_),1,JINT) memw n,HADN_jmf_,1,JINT
   else.
    s memw n,HADN_jmf_,1,JINT
   end.
  end.
  
  NB. adjust vals with new len -jam to file size as exact calc from dat not necessary
  for_n. vals do.
   s=. fsize 1{n
   n=. ;6{n
   s memw n,HADS_jmf_,1,JINT             NB. {.$dat
   s memw n,HADN_jmf_,1,JINT
  end.
  
  NB. table has new rows - mark derived cols dirty
  for_c. CHILDREN__tab do.
   setderiveddirty__c''
  end.
 end. 
end. 
)

NB. getloc calls to adjust RO header
NB. y is col locale
NB. MTM ro task has good Tlen from table locale that it should use
NB. mapping col file could have header with new rows from insert
NB. need to adjust header - adjust required for dat and val
mtmfixcount_jd_=: 3 : 0
if. derived__y do. return. end.
s=. Tlen__y
if. 'varbyte'-:typ__y do. NB. adjust val
 p=. PATH__y,'val'
 i=. (1{"1 mappings_jmf_)i.<p
 n=. i{mappings_jmf_
 had=. >MAPHEADER_jmf_{n
 fs=. fsize 1{n
 fs memw had,HADS_jmf_,1,JINT NB. jam header to fsize - exact calc no necessary
 fs memw had,HADN_jmf_,1,JINT
end. 
p=. PATH__y,'dat'
i=. (1{"1 mappings_jmf_)i.<p
had=. >MAPHEADER_jmf_{i{mappings_jmf_
if. s=memr had,HADS_jmf_,1,JINT do. return. end. NB. it is OK
s memw had,HADS_jmf_,1,JINT             NB. {.$dat
c=. getHADR_jmf_ had
if. 2=c do.
 (s*memr had,(8+HADS_jmf_),1,JINT) memw had,HADN_jmf_,1,JINT
else.
 s memw had,HADN_jmf_,1,JINT
end.
)
