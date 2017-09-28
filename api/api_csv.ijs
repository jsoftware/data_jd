NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
NB. routines for csv/bup rd/wr operations

coclass'jd'

BOMUTF8=: 239 187 191{a.

NB. '' or filename
csvset=: 3 : 0
if. IFJHS do.
 NB. assert -.(<'jjd')e. conl 0['job must run in task that is not a server'
 'job must run in task that is not a server' assert ''-:OKURL_jhs
end.
assert 0=nc<'CSVFOLDER__'['CSVFOLDER must be defined as path to csv files'
CSVFOLDER__=: CSVFOLDER__,>('/'={:CSVFOLDER__){'/';''
jdcreatefolder CSVFOLDER__
if. ''-:y do. return. end.
('csv file must be .csv: ',y)assert '.csv'-:_4{.y
root=: (y i:'.'){.y
csvf=: y
csvfp=: CSVFOLDER__,y
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

jd_csvwr=: 3 : 0
a=. '/combine 0 /e 0 /h1 0 /w 0' getoptions y
header=. option_h1
epoch=. option_e
if. option_w do.
 w=. >{:a
 a=. }:a
else.
 w=. ''
end.
d=. getdb''
csvset ;0{a
'table does not exist'assert NAMES__d e.~1{a
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
  'create csv file failed' assert 0=''fwrite {.csvs
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
d=. getdb''
csvset ;0{a
table=. >1{a
p=. (csvfp i:'/'){.csvfp
jdcreatefolder p
t=. getloc__d table
all=. getdefaultselection__t''
if. 0=#cols do.
 cols=. all
else.
 assert 0=#cols-.all['invalid cols'
end.
coln =. getloc__t@> cols
typ =. 3 :'<typ__y'"0 coln
shape =. 3 :'<shape__y'"0 coln
b=. cols,.typ,.shape
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
c=. c,'options TAB LF NO \ ',(":option_h1),(;option_e{' iso8601-char ';' iso8601-int '),LF
'create cdefs file failed' assert (#c)=c fwrite csvfpcdefs

if. -.option_combine do. ''fwrite csvfp end.

if. #w do.
 try.
  rows=. ,>{:jd_reads'jdindex from ',table,' where ',w
 catchd.
  assert 0['where clause failed'
 end. 
else.
  rows=. i.Tlen__t
end.
WriteCsv__t csvfp;option_h1;cols;rows;option_e;new
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
y=. '/e 0 /replace 0' getoptions y
e=. ;option_e{'';'/e '
csvset''
if. option_replace do. jddeletefolder CSVFOLDER__ end.
assert 0=#dir CSVFOLDER__['CSVFOLDER must be empty'
tabs=. {."1 jdtables''
for_t. tabs do.
 NB. jd_csvwr e,'T.csv T'rplc 'T';>t
 t=. ;t
 option_h1=: option_combine=: 0
 ('';'';1) csvwr (t,'.csv');t 
end.
NB. create jdcsvrefs.txt file (used by csvresore to create ref cols)
'a b'=. {:jd_info'ref'
((,LF,.~a,.5}."1 b)rplc"1 '_';' ')fwrite CSVFOLDER__,'jdcsvrefs.txt'
copyscripts CSVFOLDER__;jdpath_jd_''
i.0 0
)

NB. [options] csvfile table 
jd_csvrd=: 3 : 0
csvset''
a=. '/rows 1 /cdefs 0'getoptions y
rows=. option_rows_jd_ NB. scalar required!
if. option_cdefs_jd_ do.
  'CDEFSFILE not defined' assert 0=nc<'CDEFSFILE__'
  'CDEFSFILE does not exist' assert fexist CDEFSFILE__
end.
'csv table'=. 2 getnext a
csv=. CSVFOLDER__,csv
('csv file does not exist: ',csv)assert fexist csv
vtname table

fs=. {."1[1!:0 jpath (_4}.csv),PTM,'*.csv'
if. #fs do.
 fs=. (<csv),fs,~each<CSVFOLDER__
 '/cdefs not supported'assert -.option_cdefs_jd_
 'one or more missing cdefs' assert fexist"0 (_4}.each fs),each<'.cdefs'

 ts=. _4}.each fs
 ts=. (#;{.ts)}.each ts
 ts=. ts,~each<table

 for_i. i.#fs do.
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
d=. getdb''
csv=.   csv
cdefs=. (_3}.csv),'cdefs'
assert fexist csv
assert -.(<table)e.{."1 jdtables''['table already exists'
if. flagcdefs do.
 cdefs=. fread CDEFSFILE__
else.
 cdefs=. fread (_3}.csv),'cdefs'
end. 
'cdefs file not found'assert _1~:cdefs
csvdefs_jdcsv_ cdefs
csvreportclear_jdcsv_''              NB. clear log file of old reports
path=. PATH__d
jdfolder=.  path,table
csvfolder=. jdfolder,'/jdcsv'        NB. folder for csv intermediate files and reports
jd_close''                           NB. clean up jd stuff
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

jd_close''                           NB. unmap to allow better host management of ram
JDOK
)

jd_csvprobe=: 3 : 0
a=. '/replace 0'getoptions y
csvset ;1 getnext a
jd_csvcdefs (option_replace#'/replace '),'/h 0 /u ',csvf
jd_droptable'csvprobe'
jd_csvrd'/rows 12 ',csvf,' csvprobe'
r=. jd_reads'from csvprobe'
jd_droptable'csvprobe'
r
)

NB. [options] csvfile
jd_csvcdefs=: 3 : 0
a=. '/replace 0 /c 0 /h 1 /u 0 /v 1'getoptions y
csvset ;1 getnext a
headers=. option_h
'/h invalid'assert headers<11
'/c and /u not allowed together'assert 2>option_c+option_u
varb=. (0=option_v){option_v,200
optc=. ;(option_c+option_u){'header';'file'

assert fexist csvfp                      ['csv file must exist'
if. option_replace do. ferase csvfpcdefs else. assert (0=ftypex) csvfpcdefs['cdefs file already exists (option /replace)' end.

NB. determine csv options rowsep colsep quoted escaped headers 
d=. fread csvfp;0,100000<.fsize csvfp
if. BOMUTF8=3{.d do. d=. 3}.d end.
if.     +./CRLF E. d do. rowsep=. 'CRLF' [ rs=. CRLF
elseif. LF     e. d  do. rowsep=. 'LF'   [ rs=. LF
elseif. CR     e. d  do. rowsep=. 'CR'   [ rs=. CR 
elseif. 1            do. assert 0['unable to determine rowsep'
end.

n=. (d i. {.rs){.d NB. first row
if.     TAB e. n do. colsep=. 'TAB'    [ cs=. TAB
elseif. ',' e. n do. colsep=. ','      [ cs=. ','
elseif. ';' e. n do. colsep=. ';'      [ cs=. ';'
elseif. '|' e. n do. colsep=. '|'      [ cs=. '|'
elseif. ' ' e. n do. colsep=. 'BLANK ' [ cs=. ' '
elseif. 1        do. assert 0['unable to determine colsep'
end.

quoted=. '"'
escaped=. 'NO'

if. option_u do. NB. calc cols based on data
 t=. >:>./;+/each cs=each<;.2 d,rs
 (;LF,~each'c',each ":each<"0 >:i.t)fwrite csvfpcnames
end.

if. optc-:'header' do.
 assert headers>:1               ['/h must be at least 1 with colnames from header'
else. 
 assert fexist csvfpcnames            ['/c .cnames file must exist'
end.

if. optc-:'header' do.
 cnb=. <;._2 n,cs
else.
 t=. fread csvfpcnames
 cnb=. <;._2 toJ t,>(LF={:t){LF;''
end.
cols=. #cnb
cnb=. cnb rplc each <' ';'_'
cn=. >cnb
duplicate_assert cnb
nums=.  >(( #":cols)":each<"0 >:i.cols)rplc each <' ';'0'

c=. ,LF,.~nums,.' ',.cn,"1 ' byte ',":>:varb
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),' iso8601-char ',LF
jd'droptable csvprobe'
c fwrite csvfpcdefs
jd_csvrd '/rows 5000 CSVF csvprobe'rplc 'CSVF';csvf
ferase csvfpcdefs
d=. jd'reads from csvprobe'
jd'droptable csvprobe'
s=. ({.d)i.cnb
d=. dtbm each{:d
c=. nums,.' ',.cn,.' ',.>s{varb gettype each d
c=. ,LF,.~c
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),' iso8601-char',LF
c fwrite csvfpcdefs
JDOK
)

dtcheck=: 4 : 0
if. +./Num_j_ e. ,x{"1 y do.
 0
else. 
 *./(,(x-.~i.{:$y){"1 y) e. Num_j_
end.
)

NB. return jd type of char matrix
gettype=: 4 : 0
varb=. x

NB. test for is08601
try.
 v=. efs y
 if. *./0=(86400*1e9)|v do.'edate'       return. end.
 if. *./0=1e9|v         do. 'edatetime'  return. end.
 if. *./0=1e6|v         do. 'edatetimem' return. end.
 'edatetimen' return.
catch.
end.

if. 19={:$y do.
 if. 4 7 10 13 16 dtcheck y do. 'datetime'  return. end.
 if. 2 5 10 13 16  dtcheck y do. 'datetimex' return. end.
end.

if. 10={:$y do.
 if. 4 7 dtcheck y do. 'date'  return. end.
 if. 2 5 dtcheck y do. 'datex' return. end.
end.

n=. _".y
t=. (_ e. ,n)+.-.(,{.$y)-:$n NB. 1 if not numeric

if. t do.
 s=. {:$y
 if.      1=s do.  'byte' return.
 elseif.  varb<s do. 'varbyte' return.
 elseif. 1     do. 'byte      ',":s return.
 end.
else.
 t=. 3!:0 n
 jt=. >(1 4 8 i. 3!:0 n){'boolean';'int';'float'
 return.
end.
)

dtbm=: 3 : '>dtb each<"1 y'

NB. restore db from dump folder
jd_csvrestore=: 3 : 0
y=. '/replace 0' getoptions y
csvset''
csv=. (<CSVFOLDER__),each /:~{."1 [ 1!:0 jpath CSVFOLDER__,'*.csv'
cdefs=. (_4}.each csv),each <'.cdefs'
assert fexist"0 cdefs
if. option_replace do. jd_createdb''[jd_dropdb'' end.
assert 0=#{."1 jdtables''['db already has tables'
copyscripts (jdpath_jd_'');CSVFOLDER__
i=. >:(;{.csv)i:'/'
tabs=. >_4}.each i}.each csv
for_t. tabs do.
 t=. dltb,;t
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
d=. getdb''
a=. '/f 0' getoptions y
all=. {."1 jdtables''
if. 0=#a do.
 a=. all
else.
 a=.  ;getparttables_jd_ each a
end. 
assert 0=#a-.all['table{s} not found'
r=. ''
for_i. i.#a do.
 tab=. ;i{a
 b=. fread PATH__d,tab,'/jdcsv/csvlog.txt'
 if. _1=b do. continue. end.
 t=. <;.2 b
 if. option_f do.
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
