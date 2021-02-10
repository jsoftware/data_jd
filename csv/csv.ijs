NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. csv loader
0 : 0
CVAR type has parameter of expected average size that is used in initial file size calculation (rows*size)

options: COLSEP AUTO looks at first 5000 bytes of csv file
 first of TAB COMMA or STILE set or error
 
options: ROWSEP AUTO looks at last 2 bytes of csv file
 CRLF, xLF, xCR set or error

rows: rows grow
rows is used for initial file allocation
grow 0 if only load up to rows
grow 1 is callbacks should increase file allocation to load all rows
)

NB. use createjmf (not jdcreatejmf) as csv depends on exact msize

coclass'jdcsv'

csvreportclear=: 3 : '''''fwrite PATHLOGLOGFILE'

NEWROWS=: 100000 2 NB. new rows on resize                  - default,stress
VBYTES =:    100 2 NB. bytes/row on resize (cdef override) - default,stress

RESIZESTRESS=: 0 NB. 1 to stress test callbackc and callbackv 

PATHLOGLOGFILE=: '~temp/csvloglog.txt'

csvreport=: 3 : 'fread PATHLOGLOGFILE'

csvreportsummary=: 3 : 0
t=. <;.2 fread PATHLOGLOGFILE
b=. (<,LF)=t
b=. b+.(<'!')={.each t
b=. b+.(<'src: ')=5{.each t
b=. b+.(<'snk: ')=5{.each t
b=. b+.(<'elapsed: ')=9{.each t
b=. b+.(<'rows: ')=6{.each t
b=. b+.(<'error: ')=7{.each t
;b#t
)

NB. crash info in PATHLOGFILE (before it is added to PATHLOGLOGFILE)

NB. matches defines in csv.c
CNOT=:        0
CVAR=:        1 NB. index,len col and data string
NB. CVARX=:       2 NB. 0 terminated strings
CCHAR=:       3 NB. JCHAR
CI1=:         4 NB. JCHAR n,1 - signed byte
CI2=:         5 NB. JCHAR n,2 - signed short
CI4=:         6 NB. JCHAR n,4 - signed 4 bytes
CI8=:         7 NB. JINT 
CDATETIME=:   8 NB. JINT yyyymmddhhmiss
CDATETIMEX=:  9 NB. JINT ddmmyyyyhhmiss
CDATE=:      10 NB. JINT yyyymmdd
CDATEX=:     11 NB. JINT ddmmyyyy
NB.          12
NB.          13
NB.          14   
CBOOLEAN=:   15 NB. JBOOL
CDOUBLE=:    16 NB. JFL
CDOUBLEX=:   17 NB. JFL fast (less general) code 
CI8X=:       18 NB. JINT with dot shifted
CSTITCH=:    19 NB. stitched to another col
CEDATE=:     20
CEDATETIME=: 21 
CEDATETIMEM=:22
CEDATETIMEN=:23
CMAX=:       24

CTYPES=: <;._2 [ 0 : 0
CNOT
CVAR
unused
CCHAR
CI1
CI2
CI4
CI8
CDATETIME
CDATETIMEX
CDATE
CDATEX
UNUSED
UNUSED
UNUSED
CBOOLEAN
CDOUBLE
CDOUBLEX
CI8X
CSTITCH
CEDATE
CEDATETIME
CEDATETIMEM
CEDATETIMEN
)

NB. map JDtypes to csv Ctypes
JDTYPES=: ;:'int  int  float   byte  varbyte date  datex  datetime  datetimex  boolean  edate  edatetime  edatetimem  edatetimen  int1 int2 int4 unsupported'
JDTMAP=:  ;:'CI8  CI8X CDOUBLE CCHAR CVAR    CDATE CDATEX CDATETIME CDATETIMEX CBOOLEAN CEDATE CEDATETIME CEDATETIMEM CEDATETIMEN CI1  CI2  CI4'

types=: i.CMAX
counts=: 0 16 8 1 1 2 4 8 8 8 8 8 0 0 0 1 8 8 8 0 8 8 8 8

DBAD=: _1.7976931348623157e308 NB. bad double value

NB. pps=: 9!:11
NB. pps 18

3 : 0''
NB.     I xcsv(I callback, I* cbd, char* options,
t=.   ' x      x           x       *c'
NB.     I rows, I cols, I* erra, I* errz,
t=. t,' x       x       x        x'
NB.     char* ina, char* inz, I* colinfo, I* da,
t=. t,'   x               x      *x          *x'
NB.     I* va, I* vx, I* vz,  I* var, I* progress, I* maxwidths)
t=. t,'  *x      *x      *x       x      x         *x'
xcsv=:  (LIBJD_jd_,' xcsv ',t)&cd
i.0 0
)

3 : 0''
NB.     char* options,
t=.   ' *c'
NB.     I cols,
t=. t,' x'
NB.     char* ina, char* inz
t=. t,' x          x'
NB.     I* maxwidths)
t=. t,' *x'
xscan=:  (LIBJD_jd_,' xscan x ',t)&cd
i.0 0
)


log=: 3 : 0
if. 1=L. y do.
 t=. ,LF,.~sptable y
else.
 t=. y,LF
end.
t fappend PATHLOGFILE
)

jdclean=: 3 : 0
jd_close_jd_''
)
 
free=: 3 : 0
i.0 0
)

NB. do not use jdmap as it will do resize - and csv files must not be resized here
csvmap=: 3 : 0
0 csvmap y
:
try.
 x map_jmf_ y
catchd.
 echo 'csv jdmap failed - will retry : ',fn,' : ',LF-.~,13!:12''
 try.
  6!:3[5
  x map_jmf_ y
 catchd. 
  echo 'csv jdmap failed - failed again : ',fn,' : ',LF-.~,13!:12''
  FEER_jd_=: 13!:12''
  logijfdamage 'csvmap';y
 end. 
end.
)

NB. do not use jdunmap as it will do resize with JMFPAD - and csv files must not have pad
csvunmap=: 3 : 0
r=. unmap_jmf_ y
('csvunmap failed: ',(":r),' ',;{.y)assert 2~:r
)

NB. rows makecol col - create and map c file
makecol=: 4 : 0
n=. >y{ccnames
f=. >y{ccfiles
c=. getcount y
createjmf_jmf_ f;x*c
csvmap n;f
settypeshape_jmf_ n;x colsub y
)

NB. rows colsub y - return Jtype;shape
NB. int/float column is list  if trailing shape is 1
NB. int/float column is table if trailing shape is not 1 
colsub=: 4 : 0
c=. getcount y
t=. y{ctypes''
i=. <.c%8
if. t e. CCHAR do.
 if. y{elidedx do.
  JCHAR;x
 else.
  JCHAR;x,c
 end.
elseif. t e. CI1,CI2,CI4 do.
  JCHAR;x,c
elseif. t e. CBOOLEAN do.
 JB01;x
elseif. t e. CVAR do.
 JINT;x,2
elseif. t e. CDOUBLE,CDOUBLEX do.
 if. c=8 do.
  JFL;x
 else.
  JFL;x,<.c%8
 end.
elseif. 1 do.
 NB. if. (c=8) do.
 if. (c=8)*.y{elidedx do.
  JINT;x
 else.
  JINT;x,<.c%8
 end.
end.
)

NB. rows makevar col - create and map v file
makevar=: 4 : 0
n=. >y{cvnames
f=. >y{cvfiles
c=. x*y{cxtra''
createjmf_jmf_ f;c
csvmap n;f
settypeshape_jmf_ n;JCHAR;c
i.0 0
)

NB. exact filesize resize as required by csv
NB. rows sizecol col - resize c file to have x rows
NB. csv files kept to exact msize - no roundup for pad
resizec=: 4 : 0
n=. >y{ccnames
f=. >y{ccfiles
c=. x*getcount y
csvunmap n;c
csvmap n;f     NB. not jdmap as we don't want roundup
settypeshape_jmf_ n;x colsub y
)

NB. size f col
resizev=: 4 : 0
vn=. >y{cvnames
f=. >y{cvfiles
csvunmap vn;x
csvmap vn;f
settypeshape_jmf_ vn;JCHAR;x
)

NB. createcols rows - create and map new c and v files
createcols=: 3 : 0
for_i. i.#coldefs do.
 if. a:~:i{ccfiles do. y makecol i end.
 if. a:~:i{cvfiles do. y makevar i end.
end.
)

NB. mapcols'' - map c and v files
mapcols=: 3 : 0
for_i. i.#coldefs do.
 f=. >i{ccfiles
 if. #f do. csvmap (>i{ccnames);f end.
 f=. >i{cvfiles
 if. #f do. csvmap (>i{cvnames);f end.
end.
i.0 0
)

unmapcols=: 3 : 0
csvunmap each (a:~:ccfiles)#ccnames
csvunmap each (a:~:cvfiles)#cvnames
i.0 0
)

ctypes=:  3 : '0{"1 coldefs'
ccounts=: 3 : '1{"1 coldefs'
cxtra=:   3 : '2{"1 coldefs'
cout=:    3 : '3{"1 coldefs'

NB. get column byte count (include CSTITCH)
getcount=: 3 : 0 "0
(y{ccounts'')*>:+/(CSTITCH=ctypes'')*y=cout''
)

namebytes=: 3 : 0
c=. */$".y
c*(2=3!:0".y){8 1
)

NB. get c byte counts
getcbytes=: 3 : 0
b=. a:~:ccfiles
(HS_jmf_-~;fsize each b#ccfiles) (b#i.#ccfiles)}(#ccfiles)#0
)

NB. get v byte counts
getvbytes=: 3 : 0
b=. a:~:cvfiles
(HS_jmf_-~;fsize each b#cvfiles) (b#i.#cvfiles)}(#cvfiles)#0
)

gads=: 15!:14 :: 0:"0

cname=: 3 : '''c_'',y,''_jdcsv_'''
vname=: 3 : '''v_'',y,''_jdcsv_'''
hname=: 3 : '''h_'',y,''_jdcsv_'''
ename=: 3 : '''e_'',y,''_jdcsv_'''

NB. f outpath
NB. change ccfiles/cvfiles after defaults
NB.  to put some files other places
cset=: 3 : 0
callbackc=: callbackv=: 0
csverrorfile=: jpath y,'/csverrors'
csvprogressfile=: jpath y,'/csvprogress'
ccfiles=: jpath each (<y),each,'/',each colnames,~each <'c_'
ccfiles=: a: ((a:=colnames)#i.#coldefs)}ccfiles
cvfiles=: jpath each (<y),each,'/',each colnames,~each <'v_'

NB. adjust ccfiles and cvfiles for links
links=. fread 'links.txt',~jdpath_jd_''
if. -.links-:_1 do.
 links=. >bd2_jd_ each <;._2 links
 for_i. i.#ccfiles do.
  if. a:~:i{ccfiles do.
   s=. 0 2}.each _3 _1{<;._2 (;i{ccfiles),'/'
   s=. <}:;s,each'/'
   
   j=. s i.~ {."1 links
   if. j<#links do.
    p=. ;{:j{links
    new=. <jpath p,'/',DB_jd_,'/',(#jdpath_jd_'')}.;i{ccfiles
    ccfiles=: new i}ccfiles
    t=. ;new
    t=. <'v' (>:t i: '/')}t
    cvfiles=: t i}cvfiles
   end.
  end.
 end. 
end.

t=. (a:~:ccfiles)#ccfiles
t=. (t i: each '/'){.each t
jdcreatefolder_jd_ each t NB. ensure path to files exists
if. -.appendflag do. ferase each ccfiles,cvfiles end. 
b=. -.(ctypes'')e. CVAR NB. CVARX
cvfiles=: a: (b#i.#coldefs)}cvfiles
ccnames=: a: ((a:=colnames)#i.#coldefs)}cname each colnames
cvnames=: a: (b#i.#coldefs)}vname each colnames
PATHLOGFILE=:    PATHCSVFOLDER,'/csvlog.txt'
'' fwrite PATHLOGFILE
if. -.fexist PATHLOGLOGFILE do. '' fwrite PATHLOGLOGFILE end.
i.0 0
)

clearerrors=: 3 : 0
csvunmap'csverrors_jdcsv_'
createjmf_jmf_ csverrorfile;SZI_jmf_*y*ECMAX*ECCOLS
csvmap 'csverrors_jdcsv_';csverrorfile
csverrors=: (y,ECMAX,ECCOLS)$23-23
)

clearprogress=: 3 : 0
csvunmap'csvprogress_jdcsv_'
createjmf_jmf_ csvprogressfile;SZI_jmf_*PROGRESSMAX
csvmap 'csvprogress_jdcsv_';csvprogressfile
csvprogress=: 0,ROWS,0,#csvin
)

checkprogress_z_=: 3 : 0
t=. _3 (3!:4) _32{.fread  jpath y,'/csvprogress'
t,<.100*%/2 3{t
)

csvcommon=: 3 : 0
'PATHCSVFOLDER PATHCSVFILE ROWS'=: y
TABLE=: (>:PATHCSVFOLDER i: '/')}.PATHCSVFOLDER
GROW=: ROWS=0
if. GROW do. ROWS=: RESIZESTRESS{NEWROWS end.  NB. initial allocation
)

csvload=: 3 : 0
csvcommon y
csvld 'load'
)


NB. csvappend depends on files having exact size - no extra filesize and no padding
csvappend=: 3 : 0
csvcommon y
csvld 'append'
)

ECTOOMUCHMSG=: 0 : 0

ECTOOMUCH - serious error
end-of-file before end-of-field/row
perhaps a cdefs error:
 for example, " option required
 or " option needs \ option
perhaps bad data
 see report and examine indicated area in the csv file

)

csvscan=: 3 : 0
d=. fread csvfpcdefs_jd_
'cdefs file not found'assert _1-.@-:cdefs
NB. get options and max col from cdefs
d=. <;._2 d
i=. (8{.each d) i: <'options '
options 8}.;i{d
opts=. COLSEP,(2{.ROWSEP),QUOTED,ESCAPED
cols=. >:>./;0".each(d i. each' '){.each d NB. scan an extra col
PATHCSVFILE=: csvfp_jd_
'ina inz'=. setinput''
r=. xscan (opts;cols;ina;inz),<cols$_1
maxwidths=: >5{r
r=. >{.r
unmapall_jmf_''
r
)

setinput=: 3 : 0
if. 0=fsize PATHCSVFILE do.
 csvin_jdcsv_=: ''  NB. map empty file fails
 ina=. inz=. 0
else.
 JCHAR jdmap_jd_ 'csvin_jdcsv_';(jpath PATHCSVFILE);'';1 NB. map csv readonly
 ina=. 15!:14<'csvin_jdcsv_'
 inz=. ina+#csvin_jdcsv_
end.
inaoffset=: 0
if. (0=HEADERS)*.BOMUTF8_jd_-:3{.csvin_jdcsv_ do. inaoffset=: 3 end.
if. (0~:HEADERS)*.0~:fsize PATHCSVFILE do.
 if. BOMUTF8_jd_-:csvin_jdcsv_ do.   NB. otherwise index error below
  inaoffset=: 3
 else.
  probe=. HEADERS*50000
  t=. (#ROWSEP)+(<:HEADERS){(ROWSEP E. probe{.csvin)#i.probe
  assert t<:#csvin
  inaoffset=: t
 end.
end.
ina=. ina+inaoffset
ina;inz
)

NB. f 'load' or 'append'
csvld=: 3 : 0
TA=: 6!:1''
assert (<y) e. ;:'load append'
appendflag=: y-:'append'
loadflag=:   y-:'load'
'rows invalid' assert ROWS>:0
(PATHCSVFILE,' does not exist') assert fexist PATHCSVFILE
'no cdef file' assert #PATHCSVFILE
'no cdef folder'  assert #PATHCSVFOLDER
'no cdef options' assert #COLSEP
'no cdef size'    assert #ROWS
jdclean''
unmapall_jmf_''
erase 'csvin_jdcsv_' NB. might be '' from empty file
if. -.appendflag do.
 jddeletefolder_jd_ PATHCSVFOLDER
 jdcreatefolder_jd_ PATHCSVFOLDER
 'csv'fwrite PATHCSVFOLDER,'/jdclass' NB. allow deletes
end.
assert fexist PATHCSVFILE
cset PATHCSVFOLDER
unmapall_jmf_''
log LF,'!',y,' ',TABLE
log 'snk: ',PATHCSVFOLDER
log 'src: ',PATHCSVFILE
log 'start: ',(":<.6!:0''),LF,}:CDEFS

NB. AUTO
if. COLSEP-:,{.a. do.
 t=. fread PATHCSVFILE;0,5000 <. fsize PATHCSVFILE
 i=. <./t i. TAB,',','|'
 'COLSEP AUTO: TAB,COMMA, or STILE not found' assert i<#t
 COLSEP=: i{t
end.
if. ROWSEP-:,{.a. do.
 t=. fread PATHCSVFILE;2,~_2+fsize PATHCSVFILE
 ROWSEP=: (-.CR={.t)}.t
 'ROWSEP AUTO: not CRLF or CR or LF' assert (<ROWSEP) e. ,each CRLF;CR;LF
end.

'ina inz'=. setinput''
if. -.appendflag do.
 oldrows=. 0
 createcols ROWS NB. create and map output files
 t=. gads cvnames
 ptrs=. (gads ccnames);t;(0+t);t+getvbytes''
 var=. (#coldefs)#2-2 NB. var offset for new
else.
 mapcols''
 oldrows=. ".'#',>{.(a:~:ccnames)#ccnames
 cbytes=. getcbytes''
 vbytes=. getvbytes''
 var=.vbytes NB. var offset for append
 (ROWS+oldrows) resizec each (a:~:ccfiles)#i.#coldefs
 b=. a:~:cvfiles
 (b#vbytes+ROWS*cxtra'') resizev each b#i.#coldefs
 t=. gads cvnames
 newvbytes=. getvbytes''
 ptrs=. (cbytes+gads ccnames);t;(vbytes+t);newvbytes+t
end.
clearerrors #coldefs
clearprogress''
maxwidths=: (#coldefs)$2-2
erra=. 15!:14<'csverrors'
errz=. erra+SZI_jmf_**/$csverrors
cbd=: mema 8*#coldefs            NB. callback col results
opts=. COLSEP,(2{.ROWSEP),QUOTED,ESCAPED,(0{a.),((-.GROW){a.),EPOCH
t=. cdcb1;cbd;opts;ROWS;(#coldefs);erra;errz;ina;inz
t=. t,(<|:coldefs),ptrs,<15!:14<'var'
t=. t,<15!:14<'csvprogress'
t=. t,<maxwidths
r=. >{.xcsv t
memf cbd
NB. resize c files to remove unused rows
NB. log'remove extra c_..._jdcsv_ rows: ',":|r
ROWS=: oldrows+ROWS+r NB. rows to keep
if. r<0 do.
 ROWS resizec each (a:~:ccfiles)#i.#coldefs
end.
NB. resize v files
for_i. i.#coldefs do.
 if. a:~:i{cvfiles do.
  NB. log'remove extra ',(>i{cvnames),' bytes: ',":(fsize i{cvfiles)-i{var
  (i{var) resizev i
 end.
end.

NB. csv mappings must be left at exact size for possible csvappend
TZ=: 6!:1''
NB. log 'callbackc count: ',":callbackc
NB. log 'callbackv count: ',":callbackv
log 'elapsed: ',":<.0.5+TZ-TA
NB. log 'rows/Sec: ',":<.0.5+ROWS%TZ-TA
log 'rows: ',":ROWS-oldrows
log ''
csverror_z_=: csverrs''
csverrorcount_z_=: #}.csverror
(3!:1 csverror) fwrite PATHCSVFOLDER,'/csverror.dat'
(3!:1 csverrorcount) fwrite PATHCSVFOLDER,'/csverrorcount.dat'
if. csverrorcount do.
 log ,LF,.~'error: ',"1 sptable csverror
end.

b=. 3={."1 coldefs
d=. (1{"1 b#coldefs),.b#maxwidths
names=. b#colnames
if. MANGLEDNAMES do. names=. b#originalnames end.
r=. fread PATHLOGFILE
r fappend PATHLOGLOGFILE
a=. (ctypes''){CTYPES_jdcsv_
b=. (JDTMAP_jdcsv_ i. a){JDTYPES_jdcsv_
b=. (-each'x'=each{:each b)}.each b NB. remove x for datex datetimex
c=. }.each".each'$',each ccnames
c=. a: ((a=<'CVAR')#i.#a)}c
INFO=: colnames;a;b;c;<coldefs
(3!:1 INFO,<ROWS) fwrite PATHCSVFOLDER,'/info'
r
)

0 : 0
NB. old code no longer used
NB. prior to csvsca - load kept track of maxwidth
NB. and that difference was reported here
trun=. </"1 d
padd=.  >/"1 d
pn=. padd#names
pv=. padd#d
tn=. trun#names
tv=. trun#d
 
h=. ;:'col cdefs actual' 
if. 0~:#tn do. 
 log ,LF,.~'truncated: ',"1 sptable h,tn,.":each <"0 tv
end.
if. 0~:#pn do.
 log ,LF,.~'padded: ',"1 sptable h,pn,.":each <"0 pv
end. 
)


cdcb1=: cdcb 1

NB. callback to increase file allocations
NB. y col   - resize col v file
NB. y 100e6 - resize all c files 
cdcallback=: 3 : 0
NB. fancier size increase cased on csvprogress is possible
p=. 2 NB. callback factor size increase
if. y~:100e6 do.
 callbackv=: >:callbackv
 g=. (RESIZESTRESS{NEWROWS)*y{cxtra''
 NB. log 'callbackv: add ',(":g),' bytes for ',>y{cvnames
 g=. g+(fsize y{cvfiles)-HS_jmf_
 g resizev y
 ((0,g)+15!:14 y{cvnames) memw cbd,0,2,JINT
 g NB. callback result - c program could use this instead of cbd[1]
else.
 callbackc=: >:callbackc
 if. -.GROW do. 0 return. end.
 t=. (-.ccfiles=a:)i.1
 r=:  <.(t{getcbytes'')%getcount t NB. rows in file
 g=. RESIZESTRESS{NEWROWS
 NB. log 'callbackc: add ',(":g),' rows to all c files'
 ROWS=: ROWS+g
 s=. >HS_jmf_-~each fsize each ccfiles NB. current end
 (r+g) resizec each (a:~:ccfiles)#i.#coldefs
 rca=. s+gads ccnames
 rca memw cbd,0,(#coldefs),JINT  NB. new adds passed back in cdb
 g NB. callback result
end.
)

ECCOLS=: 3 NB. cols in errors for each row (count,p,row)

'ECUNUSED ECTOOMUCH ECTRUNCATE ECBADNUM ECCRLF ECMISSING EC01 ECEARLY ECESCAPE ECEPOCHP ECEPOCH ECMAX'=: i.12

ecodes=: <;._2[0 : 0
ECUNUSED    not used
ECTOOMUCH   end-of-file before end-of-col
ECTRUNCATE  truncate
ECBADNUM    bad number
ECCRLF      CRLF missing LF
ECMISSING   empty or all blank field
EC01        CVARX 0 1 mapped
ECEARLY     not used
ECESCAPE    not used - was escape not 0 n t " or \
ECEPOCHP    extra precision ignored
ECEPOCH     bad epoch
)

errors=: 3 : 0
+/,{."1 csverrors
)

NB. may not work correctly with stitch col vs outcol
csverrs=: 3 : 0
t=. 1 6$'col';'error';'#';'row';'position';'text'
if. 0=errors'' do. t return. end.
for_i. i.#ccnames do.
 e=. i{csverrors
 b=. 0~:{."1 e
 if. +/b do.
  n=. ,.each <"1 |:b#e
  nm=. _7}.each 2}.each i{ccnames
  if. MANGLEDNAMES do.nm=. i{originalnames end.
  NB. nm=. (<TABLE,' '),each nm
  t=. t,1 6$nm,(<>b#ecodes),n,<seecsv"0[b#inaoffset+2{"1 e
 end.
end.
t
)

'PROGRESSROW PROGRESSROWS PROGRESSINDEX  PROGRESSSIZE PROGRESSMAX'=: i.5

seecsv=: 3 : 0"0
t=. (y+i.20<.(#csvin)-y){csvin
t rplc LF;' LF ';CR;' CR '
)

NB. colpath=. f csvcolname 
getcolpath=: 3 : 0
f=. >(colnames i. <y){ccfiles
f=. (f i:'/'){.f
)

NB. tablepath=. f csvcolname 
gettablepath=: 3 : 0
f=. getcolpath y
f=. (f i:'/'){.f
)


options=: 3 : 0
t=. <;._2 ' ',~deb y
if. 5=#t do. t=. t,<'iso8601-char' end. NB. epoch default
assert 6=#t
'c r q e h epoch'=: t
COLSEP=: c rplc 'BLANK';' ';'TAB';TAB;'AUTO';{.a.
assert 1=#COLSEP
ROWSEP=: r rplc 'CR';CR;'LF';LF;'CRLF';CRLF;'AUTO';{.a.
assert +./1 2=#ROWSEP
QUOTED=: q rplc 'NO';' '
assert 1=#QUOTED
ESCAPED=: e rplc 'NO';' '
assert 1=#ESCAPED
HEADERS=: _1".h
assert (0<:HEADERS)*.10>:HEADERS
EPOCH=: ":epoch-:'iso8601-int'
assert +./(<epoch)='iso8601-char';'iso8601-int'
)

NB. extend coldefs etc as required
cdefx=: 3 : 0
if. y>#coldefs do.
 c=. y-#coldefs
 coldefs=:  coldefs,((c,3)$0),.(#coldefs)+i.c
 colnames=: y{.colnames
 elidedx=: y{.elidedx
end.
)

csvdefs=: 3 : 0
y=. toJ y
ROWS=: CDEFS=: COLSEP=: PATHCSVFOLDER=: PATHCSVFILE=: ''
coldefs=: 0 4$0
colnames=: 0$<''
elidedx=: i.0
cdef each <;._2 y

NB. pass through if valid simple names
originalnames=: colnames
d=. colnames-.a:
MANGLEDNAMES=: (-.*./0=;#each d-.each<AlphaNum_j_)+. -.*./(;{.each d) e. Alpha_j_
if. MANGLEDNAMES do.
 colnames=: 'a',each ":each i.#colnames
 colnames=: a: ((a:=originalnames)#i.#colnames)}colnames
end.

i.0 0
)

NB. f ' num name type [xtra] '
cdef=: 3 : 0
y=. dlb y
i=. y i.' '
c=. i{.y
d=. i}.y
if. c-:'options' do.
 options d
elseif. '#'={.c do.
elseif. 1 do.
 'col name type xtra'=. 4{.bdnames_jd_ y,' elided'
 ('csv cdef invalid col number: ',y) assert _1-.@-:_1".col
 try. vcname_jd_ name catch. ('csv cdef invalid name: ',y)assert 0 end.
 if. -.type-:'CSTITCH' do. ('csv cdef duplicate name: ',y) assert -.(<name)e.colnames end. 
 if. -.(<type)e.CTYPES do.
  ('csv cdef invalid type: ',y) assert (<type)e.JDTYPES
  type=. >(JDTYPES i.<type){JDTMAP
 end.
 NB. ('csv cdef invalid width: ',y) assert  -.xtra-:,'0' 
 type=. ".type
 elf=. xtra-:'elided'
 if. type-:CI8X do. elf=. 1 end. NB. kludge for shift vs count
 
 if. xtra='e' do. xtra=. (type=CCHAR){'01' end. 
 'col xtra'=. _1".each col;xtra
 ('csv cdef invalid col: ',y) assert (col>:0)*.col<10000
 ('csv cdef invalid xtra: ',y) assert xtra>:0
 count=. (types i.type){counts
 if. (type=CVAR)*.xtra=0 do. xtra=. RESIZESTRESS{VBYTES end.
 if. type=CSTITCH do.
  t=. (CSTITCH~:{."1 coldefs)i:1 NB. outcol
  ('csv cdef invalid CSTITCH: ',y)assert (col=>:#coldefs)*.name-:;t{colnames
  coldefs=: coldefs,type,0,0,t
  colnames=: colnames,<''
 else.
  cdefx col
  col=. <:col
  if. type=CCHAR do.
   count=. xtra
  end.
  coldefs=: (type,count,xtra,col) col}coldefs
  colnames=: (<name) col}colnames
  elidedx=: elf col}elidedx
 end.
end.
CDEFS=: CDEFS,y,LF
i.0 0
)

maps=: 3 : 0
>{."1 mappings_jmf_
)

NB. not used, but might be useful
NB. map all files in folder y (except for log.txt and info)
mapall=: 3 : 0
n=. {."1 [1!:0 <jpath y,'/*'
n=. n-.'log.txt';'info'
f=. (<jpath y),each,'/',each n
n=. n,each<'_jdcsv_'
for_i. i.#n do.
 csvmap (i{n),i{f
end.
)
