NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

pathin=:    jpath'~temp/jd/csv/files'
CSVFOLDER=: '~temp/jd/csv/test/'
erase'csv__' NB. ensure we don't use someone elses
csv_z_=:    <'jdcsv' NB. mappednoun__csv

jddeletefolder_jd_ CSVFOLDER

deleteall=: 3 : 0
free_jdcsv_''
jddeletefolder_jd_ pathin
jdcreatefolder_jd_ pathin
)

vic=: 3 : 0
({."1 y)-:+/\0,}:{:"1 y 
)

NB. test jd'csv...' - wr rd - trailing shape - etc
csvop_tests=: 3 : 0
jdadminx'test'
s=: (,2);2 1;2 2

NB. test byte trailing shapes
jd'createtable bytes b byte, b1 byte 1, b2 byte 2'
jd'insert bytes';'b';'ab';'b1';(2 1$'ab');'b2';2 2$'abcd'
jd'read from bytes'
assert s=$each {:"1 jd'read from bytes'

jd'csvwr bytes.csv bytes'
jd'csvrd bytes.csv nbytes'
assert (jd'read from bytes')-:jd'read from nbytes'

NB. date datetime - written as undecorated ints
jd'createtable ddt d date,dt datetime'
jd'insert ddt';'d';19991010;'dt';20121010121212
jd'reads from ddt'
jd'csvwr ddt.csv ddt'
jd'csvrd ddt.csv nddt'
assert (jd'read from ddt')-:jd'read from nddt'
)

NB. x 1 to avoid jd create from csv files
NB. y test number - selects csvy cdefy validy 
test=: 3 : 0
0 test y
:
EC__=: ECTOOMUCHMSG_jdcsv_
ECTOOMUCHMSG_jdcsv_=: ''
jdadminx'tdb'
jd'close'
unmapall_jmf_''
n=. ":y
if. y=29 do. x test29'' return. end.
if. y=31 do. x test31'' return. end.
jdcreatefolder_jd_ pathin
csvfile=: jpath pathin,'/test',n,'.csv'
(".'csv',n) fwrite csvfile
jdfolder=: '~temp/jd/tdb/j',n
csvfolder=: jpath jdfolder,'/jdcsv'
csvdefs_jdcsv_ ".'cdef',n
R=: csvload_jdcsv_ csvfolder;csvfile;0
try. ".'valid',n,' 0'
catch.
 echo csverror
 echo 'valid',n,' failed'
 echo csvfolder
 echo jdfolder
end.
if. x do. R return. end.
jdfromcsv_jdcsv_ jdfolder;csvfolder
r=. jd'read from j',n
if. 3=nc<'validjd',n do. ".'validjd',n,' 0' end.
jddeletefolder_jd_ CSVFOLDER
jd'csvwr jN.csv jN'    rplc 'N';n
jd'csvrd /rows 0 jN.csv newjN'  rplc 'N';n
nr=. jd'read from newj',n
assert r-:nr 
jd'close'
ECTOOMUCHMSG_jdcsv_=: EC__ NB. restore
r
)

NB. note float leading $ and leading .
csv0=: 0 : 0
23,chevrolet,red,.1,23,1024,1234,2001-03-07 10:58:12
24,toyota,blue,$22.22,24,1025,12345,2001-03-07 10:58:13
25,rambler,pink,33.33,25,1026,123456,2001-03-07 10:58:14
)

cdef0=: 0 : 0
1  vin      int
2  make     varbyte 20
3  color    byte    5
4  double   float
5  i1       CI1
8  datetime datetime
options , LF NO NO 0
)

valid0=: 3 : 0
assert 0=csverrorcount
assert 0=+/{."1 csverrors__csv
assert c_vin__csv-:23 24 25
assert vic c_make__csv
assert v_make__csv-:'chevrolettoyotarambler'
assert c_color__csv-: ($c_color__csv)$'red  blue pink '
assert c_double__csv-:0.1 22.22 33.33
assert c_i1__csv-:3 1$23 24 25{a.
assert c_datetime__csv-:20010307105812 20010307105813 20010307105814
)

csv1=: 0 : 0
1,2,3
4,5,6
7,8,9
)

NB. MANGLEDNAMES
cdef1=: 0 : 0
1 d0_() int
2 d1 int
3 d2 int
options  , LF NO NO 0
)

valid1=: 3 : 0
assert 0=csverrorcount
assert (c_a0__csv,.c_a1__csv,.c_a2__csv)-:>:i.3 3
)

csv2=: 0 : 0
1,2,3,16,17
4,5,6,18,19
7,8,9,20,21
10,11,12,22,23
13,14,15,24,25
)

cdef2=: 0 : 0
1 d1 int
2 d1 CSTITCH
3 d1 CSTITCH
4 d2 int
5 d2 CSTITCH
options  , LF NO NO 0
)

valid2=: 3 : 0
assert 0=csverrorcount
assert c_d1__csv-:1+i.5 3
assert c_d2__csv-:16+i.5 2
)

validjd2=: 3 : 0
1
)

csv3=: 0 : 0
pvid0 1 -1.1 2.2 3.3
pvid1 0 4.4 5.5 6.6
)

cdef3=: 0 : 0
1 pvid byte 7
2 pstate boolean
3 pv   float
4 pv   CSTITCH
5 pv   CSTITCH
options  BLANK LF NO NO 0
)

valid3=: 3 : 0
assert 0=csverrorcount
assert c_pvid__csv-:2 7$'pvid0  pvid1  '
assert c_pstate__csv-:1 0
assert c_pv__csv-:2 3$ _1.1 2.2 3.3 4.4 5.5 6.6
assert (#c_pvid__csv)=#c_pv__csv
)

csv4=: 0 : 0
1,abc,aaa
5,defghi,bbbb
9,jklmnopq,ccccc
)

NB. MANGLEDNAMES varbyte
cdef4=: 0 : 0
1 a int
2 b_() varbyte 2
3 c varbyte 3
options  , LF NO NO 0
)

valid4=: 3 : 0
assert c_a0__csv-:1 5 9
assert vic c_a1__csv
assert v_a1__csv-:'abcdefghijklmnopq'
assert v_a2__csv-:'aaabbbbccccc'
assert vic c_a2__csv
)

csv5=: csv0 rplc LF;CRLF

cdef5=: 0 : 0
1  vin      int
2  make     varbyte 20
3  color    byte    5
4  double   float
5  i1       CI1
8  datetime datetime
options  , CRLF NO NO 0
)

valid5=: 3 : 0
valid0''
)

csv6=: 0 : 0
"123","ab,cd,\"gh"",ij","ab,cd,\"gh"",ij"
124,"ab,cd,\"gh"",ij","ab,cd,\"gh"",ij"
)

cdef6=: 0 : 0
1 a int
2 b byte 16
3 c byte 16
options  , LF " \ 0
)

valid6=: 3 : 0
assert 0=csverrorcount
assert c_a__csv-:123 124
assert c_b__csv-:2 16$'ab,cd,"gh",ij   '
assert c_c__csv-:2 16$'ab,cd,"gh",ij   '  
)

NB. empty and missing fields
csv7=: 0 : 0
1,2,3
4
7,8,9
,11
13,14,15

19,20,21
)

cdef7=: 0 : 0
1 a int
2 a CSTITCH
3 a CSTITCH
options  , LF NO NO 0
)

valid7=: 3 : 0
assert 0~:csverrorcount
d=. 1 2 3 4 0 0 7 8 9 0 11 0 13 14 15 0 0 0 19 20 21
d=. IMIN_jd_ ((d=0)#i.#d)}d
assert c_a__csv-:7 3$d
)

NB. test CDOUBLE (used to test fast CDOUBLEX)
csv8=: 0 : 0
123.123,123.123
123456789.123456789,123456789.123456789
1234567891.123456789,1234567891.123456789
123456789.1234567891,123456789.1234567891
)

cdef8=: 0 : 0
1 d0 float
2 d1 float
options  , LF NO NO 0
)

valid8=: 3 : 0
assert c_d0__csv-:123.123 123456789.12345679 1234567891.1234567 123456789.12345679
assert c_d0__csv-:c_d1__csv
)

csv9=: 0 : 0
2011-03-24 12:13:14,03-24-2011 12:13:14,2011-03-24,03-24-2011
2011-3-24 12:13:14,3-24-2011 12:13:14,2011-3-24,3-24-2011
20110324 121314,03242011 121314,20110324,03242011
)

cdef9=: 0 : 0
1 dta datetime
2 dtb datetimex
3 da  date
4 db  datex
options  , LF NO NO 0
)

valid9=: 3 : 0
assert 0=csverrorcount
assert c_dta__csv-:3#20110324121314
assert c_dtb__csv-:3#20110324121314
assert c_da__csv-: 3#20110324
assert c_db__csv-: 3#20110324
)

NB. missing empty and all blank
csv10=: 0 : 0
,,,,

   ,   ,   ,    ,          
)

cdef10=: 0 : 0
1 a byte 5
2 b int
3 c float
4 d float
5 e date
options  , LF NO NO 0
)

valid10=: 3 : 0
assert c_a__csv-:3 5$' '
assert c_b__csv=IMIN_jd_
assert c_c__csv=__
assert c_d__csv=__
assert c_e__csv=IMIN_jd_
)

NB. CI8X shift decimal
csv11=: 0 : 0
120
121.
122.1
123.12
124.123
125.1234
)

cdef11=: 0 : 0
1 a CI8X 2
options  , LF NO NO 0
)

valid11=: 3 : 0
assert c_a__csv-:12000 12100 12210 12312 12412 12512
)

csv12=: LF,~1e6$'a' NB. jorge bug increased data buffer size

cdef12=: 0 : 0
1 a int
options  , LF NO NO 0
)

valid12=: 3 : 0
assert 1=csverrorcount
assert 1 0 0 -:(ECTOOMUCH__csv){0{csverrors__csv
)

NB. errors - note number followed by blanks is bad
NB. leading non +-digits are skipped
csv13=: 0 : 0
$123,Pounds 1.1, magical1.2
123a,1.1a,1.1a
123 ,1.1 ,1.1a
)

cdef13=: 0 : 0
1 a int
2 b float
3 c float
options  , LF NO NO 0
)

valid13=: 3 : 0
assert 0=csverrorcount
assert c_a__csv-:123 123 123
assert c_b__csv-:1.1 1.1 1.1
assert c_c__csv-:1.2 1.1 1.1
)

csv14=: 0 : 0
ab
abc
abcd
)

cdef14=: 0 : 0
1 a byte 3
options  , LF NO NO 0
)

valid14=: 3 : 0
assert 1=csverrorcount
assert 1={.ECTRUNCATE__csv{0{csverrors__csv
assert c_a__csv-:3 3$'ab abcabc'
)

csv15=: '123',CR NB. CRLF missing Lf at end

cdef15=: 0 : 0
1 a int
options  , CRLF NO NO 0
)

valid15=: 3 : 0
assert 1 0 4-:,(ECCRLF__csv){0{csverrors__csv
assert 1=csverrorcount
assert c_a__csv-:,123
)

csv16=: '123'

cdef16=: 0 : 0
1 a int
options  , CRLF NO NO 0
)

valid16=: 3 : 0
assert 1=csverrorcount
assert 1={.ECTOOMUCH__csv{0{csverrors__csv
)

csv17=: 0 : 0
John,Doe,120 jefferson st.,Riverside,NJ, 08075
Jack,McGinnis,220 hobo Av.,Phila,PA,09119
"John ""Da Man""",Repici,120 Jefferson St.,Riverside,NJ,08075
Stephen,Tyler,"7452 Terrace ""At the Plaza"" road",SomeTown,SD, 91234
,Blankman,,SomeTown,SD, 00298
"Joan ""the bone"", Anne",Jet,"9th, at Terrace plc",Desert City,CO,00123
)

cdef17=: 0 : 0
1 first  byte 30
2 last   byte 30
3 street byte 40
4 town   byte 30
5 state  byte 30
6 zip    int
options  , LF " NO 0
)

valid17=: 3 : 0
assert 0=csverrorcount
assert (30{.'Joan "the bone", Anne')-:{:c_first__csv
assert (40{.'9th, at Terrace plc')-:{:c_street__csv
)

csv18=: 0 : 0
J1,Sorter,Paris,12,13
J2,Display,Rome,14,15
J3,OCR,Athens,16,17
J4,Console,Athens,1,2
J5,RAID,London,3,6
J6,EDS,Oslo,4,5
J7,Tape,London,7,7
J8,Staples,Toronto,8,9
J9,Cord,Kingston,10,100
j10,String,NYC,11,12
)

NB.! varbyte count of 2 gets an error and a crash - assume resize bug
cdef18=: 0 : 0
1 jid    varbyte 10
2 jname  varbyte 10
3 city   varbyte 10
4 num0   int
5 num1   int
options  , LF NO NO 0
)

valid18=: 3 : 0
assert 0=csverrorcount
assert vic c_jid__csv
assert v_jid__csv-:'J1J2J3J4J5J6J7J8J9j10'
assert vic c_jname__csv
assert v_jname__csv-:'SorterDisplayOCRConsoleRAIDEDSTapeStaplesCordString'
assert vic c_city__csv
assert v_city__csv-:'ParisRomeAthensAthensLondonOsloLondonTorontoKingstonNYC'
assert c_num0__csv-:12 14 16 1 3 4 7 8 10 11
assert c_num1__csv-:13 15 17 2 6 5 7 9 100 12
)

csv19=: csv18 rplc 'Tape';(0{a.),'Tape'       NB. var 0 byte
csv19=: csv19 rplc 'Toronto';(1{a.),'Toronto' NB. var 1 byte

NB. used to test CVARX (null terminated mess)
cdef19=: 0 : 0
1 jid    varbyte 10
2 jname  varbyte 10
3 city   varbyte 10
4 num0   int
5 num1   int
options  , LF NO NO 0
)

valid19=: 3 : 0
1
)

csv20=: 0 : 0
abc,wonder bread
def ghi jkl,mostly stuff
how now brown cow,short
funny farm,rude crud
random data strings,mumf
fubar,fubar2
)

cdef20=: 0 : 0
1 jvar1  varbyte 10
2 jvar2  varbyte 10
options  , LF NO NO 0
)

valid20=: 3 : 0
assert vic c_jvar1__csv
assert vic c_jvar2__csv
assert v_jvar1__csv-:'abcdef ghi jklhow now brown cowfunny farmrandom data stringsfubar'
assert v_jvar2__csv-:'wonder breadmostly stuffshortrude crudmumffubar2'
)

csv21=: 0 : 0
0,23,1.2,a,abc1234,abcdef,19680602,20001212667788,667788
1,24,2.3,b,def,how now brown cow,19680604,20011212667788,123456
1,25,3.4,c,ghi,fun,19680604,20021212667788,234567
)

cdef21=: 0 : 0
1 jboolean   boolean
2 jint       int
3 jfloat     float
4 jbyte      byte 1
5 jbyte7     byte 7
6 jvar       varbyte  10
7 jxdate     date
8 jxdatetime datetime
options  , LF NO NO 0
)

valid21=: 3 : 0
assert c_jint__csv-:23 24 25
assert c_jfloat__csv-:1.2 2.3 3.4
assert c_jbyte__csv-:,.'abc'
assert c_jbyte7__csv-:3 7$'abc1234def    ghi    '
assert vic c_jvar__csv
assert v_jvar__csv-:'abcdefhow now brown cowfun'
assert c_jxdate__csv-:19680602 19680604 19680604
)

csv22=: 'first header',LF,'second header',LF,'third header',LF,csv20

cdef22=: 0 : 0
1 jvar1  varbyte 10
2 jvar2  varbyte 10
options  , LF NO NO 3
)

valid22=: 3 : 0
assert vic c_jvar__csv
assert v_jvar1__csv-:'abcdef ghi jklhow now brown cowfunny farmrandom data stringsfubar'
assert v_jvar2__csv-:'wonder breadmostly stuffshortrude crudmumffubar2'
)

csv23=: 0 : 0
0,0,0
f,f,f
F,F,F
1,1,1
t,t,t
T,T,T
2,2,2
a,a,a
)

cdef23=: 0 : 0
1 jb1 boolean
2 jb2 boolean
3 jb3 boolean
options  , LF NO NO 0
)

valid23=: 3 : 0
assert c_jb1__csv-:0 0 0 1 1 1 0 0
assert c_jb2__csv-:0 0 0 1 1 1 0 0
assert c_jb3__csv-:0 0 0 1 1 1 0 0
)

csv24=: 0 : 0
red
pink
blue
red
green
yellow
red
blue
pink
blue
red
green
yellow
red
blue
pink
blue
red
green
yellow
red
blue
)

NB. should be testing enum, but turned off for now
cdef24=: 0 : 0
1 color byte 12
options  , LF NO NO 0
)

valid24=: 3 : 0
assert 22 12-:$c_color__csv
assert (12{.'blue')-:{:c_color__csv
)

csv25=: '123',CR,'123',CRLF

cdef25=: 0 : 0
1 a CI8
options  , CRLF NO NO 0
)

valid25=: 3 : 0
assert 1=csverrorcount
assert 1 0 4 -:ECCRLF__csv{0{csverrors__csv
assert c_a__csv-:,123
)

DimClientIP=: 0 : 0
-1
2556220,193.228.104.102,aut,4,lenzing,0,0,lenzing.com,lenzing ag,047.971,0013.627,9/16/2010 14:46:40,1
2556221,69.178.19.226,usa,ak,anchorage,907,99503,gci.net,general communication inc.,061.217,-149.868,9/16/2010 14:46:40,2
2556222,192.165.247.1,swe,m,malmo,0,0,tac.com,tac ab,055.597,0013.002,9/16/2010 14:46:40,3
2556223,60.50.123.78,mys,w,kuala lumpur,0,0,tm.net.my,telekom malaysia berhad,003.167,0101.700,9/16/2010 14:46:40,4
2556224,32.160.120.97,usa,ga,atlanta,404,30349,mycingular.net,att global network services llc,033.749,-084.388,9/16/2010 14:46:40,5
2556225,220.228.246.118,twn,tpe,taipei,0,0,038345039.com.tw,new centry infocom tech. co. ltd.,025.039,0121.509,9/16/2010 14:46:40,6
)

csv26=: toCRLF DimClientIP

cdef26=: 0 : 0
1  a int 
2  b byte 15
3  c byte 3
4  d byte 3
5  e byte 10
6  f byte 10
7  g byte 10
8  h byte 10
9  i varbyte 30
10 j byte 10
11 k byte 10
12 l datetimex
13 m int
options  , CRLF NO NO 1
)

valid26=: 3 : 0
assert c_a__csv-:2556220+i.6
assert c_m__csv-:>:i.6
)

csv27=: 0 : 0
23,chevrolet,red,1.1,23,1024,1234,2001-03-07 10:58:12
24,toyota,blue,22.22,24,1025,12345,2001-03-07 10:58:13
25,rambler,pink,33.33,25,1026,123456,2001-03-07 10:58:14
)

csv28=: 0 : 0
26,ford,green,1.1,23,1024,1234,2001-03-07 10:58:15
27,lexus,black,22.22,24,1025,12345,2001-03-07 10:58:16
28,honda,mauve,33.33,25,1026,123456,2001-03-07 10:58:17
)

NB. columns 4 5 6 and 7 are ignored
cdef27=: 0 : 0
1  vin      int
2  make     varbyte
3  color    byte    5
8  datetime datetime
options , LF NO NO 0
)

valid27=: 3 : 0
assert c_vin__csv-:23 24 25
assert v_make__csv-:'chevrolettoyotarambler'
assert c_color__csv-:3 5$'red  blue pink '
)

csv28=: 0 : 0
26,ford,green,1.1,23,1024,1234,2001-03-07 10:58:15
27,lexus,black,22.22,24,1025,12345,2001-03-07 10:58:16
28,honda,mauve,33.33,25,1026,123456,2001-03-07 10:58:17
)

NB. columns 4 5 6 and 7 are ignored
cdef28=: 0 : 0
1  vin      int
2  make     varbyte
3  color    byte    5
8  datetime datetime
options , LF NO NO 0
)

valid28=: 3 : 0
assert c_vin__csv-:26 27 28
assert v_make__csv-:'fordlexushonda'
assert c_color__csv-:3 5$'greenblackmauve'
)

NB. append
test29=: 3 : 0
0 test29 y
:
unmapall_jmf_''
jdfolder=: '~temp/jd/tdb/j29'          NB. JD table to create
csvfile27=: jpath pathin,'/test27.csv'
csvfile28=: jpath pathin,'/test28.csv'
csvfolder=: jpath'~temp/jd/csv/files/csv29'    NB. temp folder for csv loader
csvdefs_jdcsv_   cdef27                      NB. column definitions
R=: csvload_jdcsv_   csvfolder;csvfile27;0       NB. csvfolder files <- csvfile
R=: R,csvappend_jdcsv_ csvfolder;csvfile28;0
assert c_vin__csv-:23 24 25 26 27 28
assert v_make__csv-:'chevrolettoyotaramblerfordlexushonda'
assert c_color__csv-:6 5$'red  blue pink greenblackmauve'
assert c_datetime__csv-:20010307105812 20010307105813 20010307105814 20010307105815 20010307105816 20010307105817
if. x do. R return. end.
jdfromcsv_jdcsv_ jdfolder;csvfolder       NB. JD table        <- csvfolder files
r=. jd'reads from j29'
jd'close'
r
)

csv30rows=: 100

csv30bld=: 3 : 0
d=. ":,.10000+i.y
,d,.',',.d,.',',.d,.',',.d,.LF
)

csv30=: csv30bld csv30rows

NB. test callback for c and v
cdef30=: 0 : 0
1 i1 int
2 v1 varbyte 2
3 i2 int
4 v2 varbyte 2
options , LF NO NO 0
)

valid30=: 3 : 0
assert c_i1__csv-: 10000+i.csv30rows
assert c_i2__csv-: c_i1__csv
assert v_v1__csv-:,":,.10000+i.csv30rows
assert v_v2__csv-:v_v1__csv
)

NB. append growth
test31=: 3 : 0
0 test31 y
:
unmapall_jmf_''
jdfolder=: '~temp/jd/tdb/j31'          NB. JD table to create
csvfile30=: jpath pathin,'/test30.csv'
csv30 fwrite csvfile30
csvfolder=: jpath'~temp/jd/csv/files/csv31' NB. temp folder for csv loader
csvdefs_jdcsv_   cdef30                      NB. column definitions
R=:   csvload_jdcsv_   csvfolder;csvfile30;0       NB. csvfolder files <- csvfile
R=: R,csvappend_jdcsv_ csvfolder;csvfile30;0
R=: R,csvappend_jdcsv_ csvfolder;csvfile30;0
R=: R,csvappend_jdcsv_ csvfolder;csvfile30;0
assert c_i1__csv-: t,t,t,t=. 10000+i.csv30rows
assert c_i2__csv-: c_i1__csv
assert v_v1__csv-: t,t,t,t=. ,":,.10000+i.csv30rows
assert v_v2__csv-:v_v1__csv
if. x do. R return. end.
jdfromcsv_jdcsv_ jdfolder;csvfolder       NB. JD table        <- csvfolder files
r=. jd'reads from j31'
jd'close'
r
)

csv32=: 0 : 0
aa,bb,cc,dd
ee,ff,gg,hh
ii,jj,kk,ll
)

NB. test elided byte count - create list rather than table
cdef32=: 0 : 0
1 b  byte 
2 b1 byte 1
3 b2 byte 2
4 b3 byte 3
options , LF NO NO 0
)

valid32=: 3 : 0
assert c_b__csv-:'aei'
assert c_b1__csv-:3 1$'bfj'
assert c_b2__csv-:3 2$'ccggkk'
assert c_b3__csv-:3 3$'dd hh ll '
)


csv33=: 0 : 0
aaa,b,ccc,d,eeeee
aaa,b,ccc,d,fffff
)

cdef33=: 0 : 0
1 a byte 3
2 b byte 1
3 c byte 3
4 d byte
5 e byte 5
options , LF NO NO 0
)

valid33=: 3 : 0
assert c_a__csv-:2 3$'a'
assert c_b__csv-:2 1$'b'
assert c_c__csv-:2 3$'c'
assert c_d__csv-:'dd'
)

csv34=: 0 : 0
1,1,1,2,a,b,cd
2,2,3,4,e,f,gh
)

cdef34=: 0 : 0
1 i  int  
2 i1 int 1
3 i2 int 1 NB. 1+CSTITCH cols in col
4 i2 CSTITCH
5 b  byte
6 b1 byte 1
7 b2 byte 2
options , LF NO \ 0
)

valid34=: 3 : 0
0
)

NB. assert valid on jd table
validjd34=: 3 : 0
assert 'ae'         -:>{:,jd'read b  from j34'
assert (,.'bf')     -:>{:,jd'read b1 from j34'
assert (2 2$'cdgh') -:>{:,jd'read b2 from j34'
assert 1 2          -:>{:,jd'read i  from j34'
assert (,.1 2)      -:>{:,jd'read i1 from j34'
assert (2 2$1 2 3 4)-:>{:,jd'read i2 from j34'
)

NB. \ escapes csv load \\ \0 \t \n \r \b \" \'

cdef35=: 0 : 0
1 b byte 1
options TAB LF NO \ 0
)


foo35=: 3 : 0
d=. <"0 a.
d=. d rplc each<(92{a.);'\\'
d=. d rplc each<(0{a.)  ;'\0'
d=. d rplc each<(9{a.) ;'\t'
d=. d rplc each<(10{a.);'\n'
d=. d rplc each<(13{a.);'\r'
d=. d rplc each<(8{a.) ;'\b'
d=. d rplc each<(34{a.);'\"'
d=. d rplc each<(39{a.);'\'''
d=. ;d,each LF
)

csv35=: foo35 ''

valid35=: 3 : 0
assert 0=csverrorcount
assert 0=+/{."1 csverrors__csv
)

validjd35=: 3 : 0
a.-:,>{:"1 jd'read from j35'
)

cdef36=: cdef35
csv36=: csv35 rplc 'a';'\a'

valid36=: 3 : 0
assert 1=csverrorcount
assert 1 97 202-:(ECTRUNCATE__csv){0{csverrors__csv
)

validjd36=: 3 : 0
assert 63=('?'=,>{:"1 jd'read from j36')#i.256 NB. \a treated as ?
)

NB. test epoch when it is supported
csv37=: 0 : 0
"2006-03-31 00:00:00.000",2006-04-31 00:00:00.000
"2006-05-31 00:00:00.000",2006-06-31 00:00:00.000
)

cdef37=: 0 : 0
1 a byte 23 
2 b byte 23
options , LF " \ 0
)

valid37=: 3 : 0
assert 1
)

validjd37=: 3 : 0
assert 1 NB. 3 5 4 6-:".5 6{"1 ;{:"1 jd'read from j37'
)

tests=: 3 : 0
NB. smoutput 'RESIZESTRESS_jdcsv_ is ',":RESIZESTRESS_jdcsv_
csvop_tests''
csvreportclear_jdcsv_''
deleteall''
for_i. i.38 do.
 try.
  ".'test ',":i
  NB. smoutput 'test ',":i
 catch.
  smoutput 'failed: test ',":i
 end.
end.
unmapall_jmf_''
i.0 0
)

droptable=: 3 : 0
f=. Open_jd_ jpath'~temp'
d=. Open__f 'tdb'
Drop__d :: [ y
)

createdb=: 3 : 0
f=. Open_jd_ jpath'~temp'
Drop__f'tdb'
d=. Create__f 'tdb'
Close_jd_'*'
)

createjd=: 3 : 0
t=. ":y
jt=. 'j',t
pcsv=. '~temp/jd/csv/data/test',t
bldjd jt;csvjdcoldefs_jdcsv_ pcsv
tjd=. '~temp/jd/',jt
csvjd_jdcsv_  tjd;pcsv
seejd jt
)

bldjd=: 3 : 0
r=. jd'reads from ',table
closeall''
)

seejd=: 3 : 0
r=. jd'reads from ',y,' where jdautoid < 10'
)

NB. seejdx 'from DimClientIP where autoid = 1000'
seejdx=: 3 : 0
jd'reads from ',y
Close_jd_'*'
r
)

closeall=: 3 : 0
Close_jd_ jpath'~temp'
)
