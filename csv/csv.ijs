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
CMAX=:       20

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
)

NB. map JDtypes to csv Ctypes
JDTYPES=: ;:'int  int  float   byte  varbyte date  datex  datetime  datetimex  boolean unsupported'
JDTMAP=:  ;:'CI8  CI8X CDOUBLE CCHAR CVAR    CDATE CDATEX CDATETIME CDATETIMEX CBOOLEAN'

types=: i.CMAX
counts=: 0 16 8 1 1 2 4 8 8 8 8 8 0 0 0 1 8 8 8 0

DBAD=: _1.7976931348623157e308 NB. bad double value

NB. pps=: 9!:11
NB. pps 18

3 : 0''
NB.     I xcsv(I callback, I* cbd, char* options,
t=.   ' x      x           x       *c'
NB.     I rows, I cols, I* erra, I* errz,
t=. t,' x       x       x        x'
NB.     char* ina, char* inz, I* colinfo, I* da,
t=. t,'   x               x              *x             *x'
NB.     I* va, I* vx, I* vz,  I* var, I* progress)
t=. t,'  *x      *x      *x       x        x'
xcsv=:  (LIBJD_jd_,' xcsv ',t)&cd
i.0 0
)

log=: 3 : 0
if. 1=L. y do.
 t=. ,LF,.~showbox y
else.
 t=. y,LF
end.
t fappend PATHLOGFILE
)

jdclean=: 3 : 0
jd_close_jd_''
)
 
free=: 3 : 0
NB. cdf''
NB. unmapall_jmf_''
i.0 0
)

csvmap=: 3 : 0
jdmap_jd_ y
)

csvunmap=: 3 : 0
jdunmap_jd_ y
)

NB. rows makecol col - create and map c file
makecol=: 4 : 0
n=. >y{ccnames
f=. >y{ccfiles
c=. getcount y
jdcreatejmf_jd_ f;x*c
csvmap n;f
settypeshape_jmf_ n;x colsub y
)

NB. rows sizecol col - resize c file to have x rows
resizec=: 4 : 0
n=. >y{ccnames
f=. >y{ccfiles
c=. x*getcount y
setmsize_jmf_ n;c
settypeshape_jmf_ n;x colsub y
csvunmap n
newsize_jmf_ f;HS_jmf_+c
csvmap n;f
i.0 0
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
 if. (c=8)*.y{elidedx do. NB.!
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
jdcreatejmf_jd_ f;c
csvmap n;f
settypeshape_jmf_ n;JCHAR;c
i.0 0
)

NB. size f col
resizev=: 4 : 0
vn=. >y{cvnames
f=. >y{cvfiles
setmsize_jmf_ vn;x
settypeshape_jmf_ vn;JCHAR;x
csvunmap vn
newsize_jmf_ f;HS_jmf_+x
csvmap vn;f
i.0 0
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
NB.! ccfiles=: a: ((CVARX=ctypes'')#i.#coldefs)}ccfiles
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
if. loadflag do. ferase each ccfiles,cvfiles end. 
b=. -.(ctypes'')e. CVAR NB.! CVARX
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
jdcreatejmf_jd_ csverrorfile;SZI_jmf_*y*ECMAX*ECCOLS
csvmap 'csverrors_jdcsv_';csverrorfile
csverrors=: (y,ECMAX,ECCOLS)$23-23
)

clearprogress=: 3 : 0
csvunmap'csvprogress_jdcsv_'
jdcreatejmf_jd_ csvprogressfile;SZI_jmf_*PROGRESSMAX
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

csvappend=: 3 : 0
csvcommon y
csvld 'append'
)

csvcount=: 3 : 0
assert 0['not supported'
save=. coldefs;<colnames
'coldefs colnames'=: (0 4$0);<0$<''
ROWS=: <.2^62
r=. csvld 'count'
'coldefs colnames'=: save
r
)

NB. f 'load' or 'append'
csvld=: 3 : 0
TA=: 6!:1''
assert (<y) e. ;:'load append count'
appendflag=: y-:'append'
countflag=:  y-:'count'
loadflag=:   y-:'load'
'rows invalid' assert ROWS>:0
(PATHCSVFILE,' does not exist') assert fexist PATHCSVFILE
'no cdef file' assert #PATHCSVFILE
'no cdef folder'  assert #PATHCSVFOLDER
'no cdef options' assert #COLSEP
'no cdef size'    assert #ROWS
jdclean''
unmapall_jmf_'' 
if. -.appendflag do.
 jddeletefolder_jd_ PATHCSVFOLDER
 jdcreatefolder_jd_ PATHCSVFOLDER
end.
assert fexist PATHCSVFILE
cset PATHCSVFOLDER
unmapall_jmf_''
log LF,'!',y,' ',TABLE
log 'snk: ',PATHCSVFOLDER
log 'src: ',PATHCSVFILE
log 'start: ',(":<.6!:0''),LF,}:CDEFS
if. COLSEP-:,{.a. do.
 t=. fread PATHCSVFILE;0,5000 <. fsize PATHCSVFILE
 i=. <./t i. TAB,',','|'
 'COLSEP AUTO: TAB,COMMA, or STILE not found' assert i<#t
 COLSEP=: i{t
end.
log 'colsep: ',(,":a.i.COLSEP),' ' , ;((9 32{a.)i.COLSEP){'TAB';'SPACE';COLSEP
if. ROWSEP-:,{.a. do.
 t=. fread PATHCSVFILE;2,~_2+fsize PATHCSVFILE
 ROWSEP=: (-.CR={.t)}.t
 'ROWSEP AUTO: not CRLF or CR or LF' assert (<ROWSEP) e. ,each CRLF;CR;LF
end.
log 'rowsep: ',(":a.i.ROWSEP),' ',;((,each CR;LF;CRLF)i.<ROWSEP){'CR';'LF';'CRLF';''

NB. a=. (ctypes''){CTYPES_jdcsv_
NB. b=. (JDTMAP_jdcsv_ i. a){JDTYPES_jdcsv_
NB. b=. (-each'x'=each{:each b)}.each b NB. remove x for datex datetimex
NB. INFO=: colnames;a;b;<coldefs
NB. (3!:1 INFO,<_1) fwrite PATHCSVFOLDER,'/info'

JCHAR jdmap_jd_ 'csvin_jdcsv_';(jpath PATHCSVFILE);'';1 NB. map csv readonly
ina=. 15!:14<'csvin_jdcsv_'
inz=. ina+#csvin_jdcsv_
if. 0~:HEADERS do.
 t=. >:(<:HEADERS){((5000{.csvin)={:ROWSEP)#i.5000
 assert t<#csvin
 ina=. ina+t
end.
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
erra=. 15!:14<'csverrors'
errz=. erra+SZI_jmf_**/$csverrors
cbd=: mema 8*#coldefs            NB. callback col results
opts=. COLSEP,(2{.ROWSEP),QUOTED,ESCAPED,(0{a.),(-.GROW){a.
t=. cdcb1;cbd;opts;ROWS;(#coldefs);erra;errz;ina;inz
t=. t,(<|:coldefs),ptrs,<15!:14<'var'
t=. t,<15!:14<'csvprogress'
r=. >{.xcsv t
memf cbd
NB. resize c files to remove unused rows
log'remove extra c_..._jdcsv_ rows: ',":|r
if. r<0 do.
 ROWS=: oldrows+ROWS+r NB. rows to keep
 ROWS resizec each (a:~:ccfiles)#i.#coldefs
end.
NB. resize v files
for_i. i.#coldefs do.
 if. a:~:i{cvfiles do.
  log'remove extra ',(>i{cvnames),' bytes: ',":(fsize i{cvfiles)-i{var
  (i{var) resizev i
 end.
end. 
TZ=: 6!:1''
log 'callbackc count: ',":callbackc
log 'callbackv count: ',":callbackv
log 'elapsed: ',":<.0.5+TZ-TA
log 'rows/Sec: ',":<.0.5+ROWS%TZ-TA
log 'rows: ',":ROWS-oldrows
csverror_z_=: csverrs''
csverrorcount_z_=: #}.csverror
if. csverrorcount do.
 log }:,LF,.~'error: ',"1 showbox csverror
end.
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
 log 'callbackv: add ',(":g),' bytes for ',>y{cvnames
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
 log 'callbackc: add ',(":g),' rows to all c files'
 ROWS=: ROWS+g
 s=. >HS_jmf_-~each fsize each ccfiles NB. current end
 (r+g) resizec each (a:~:ccfiles)#i.#coldefs
 rca=. s+gads ccnames
 rca memw cbd,0,(#coldefs),JINT  NB. new adds passed back in cdb
 g NB. callback result
end.
)

ECCOLS=: 3 NB. cols in errors for each row (count,p,row)

'ECUNUSED ECTOOMUCH ECTRUNCATE ECBADNUM ECCRLF ECROWSEP EC01 ECEARLY ECESCAPE ECMAX'=: i.10

ecodes=: <;._2[0 : 0
ECUNUSED   unused
ECTOOMUCH  field too long
ECTRUNCATE truncate
ECBADNUM   bad number
ECCRLF     CRLF missing LF
ECROWSEP   ROWSEP missing
EC01       CVARX 0 1 mapped
ECEARLY    unused csv data
ECESCAPE   escape not 0 n t " or \
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
  NB. nm=. (<TABLE,' '),each nm
  t=. t,1 6$nm,(<>b#ecodes),n,<seecsv"0[b#2{"1 e
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

NB. f name - convert byte n col to enum
createenum=: 3 : 0
i=. colnames i. <y
cn=. >i{ccnames
en=. ename y
fn=. (getcolpath y),'/c_',y
fe=. (getcolpath y),'/e_',y
r=. ".'#',cn
e=. ".'~.',cn
jdcreatejmf_jd_ fe;*/$e
csvmap en;fe
".en,'=:e'
n=.".en,' i. ',cn
csvunmap <cn
jdcreatejmf_jd_ fn;SZI_jmf_*r
csvmap cn;fn
".cn,'=:n'
coldefs=: (CI8,0 0 0)i}coldefs
'CSVCOLS CSVTYPS CSVJDTYPS COLDEFS ROWS'=. 3!:2 fread PATHCSVFOLDER,'/info'
t=. (<'int') (CSVCOLS i. <y)}CSVJDTYPS
(3!:1 CSVCOLS;CSVTYPS;(<t),<coldefs) fwrite PATHCSVFOLDER,'/info' NB.! map enum to JD int
)

NB. f name - create hash from data
NB. assumes d_name is char matrix
createhash=: 3 : 0
i=. colnames i. <y
cn=. >i{ccnames
hn=. hname y
fn=. (getcolpath y),'/c_',y
fh=. (getcolpath y),'/h_',y
'c w'=. ".'$',cn
csvunmap <hn
jdcreatejmf_jd_ fh;SZI_jmf_*c
csvmap hn;fh
settypeshape_jmf_ hn;JINT;c,1
xhash (<15!:14<hn);c;(<15!:14<cn);w
NB. csvunmap cn
NB. csvunmap hn
i.0 0
)

NB. f colname;newname;value
NB. colname must be mapped
NB. new file created in same path as colname with same #
createi=: 3 : 0
'colname name value'=. y
value=. 0+value
assert 0=$value
assert 4=3!:0 value
f=. (getcolpath colname),'/c_',name
n=. cname name
rows=. ".'#',>(colnames i. <colname){ccnames
csvunmap <n
jdcreatejmf_jd_ f;rows*SZI_jmf_
csvmap n;f
settypeshape_jmf_ n;JINT;rows,1
xseti (<15!:14<n);rows;value
i.0 0
)

NB. not tested and needs changes
NB. f colname;newname;value
appendi=: 3 : 0
'colname name value'=. y
value=. 0+value
assert 0=$value
assert 4=3!:0 value
f=. (gettablepath colname),'/',name,'/DAT'
n=. cname name
csvunmap <n
csvmap n;f
newrows=. ".'#c_',colname
oldrows=. ".'#c_',name
if. oldrows=newrows do. return. end.s
assert oldrows<newrows
c=. SZI_jmf_*newrows
setmsize_jmf_ n;c
settypeshape_jmf_ n;JINT;newrows,1
csvunmap n
newsize_jmf_ f;HS_jmf_+c
csvmap n;f
xseti (<(SZI_jmf_*oldrows)+15!:14<n);(newrows-oldrows);value
i.0 0
)

options=: 3 : 0
t=. <;._2 ' ',~deb y
assert 5=#t
'c r q e h'=: t
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
i.0 0
)

NB. f ' num name type [xtra] '
cdef=: 3 : 0
y=. deb y
i=. y i.' '
c=. i{.y
d=. i}.y
if. c-:'options' do.
 options d
elseif. 1 do.
 'col name type xtra'=. 4{.<;._2 ' elided ',~deb y
 ('csv cdef invalid col number: ',y) assert _1~:_1".col
 ('csv cdef invalid name:',y)assert _2~:nc<name
 if. -.(<type)e.CTYPES do.
  ('csv cdef invalid type: ',y) assert (<type)e.JDTYPES
  type=. >(JDTYPES i.<type){JDTMAP
 end.
 ('csv cdef invalid width: ',y) assert  -.xtra-:,'0' 
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
  if. type=CCHAR do. count=. xtra end.
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
