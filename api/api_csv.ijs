NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. routines for csv/bup rd/wr operations

coclass'jd'

csvset=: 3 : 0
if. IFJHS do.
 NB. assert -.(<'jjd')e. conl 0['job must run in task that is not a server'
 'job must run in task that is not a server' assert ''-:OKURL_jhs
end.
assert 0=nc<'CSVFOLDER__'['CSVFOLDER must be defined as path to csv files'
CSVFOLDER__=: CSVFOLDER__,>('/'={:CSVFOLDER__){'/';''
jdcreatefolder CSVFOLDER__
)

NB. cc cols;table;header
createcdefs=: 3 : 0
'cols table header'=. y
d=. getdb''
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
c=. c,'options TAB LF NO \ ',(":header),LF
)

jd_csvwr=: 3 : 0
a=. '/combine 0 /e 0 /h1 0 /w 0' getoptions ca y
header=. option_h1
epoch=. option_e
if. option_w do.
 w=. >{:a
 a=. }:a
else.
 w=. ''
end.
table=. >1{a
cols=. 2}.a
d=. getdb''
n=. ;1{a

ns=. getparttables n
csvs=. <_4}.>{.a
csvs=. csvs,each (#n)}.each ns
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
csvset''
d=. getdb''
csv=. CSVFOLDER__,>0{a
table=. >1{a
assert '.csv'-:_4{.csv['sink file must be .csv'
cdefs=. (_3}.csv),'cdefs'
p=. (csv i:'/'){.csv
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
'create cdefs file failed' assert (#c)=c fwrite cdefs

if. -.option_combine do. ''fwrite csv end.

if. #w do.
 try.
  rows=. ,>{:jd_reads'jdindex from ',table,' where ',w
 catchd.
  assert 0['where clause failed'
 end. 
else.
  active=. getloc__t'jdactive'
  rows=. I.dat__active 
end.
WriteCsv__t csv;option_h1;cols;rows;option_e;new
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
y=. '/e 0' getoptions bdnames y
e=. ;option_e_jd_{'';'/e '
csvset''
assert 0=#dir CSVFOLDER__['CSVFOLDER must be empty'
tabs=. {."1 jdtables''
for_t. tabs do.
 NB. jd_csvwr e,'T.csv T'rplc 'T';>t
 t=. ;t
 option_h1=: option_combine=: 0
 ('';'';1) csvwr (t,'.csv');t 
end.
copyscripts CSVFOLDER__;jdpath_jd_''
i.0 0
)

NB. [options] csvfile table 
jd_csvrd=: 3 : 0
csvset''
a=. ca y
d=. getdb''
rows=. 0    NB. default rows to read is all
flagcdefs=. 0 NB. cdefs from CSVFOLDER
while. '/'={.option=. >{.a do.
 select. option
 case. '/rows' do.
  rows=. _1".>1{a
  a=. }.a
 case. '/cdefs' do.
  'CDEFSFILE not defined' assert 0=nc<'CDEFSFILE__'
  'CDEFSFILE does not exist' assert fexist CDEFSFILE__
  flagcdefs=. 1 NB. cdefs from CDEFSFILE
 case. do.
  assert 0['bad option'
 end. 
 a=. }.a
end.

'csv table'=. a
csv=. CSVFOLDER__,csv
'csv file does not exist'assert fexist csv
fs=. {."1[1!:0 jpath (_4}.csv),PTM,'*.csv'

if. #fs do.
 fs=. (<csv),fs,~each<CSVFOLDER__
 '/cdefs not supported'assert -.flagcdefs
 'one of more missing cdefs' assert fexist"0 (_4}.each fs),each<'.cdefs'

 ts=. _4}.each fs
 ts=. (#;{.ts)}.each ts
 ts=. ts,~each<table

 for_i. i.#fs do.
  csvrd (i{fs),(i{ts),rows;0
 end.
else.
 csvrd csv;table;rows;flagcdefs
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
assert fexist cdefs['missing cdef file'
assert -.(<table)e.{."1 jdtables''['table already exists'
if. flagcdefs do.
 cdefs=. fread CDEFSFILE
else.
 cdefs=. fread (_3}.csv),'cdefs'
end. 
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

NB. [options] csvfile
jd_csvcdefs=: 3 : 0
csvset''
a=. ca y
replace=. 0
headers=. _1
unk=. 0
varb=. 200 NB. line between byte N and varbyte
optc=. 'header'
while. '/'={.option=. >{.a do.
 select. option
 case. '/replace' do.
  replace=. 1
 case. '/h' do.
  headers=. _1".>1{a
  assert (headers>:0)*.headers<:10 ['/h invalid'
  a=. }.a
 case. '/c' do.
  optc=. 'file'
 case. '/v' do.
  varb=. _1".>1{a
  assert varb>:4['/v invalid'
  a=. }.a
 case. '/u' do.
  unk=. _1".>1{a
  assert (unk>0)*.headers<:1000 ['/u invalid'
  optc=. 'file'
  a=. }.a
 case. do.
  assert 0['bad option'
 end. 
 a=. }.a
end.

csvfile=. >{.a
csv=.   CSVFOLDER__,csvfile
t=. _3}.csv
cdefs=. t,'cdefs'
cnames=. t,'cnames'

if. unk>0 do.(;LF,~each'c',each ":each<"0 >:i.unk)fwrite cnames end.
if. optc-:'header' do.
 assert headers>:1               ['/h must be at least 1 with colnames from header'
else. 
 assert fexist cnames            ['/c .cnames file must exist'
end.

assert fexist csv                      ['csv file must exist'
if. replace    do. ferase cdefs else. assert (0=ftypex) cdefs['cdefs file already exists (option /replace)' end.

NB. determine csv options rowsep colsep quoted escaped headers 
d=. fread csv;0,100000<.fsize csv
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
if.     +./('"',rs) E. d do. quoted=. '"'
elseif. +./(rs,'"') E. d do. quoted=. '"'
elseif. 1                do. quoted=. 'NO'
end.
escaped=. '\' NB. assume escaped
if. optc-:'header' do.
 cnb=. <;._2 n,cs
else.
 t=. fread cnames
 cnb=. <;._2 toJ t,>(LF={:t){LF;''
end.
cols=. #cnb
cn=. >cnb

assert _2~:nc cnb    ['invalid colname'
duplicate_assert cnb
nums=.  >(( #":cols)":each<"0 >:i.cols)rplc each <' ';'0'

c=. ,LF,.~nums,.' ',.cn,"1 ' byte ',":>:varb
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),' iso8601-char ',LF
jd'droptable csvprobe'
c fwrite cdefs
jd_csvrd '/rows 5000 CSVFILE csvprobe'rplc 'CSVFILE';csvfile
ferase cdefs
d=. jd'reads from csvprobe'
jd'droptable csvprobe'
s=. ({.d)i.cnb
d=. dtbm each{:d
c=. nums,.' ',.cn,.' ',.>s{varb gettype each d

NB. /u can have trailing cols (byte 0) that probably don't exist - remove them
if. unk>0 do.
 a=. ;{:each$each s{d
 a=. >:(a~:0)i: 1 NB. rows to keep (trailing byte 0 rows dropped
 c=. a{.c
 (;LF,~each'c',each ":each<"0 >:i.a)fwrite cnames NB. remove from cnames as well
end.

NB. cols with no data in probe are byte 0 - change them to byte 1
a=. deb each<"1 c
a=. 0= ;_1".each(>:;a i:each' ')}.each a
a=. a#i.#c
c=. '1' (<a;_1)}c NB. byte 0 changed to byte 1

c=. ,LF,.~c
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),' iso8601-char',LF
c fwrite cdefs
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
csvset''
csv=. (<CSVFOLDER__),each /:~{."1 [ 1!:0 jpath CSVFOLDER__,'*.csv'
cdefs=. (_4}.each csv),each <'.cdefs'
assert fexist"0 cdefs
assert 0=#{."1 jdtables''['db already has tables'
copyscripts (jdpath_jd_'');CSVFOLDER__
i=. >:(;{.csv)i:'/'
tabs=. >_4}.each i}.each csv
for_t. tabs do.
 t=. dltb,;t
 csvrd (CSVFOLDER__,t,'.csv');t;0;0
end.
i.0 0
)

csummary=: 4 : 0
;((<x)=(#x){.each y)#y
)

jd_csvreport=: 3 : 0
d=. getdb''
a=. ca y
optf=. 1
while. '/'={.option=. >{.a do.
 select. option
 case. '/f' do.
  optf=. 0
 case. do.
  assert 0['bad option'
 end. 
 a=. }.a
end.
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
 if. optf do.
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
