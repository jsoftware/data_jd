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
all=. getallvisible__t''
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
csvset''
a=. ca y
d=. getdb''
header=. 0
w=. ''
while. '/'={.option=. >{.a do.
 select. option
 case. '/h1' do.
  header=. 1
 case. '/w' do.
  w=. >{:a
  a=. }:a
 case. do.
  assert 0['bad option'
 end. 
 a=. }.a
end. 
csv=. CSVFOLDER__,>0{a
table=. >1{a
cols=. 2}.a
assert '.csv'-:_4{.csv['sink file must be .csv'
cdefs=. (_3}.csv),'cdefs'
p=. (csv i:'/'){.csv
jdcreatefolder p
assert 0=''fwrite csv['unable to create csv file'
assert 0=''fwrite cdefs['unable to create cdefs file'
t=. getloc__d table
all=. getallvisible__t''
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
c fwrite cdefs
if. #w do.
 try.
  rows=. ,>{:jd_reads'jdindex from ',table,' where ',w
 catch.
  assert 0['where clause failed'
 end. 
else.
  active=. getloc__t 'jdactive'
  rows=. I.dat__active 
end.
WriteCsv__t csv;header;cols;rows
i.0 0
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
csvset''
assert 0=#dir CSVFOLDER__['CSVFOLDER must be empty'
tabs=. {."1 jdtables''
for_t. tabs do.
 jd_csvwr 'T.csv T'rplc 'T';>t
end.
copyscripts CSVFOLDER__;jdpath_jd_''
i.0 0
)

NB. [options] csvfile table 
jd_csvrd=: 3 : 0
csvset''
a=. ca y
d=. getdb''
rows=. 10    NB. default rows to read is 10
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
csv=.   CSVFOLDER__,>0{a
table=. >1{a
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
csvreportclear_jdcsv_''                        NB. clear log file of old reports
jdfolder=.  (PATH__d),table
csvfolder=. jdfolder,'/jdcsv'           NB. folder for csv intermeidate files and reports
jd_close''                               NB. clean up jd stuff
csvload_jdcsv_   csvfolder;csv;rows         NB. csvfolder files <- csvfile
jdfromcsv_jdcsv_ jdfolder;csvfolder  NB. JD table <- csvfolder files
jd_close'' NB. unmap to allow better host management of ram
i.0 0
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
if. replace    do. ferase cdefs else. assert -.fexist cdefs['cdefs file already exists (option /replace)' end.

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
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),LF
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
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),LF
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
csv=. (<CSVFOLDER__),each {."1 [ 1!:0 jpath CSVFOLDER__,'*.csv'
cdefs=. (_4}.each csv),each <'.cdefs'
assert fexist cdefs
assert 0=#{."1 jdtables''['db already has tables'
copyscripts (jdpath_jd_'');CSVFOLDER__
i=. >:(;{.csv)i:'/'
tabs=. >_4}.each i}.each csv
for_t. tabs do.
 jd_csvrd '/rows 0 T.csv T'rplc 'T';dtb t
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
if. 0=#a do. a=. all end.
assert 0=#a-.all['table{s} not found'
r=. ''
for_i. i.#a do.
 tab=. ;i{a
 b=. fread PATH__d,tab,'/jdcsv/csvlog.txt'
 b=. >(b-:_1){b;''
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