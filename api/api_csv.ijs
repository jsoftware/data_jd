NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. routines for csv rd/wr operations

coclass'jd'

BOMUTF8=: 239 187 191{a.

NB. getnext x args from boxed list
NB. error if too few or too many
getnext=: 4 : 0
'invalid number of args'assert x=#y
y
)

NB. '' or filename
csvset=: 3 : 0
csvy=: y NB. original arg foo.csv or foo.link
if. IFJHS do.
 NB. assert -.(<'jjd')e. conl 0['job must run in task that is not a server'
 'job must run in task that is not a server' assert ''-:OKURL_jhs
end.
assert 0=nc<'CSVFOLDER__'['CSVFOLDER must be defined as path to csv files'
CSVFOLDER__=: CSVFOLDER__,>('/'={:CSVFOLDER__){'/';''
jdcreatefolder CSVFOLDER__
'csv'fwrite CSVFOLDER__,'jdclass'
if. ''-:y do. return. end.
if. '.csvlink'-:_8{.y do.
 csvfp=: fread CSVFOLDER__,y
else.
 csvfp=: CSVFOLDER__,y
end.
csvf=: (>:csvfp i: '/')}.csvfp
root=: (csvy i:'.'){.csvy
csvfpcdefs=:   CSVFOLDER__,root,'.cdefs'
csvfpcnames=:  CSVFOLDER__,root,'.cnames'
csvfpcwidths=: CSVFOLDER__,root,'.cwidths'
)

jd_csvscan=: 3 : 0
csvset y
r=. csvscan_jdcsv_''
if. r<0 do. (;ecodes_jdcsv_{~-r)assert 0 end.
rows=. ":r
w=. maxwidths_jdcsv_
(":w)fwrite csvfpcwidths
d=: fread csvfpcdefs
d=: <;._2 d
rep=. 'Jd report: csvscan ',y,LF
rep=. rep,'rows: ',rows,LF
rep=. rep,(_1~:{:w)#'warning: col data after max cdefs col',LF  
rep=. rep,'col widths in file: ',root,'.cwidths',LF
w=. w rplc _1;0 NB. cols with no data may still have had a coldef
for_i. i.#d do.
 a=. ;i{d
 b=. <;._2 (deb a),' '
 n=. 0".;0{b
 if. (0~:n)*.'byte'-:;2{b do.
  j=. >:a i: 'e'
  t=. j{.a
  b=. 0".j}.a
  c=. (<:n){w
  if. -.(0=#b)*.1=c do. NB. blank -> 1 stays blank
   if. b~:c do.
    rep=. rep,LF,~a,' -> ',":c
    t=. <t,'      ',":c
    d=. t i}d
   end. 
  end. 
 end.
end.
(;LF,~each d)fwrite csvfpcdefs
,.'Jd report csvscan';rep
)

NB. nasty overlap with read option
fixoption_e=: 3 : 0
option_csve=: option_e NB. nasty overlap with read option
erase'option_e'
)

jd_csvwr=: 3 : 0
a=. ca'/combine 0 /e 0 /h1 0 /w 0' getopts y
fixoption_e''
header=. option_h1
if. option_w do.
 w=. >{:a
 a=. }:a
else.
 w=. ''
end.
csvset ;0{a
'table does not exist'assert NAMES__dbl e.~1{a
table=. ;1{a
cols=. 2}.a

ns=. getparttables table
csvs=. <_4}.>{.a
csvs=. csvs,each (#table)}.each ns
t=. (<CSVFOLDER__),each csvs,each<'.csv'
t=. t,(<CSVFOLDER__),each csvs,each<'.cdefs'
ferase t
c=. fexist"0 t
('unable to erase files:',(;' ',each c#t))assert 0=c 
csvs=. csvs,each<'.csv'
if. 1=#ns do.
 (w;(<cols),<1) csvwr csvs,ns
else.
 new=: 1
 if. option_combine do.
  ns=. 2}.ns NB. drop f and f~
  csvs=. (#ns)${.csvs
  'create csv file failed' assert 0=''fwrite CSVFOLDER__,;{.csvs
  for_i. i.#ns do.
   (w;(<cols),<new) csvwr (i{csvs),i{ns
   new=. 0
  end.
 else.
  for_i. i.#ns do.
   wx=. ;((1=#ns)+.2<:i){'';w NB. no where for f and f~
   (wx;(<cols),<1) csvwr (i{csvs),i{ns
  end.
 end. 
end.
JDOK
)

csvwr=: 4 : 0
'w cols new'=. x
a=. y
csvset ;0{a
table=. >1{a
p=. (csvfp i:'/'){.csvfp
jdcreatefolder p
t=. getloc__dbl table
all=. getdefaultselection__t''
if. 0=#cols do.
 cols=. all
else.
 assert 0=#cols-.all['invalid cols'
end.
coln =. getloc__t@> cols
typ =. 3 :'<typ__y'"0 coln
shape =. 3 :'<shape__y'"0 coln
ECSVBYTE0 assert ;shape~:<,0
b=. (jdaddq_jd_ each cols),.typ,.shape
r=. b
b=. 0 3$''
for_m. r do.
 b=. b,m
 if. ((<'byte')~:1{m)*.(a:~:2{m){0,1<>2{m do.
  b=. b, ( (<:>2{m) ,3 )$    ({.m),(<'CSTITCH'),a:
 end.  
end.
b=. (":each b),each' '
b=. (>0{"1 b),.(>1{"1 b),.>2{"1 b
c=. ,(' ',.~>":each<"0 >:i.#b),.b,.LF
c=. c,'options TAB LF NO \ ',(":option_h1),(;option_csve{' iso8601-char ';' iso8601-int '),LF
'create cdefs file failed' assert (#c)=c fwrite csvfpcdefs

if. -.option_combine do. ''fwrite csvfp end.

if. #w do.
 try.
  rows=. ,>{:jdi_reads'jdindex from ',table,' where ',w
 catchd.
  assert 0['where clause failed'
 end. 
else.
  rows=. i.Tlen__t
end.
WriteCsv__t csvfp;option_h1;cols;rows;option_csve;new
)

NB. copyscripts snk;src
copyscripts=: 3 : 0
'snk src'=. y
fs=. 1 dir src,'*.ijs'
for_f. fs do.
 f=. ;f
(fread f)fwrite snk,(f i:'/')}.f
end.
)

NB. write db tables and script to folder y
jd_csvdump=: 3 : 0
y=. ca'/e 0 /replace 0' getopts y
fixoption_e''
if. option_replace do. jddeletefolder CSVFOLDER__ end.
csvset''
assert 1=#dir CSVFOLDER__['CSVFOLDER must contain only jdclass'
tabs=. {."1 jdtables''
for_t. tabs do.
 t=. ;t
 option_h1=: option_combine=: 0
 ('';'';1) csvwr (t,'.csv');t 
end.
NB. create jdcsvrefs.txt file (used by csvresore to create ref cols)
'a b'=. {:jdi_info'ref'
((,LF,.~a,.5}."1 b)rplc"1 '_';' ')fwrite CSVFOLDER__,'jdcsvrefs.txt'
copyscripts CSVFOLDER__;jdpath_jd_''
i.0 0
)

NB. [options] csvfile table 
jd_csvrd=: 3 : 0
csvset''
a=. ca'/rows 1 /cdefs 0'getopts y
rows=. option_rows_jd_ NB. scalar required!
if. option_cdefs_jd_ do.
  'CDEFSFILE not defined' assert 0=nc<'CDEFSFILE__'
  'CDEFSFILE does not exist' assert fexist CDEFSFILE__
end.
'csv table'=. 2 getnext a
csvset csv
csv=. csvfp
('csv file does not exist: ',csv)assert fexist csv
vtname table

fs=. {."1[1!:0 jpath (_4}.csv),PTM,'*.csv'
if. #fs do.
 fs=. (<csv),fs,~each<CSVFOLDER__
 '/cdefs not supported'assert -.option_cdefs_jd_
 echo^:(0<#) >(#~ -.@fexist"0) (_4}.each fs),each<'.cdefs'
 'one or more missing cdefs' assert fexist"0 (_4}.each fs),each<'.cdefs'

 ts=. _4}.each fs
 ts=. (#;{.ts)}.each ts
 ts=. ts,~each<table

 for_i. i.#fs do.
  t=. ;i{fs
  csvset (>:t i:'/')}.t
  csvrd (i{fs),(i{ts),rows;0
 end.
else.
 csvrd csv;table;rows;option_cdefs_jd_
end. 
JDOK
)

NB. make following into csvrd routine
NB. call csvrd routine for the single file or for each of the partition files
csvrd=: 3 : 0
'csv table rows flagcdefs'=: y
csv=.   csv
cdefs=. (_3}.csv),'cdefs'
echo^:(-.@:fexist) csv
assert fexist csv
assert -.(<table)e.{."1 jdtables''['table already exists'
if. flagcdefs do.
 cdefs=. fread CDEFSFILE__
else.
 cdefs=. fread  csvfpcdefs
end. 
'cdefs file not found'assert _1-.@-:cdefs
csvdefs_jdcsv_ cdefs
csvreportclear_jdcsv_''              NB. clear log file of old reports
path=. PATH__dbl
jdfolder=.  path,table
csvfolder=. jdfolder,'/jdcsv'        NB. folder for csv intermediate files and reports
csvload_jdcsv_   csvfolder;csv;rows  NB. csvfolder files <- csvfile
jdfromcsv_jdcsv_ jdfolder;csvfolder  NB. JD table <- csvfolder files

NB. mark ptable as ptable  
if. PTM e.table do.
 t=. jdgl (table i.PTM){.table
 if. -.S_ptable__t do.
  S_ptable__t=: 1
  writestate__t''
 end. 
end. 

JDOK
)

jd_csvprobe=: 3 : 0
a=. ca'/replace 0'getopts y
csvset ;1 getnext a
jd_csvcdefs (option_replace#'/replace '),'/h 0 /u ',csvy
jd_droptable'csvprobe'
jd_csvrd'/rows 12 ',csvy,' csvprobe'
r=. jdi_reads'from csvprobe'
jd_droptable'csvprobe'
ferase csvfpcdefs
r
)

NB. restore db from dump folder
jd_csvrestore=: 3 : 0
y=. ca'/replace 0' getopts y
csvset''
csv=. (<CSVFOLDER__),each /:~{."1 [ 1!:0 jpath CSVFOLDER__,'*.csv'
cdefs=. (_4}.each csv),each <'.cdefs'
echo^:(0<#) >(#~ -.@fexist"0) cdefs
assert fexist"0 cdefs
if. option_replace do. jd_createdb''[jd_dropdb'' end.
assert 0=#{."1 jdtables''['db already has tables'
copyscripts (jdpath_jd_'');CSVFOLDER__
i=. >:(;{.csv)i:'/'
tabs=. >_4}.each i}.each csv
for_t. tabs do.
 t=. dltb,;t
 csvset t,'.csv' NB. get all csvset stuff - csvfpcdefs
 csvrd (CSVFOLDER__,t,'.csv');t;0;0
end.

refs=. (toJ ::]) fread CSVFOLDER__,'jdcsvrefs.txt'
if. (_1-.@-:refs)*.0~:#refs do.
 rs=. a:-.~dltb each<;._2 refs
 for_r. rs do.
  try.
   jd_ref_jd_ ;r
  catch.
   echo DB_jd_,' ',CSVFOLDER__,' csvrestore jd ref failed: ',;r
  end.
 end. 
end. 
i.0 0
)

csummary=: 4 : 0
;((<x)=(#x){.each y)#y
)

jd_csvreport=: 3 : 0
a=. ca'/f 0 /errors 0' getopts y
all=. {."1 jdtables''
if. 0=#a do.
 a=. all
else.
 b=.  getparttables_jd_ each a
 a=. ;b
 'table not found'assert 0~:;#each b
end.
a=. ~.a

r=. ''
if. option_errors do.
 r=. ,:;:'table col error # row position text' 
 for_i. i.#a do.
  tab=. ;i{a
  d=. fread PATH__dbl,tab,'/jdcsv/csverror.dat'
  if. _1=d do. continue. end.
   d=. 3!:2 d
   if. 1=#d do. continue. end.
   d=. }.(,.'table';tab),.d
   r=. r,d
  end.
 r
 return.
end. 

for_i. i.#a do.
 tab=. ;i{a
 b=. fread PATH__dbl,tab,'/jdcsv/csvlog.txt'
 if. _1=b do. continue. end.
 t=. <;.2 b
 if. -.option_f do.
  b=. ''
  b=. b,'src: '   csummary t 
  b=. b,'start: ' csummary t 
  b=. b,'elapse: 'csummary t 
  b=. b,'rows: '  csummary t 
  b=. b,'error: ' csummary t
 end.
 r=. r,'table: ',tab,LF,b,LF
end.
,.'Jd report csv';r
)
