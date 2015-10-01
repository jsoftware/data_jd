NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass 'jd'

MAXROWCOUNT=: 1e5
HASHFAST=: 1         NB. use H code
HASHPASSLEN=: <.2^60 NB. code exists byt not used
HASHCREATE32BIT=: 0  NB. code exists but not used

reduce =: 1 : ('u/ y';':';'for_z. |.x do. y=.z u y end.')

dcreate=: (1!:5 :: 0:) @ (fboxname@:>)
derase=: (1!:55 :: 0:) @ (fboxname@:>)

pack=: [: (,. ".&.>) ;: ::]
pdef=: 3 : '0 0$({."1 y)=: {:"1 y'
termSEP=: , (0 < #) # '/' -. {:
tindexof=: i.&>~@[ i.&|: i.&>
tnubsieve=: ~:@|:@:(i.&>)~
tocolumn=: ,. @: > each
strsplit=: #@[ }.each [ (E. <;.1 ]) ,

throw=: 13!:8&101

rethrow=: throw @ (13!:12@(''"_) , ])
throwmsg=: }. @ ({.~i.&LF) @ (13!:12)

NB. =========================================================
MAX_INT =: 2^64x
to_unsigned =: MAX_INT | x:

NB. =========================================================
NB. cutcommas - cut string on commas.
cutcommas=: stripsp each @ (a: -.~ <;._1) @ (','&,)
NB. cutnames - cut string on blanks or commas.
cutnames=: (a: -.~ e.&', ' <;._1 ]) @ (' '&,)
stripsp=: #~ (+. +./\ *. +./\.)@(' '&~:)
wherequoted=: ~:/\@:(=&'"' *. 1,'\'~:}:)
NB. deb, but only where y is not quoted
debq=: #~ wherequoted +. (+. (1: |. (> </\)))@(' '&~:)

NB. =========================================================
coinserttofront =: 3 : 0
p=. ; <@(, 18!:2)"0  ;: :: ] y
p=. ~. p, (18!:2 coname'')
(p /: p = <,'z') 18!:2 coname''
)

NB. =========================================================
NB. dirsubdirs
NB. return sub directories in top level directory
NB. ignore any hidden files
dirsubdirs=: 3 : 0
r=. 1!:0 (termSEP y),'*'
if. 0=#r do. '' return. end.
{."1 r #~ '-d' -:("1) 1 4{"1 > 4{"1 r
)

NB. convert varbyte boxes from internal format
vbfix=: 3 : 0
c=. ;#each y
(n=. (0,}:+/\c),.c);;y
)

EDFAIL=: LF,'Jd info: N delete folder failed - technical.html|wss',LF,'F',LF,'E','trying again',LF,LF

NB. delete folder
NB. allowed if jddeleteok
NB.  not allowed if jddropstop
NB.   not allowed if too few /s (/abc/def ok and /abc bad)
NB.    allowed if empty or jdclass or in ~temp
jddeletefolder=: 3 : 0
y=. (-'/'={:y)}.y NB. drop trailing /
y=. jpath y
('folder (F) locked by Jd'rplc 'F';y) assert -.(<y)e.{:"1 jdadminlk_jd_''
t=. y,'/' NB. ensure trailing /
if. -.fexist t,'jddeleteok' do.
 EDROPSTOP assert -.fexist t,'/jddropstop'
 e=. 'delete ',y,' not allowed'
 e assert 3<:+/t='/'
 p=. jpath'~temp/'
 e assert (0=#fdir t,'*')+.(fexist t,'jdclass')+.p-:(#p){.t 
end.
r=. rmsub y
t=. hostpathsep y
if. 0~:;{.r do.
 echo EDFAIL rplc'N';'1st';'F';t;'E';{:r
 6!:3[5
 r=. rmsub y
 if. 0~:;{.r do.
  echo EDFAIL rplc'N';'2nd';'F';t;'E';{:r
  6!:3[10
  r=. rmsub y
  if. 0~:;{.r do.
   echo EDFAIL rplc'N';'3rd';'F';t;'E';{:r
   6!:3[60
   r=. rmsub y
   if. 0~:;{.r do.
    EDELETE assert 0
   end. 
  end.  
 end.   
end.
y
)

jddeletefolderok=: 3 : 0
t=. jpath y
t=. t,(-.'/'={:t)#'/' NB. ensure trailing /
''fwrite t,'jddeleteok'
y
)

NB. write (x 1) or erase (x 0) all jddropstop files in path
NB. x 0 erase - x 1 write
NB. y is '' or 'table' or 'table col'
jddropstop=: 3 : 0
1 jddropstop y
:
p=. dirpath(jdpath''),(deb y)rplc' ';'/'
p=. p,each<'/jddropstop'
if. x=0 do.
 ferase each p
else.
 a: fwrite each p
end.
i.0 0
)

0 : 0
Windows Search Service (content indexing, ...) and
and other windows background tasks (antivirus?)
can cause rmdir to fail. See technical.html.

This problem is mitigated by doing rmdir several
times as required with a sleep.
)

NB. similar to rmdir_j_
NB. host facilities delete folder
rmsub=: 3 : 0
y=. jpath y
if. IFWIN do. y=. hostpathsep y end.
d=. 1!:0 y
if. 1~:#d do. 0;'' return. end. NB. folder already empty
if. 'd'~:4{4 pick{.d do. ('not a folder: ',y) assert 0 end.
if. IFWIN do.
  r=. shell_jtask_ 'rmdir /S /Q ','"','"',~y
else.
  r=. hostcmd_j_ 'rm -rf ','"','"',~y NB. --preserve-root
end.
if. #r do. 1;r return. end.
6!:3[0.01 NB. sometimes required in windows so next test works
if. 0=1!:0 y do.
 0;''
else.
 1;'delete did not complete'
end.
)

cre8folder=: 3 : 0
t=. jpath y
for_n. ('/'=t)#i.#t=. t,'/'  do.
  1!:5 :: [ <n{.t
end.
y
)

jdcreatefolder=: cre8folder_jd_

NB. need general mechanism to log progress on long running operations
NB. this is a crude place holder for what is required
logprogress=: 3 : 0
try. y fwrite '~temp/jdprogress' catch. end.
)

NB. cd utilities
pointer_to =: 3 :'pointer_to_name ''y'''
pointer_to_name=: 1 { [: memr (0 4,JINT) ,~ symget@boxopen@,

gethad=: 1 { [: memr 0 4 4 ,~ [: symget <

3 : 0''
t=. jpath JDP,'cd/'
p=. jpath'~tools/regex/'
if. UNAME-:'Linux' do.
 t=. t,'libjd.so'
 p=. p,'libjpcre.so'
elseif. UNAME-:'Darwin' do.
 t=. t,'libjd.dylib'
 p=. p,'libjpcre.dylib'
elseif. 1 do.
 if. _1=nc<'DLLDEBUG__' do.
  t=. t,'jd.dll'
 else.
  t=. '\dev\j\p_dll\x64\debug64\p_dll.dll' NB. ms visual studio debug
 end.
 p=. (p,'jpcre.dll')rplc'/';'\'
end.
LIBJD=: '"',t,'"'
'Jd shared library failure' assert 0=(LIBJD_jd_,' regexinit >x *c') cd <p
)

NB. Date and time utils
toseconds =: (3 ((86400 * [: 3 :0 {."1) + (60 #. }."1)) (0,5#100)&#:) :. todatetime
y=.{."1 y [ m=.1{"1 y [ d=.{:"1 y
y=. 0 100 #: y - m <: 2
n=. +/"1 ]4 <.@%~ 146097 1461 *"1 y
n =. n + 10 <.@%~ 4 + (306 * 12 | m-3)  +  10 * d
n - 657378
)

todatetime =: (86400 ((1e6 * [: 3 :0 <.@%~) + 100 #. 0 60 60 #: |) ]) :. toseconds
a4=. 2629511 + 4*y
d4=. 4 (]-|) a4 - 146097 * c=. a4 <.@% 146097
d10=. 10 * 4 <.@%~ 7 + d4 - 1461 * y=. 1461 <.@%~ 3+d4
d=. 10 <.@%~ 4+d10-306* m=. 306 <.@%~ d10-6
(1e4*(c*100) + y + m>:10) + (100*1+12|m+2) + d
)

NB. format utils

NB. convert jd'...' table to HTML
tohtml=: 3 : 0
'</table>',~'<table>',;(<'<tr>'),.(tohtmlsub each y),.<'</tr>',LF
)

tohtmlsub=: 3 : 0
t=. y
if. 1=L.t do.
 t=. _1}.;t,each','
else.
 t=. ":t
 t=. }:,t,"1 LF
end.
t=. t rplc '&';'&amp;';'<';'&lt;';LF;'<br>'
t=. '<td>',t,'</td>'
)

totext=: 3 : ',LF,.~sptable y'

NB. convert jd'...' table to JSON
tojson =: verb define
if. 0=#y do. '' return. end.
'hdr dat'=. 2{.<"1 boxopen y
if. 0=#dat do. NB. no header was provided
 dat =. hdr
 hdr =. <@('column'&,)@":"0 i.#dat      NB. auto-generate column names
end.
NB.
 lbl      =. dquote each hdr
 colcount =. #dat
 rowcount =. #&>{.dat

 NB. format each column as JSON
 json =. (colcount) $ a:
 for_colndx. i. colcount do.
  col  =. (((>colndx{lbl),':'),])@dquote@escape_json_chars@dltb@":"1 each colndx{dat
  json =. col (colndx) } json
 end.
 NB. merge the individual JSON columns into a bi-dimensional char array
 json =. >((>@[) ,. ((rowcount,1)$',') ,. (>@])) / json
 NB. enclose each row between {} to represent JSON objects, add ',' and CRLF to the end of each row and raze the array
 json =. ;('{',])@(('},',CRLF),~])"1 json
 NB. amend in-place to discard the last ',' and CRLF
 json =. ' ' (-1 2 3) } json
 NB. enclose the resulting objects in [] to represent an array,
 json =. ('[',])@(']',~]) json
 NB. name the array
 json =. ('{"rows": ',])@('}',~]), json
)
escape_json_chars =: rplc&((_2[\CR;'\n';LF;'\r';TAB;'\t'), <;._2 @(,&' ');. _2 [0 : 0)
" \"
\ \\
/ \/
)

NB. Convert using escapes as in C printf (used in where clause parsing)
cescape =: ({. , ({.,$:@}.)@:cescape1@:}.)^:(<#)~ i.&'\'
NB. Argument starts with \
cescape1 =: 3 : 0 @: }. :: ('\'&,)
oct =. 8 {. hex =. 16 {. HEX =. '0123456789abcdefABCDEF'
char =. '"\abefnrtv'  [  res =. '"\',7 8 27 12 10 13 9 11{a.
select. {.y
  case. <"0 oct do. ((}. ,~ a.{~256|8#.oct i. {.)~ 3 <. i.&0@:e.&oct) y
  case. 'x' do.
    if. HEX -.@e.~ 1{y do. throw 'Missing hex digit for \x' end.
    ((}. ,~ a.{~16#.hex i. tolower@{.)~ 2 <. i.&0@:e.&HEX) }.y
  case. 'u';'U' do.
    if. HEX -.@e.~ 1{y do. throw 'Missing unicode digit for \',{.y end.
    l =. ((4 8{~'uU'i.{.) <. i.&0@:e.&HEX@:}.) y
    'c y' =. l (}. ;~ [:#:16#.hex i. tolower@{.) }.y
    n =. 5>.@%~<:@# c
    y ,~ a. {~ #. 1 (0,&.>i.n)} 1 0 ,"_ 1] _6 ]\ c {.~ _6*n
  case. <"0 char do. (}. ,~ res{~char i.{.) y
  case. do. '\',y
end.
)

NB. replace text in "s with blanks - phrase m59
blankq=: 3 : 0
' ' ((i.#y)#~(2:*./\0:,2:|+/\@(=&'"'))y)}y
)

TYPES=: <;._2 ]0 :0
boolean
int
float
byte
enum
varbyte
date
datetime
time
edate
edatetime
edatetimem
edatetimen
)

NB. 3!:0 TYPES values
TYPESj=: 1 4 8 2 4 4 4 4 4 4 4 4 4

jdfread=: 3 : 0
t=. fread y
if. (_1-:t)*.10=13!:11'' do.
 ('file read limit error (Technotes|file handles): ',;y)assert 0
end.
t
)
 
jdfwrite=: 4 : 0
t=. x fwrite y
if. (_1-:t)*.10=13!:11'' do.
 ('file write limit error (Technotes|file handles): ',;y)assert 0
end.
t
)

NB. jdsuffle 'table col'
NB. (100<.#rows) random rows are deleted/inserted one row at a time
NB. (100<.#rows) random rows are deleted/insertt in bulk
NB. result is arg which allows: jdshuffle^:3 'foo'
jdshuffle=: 3 : 0
'tab'=. y
d=. /:~|:><"1 each ,.each {:jd'reads from ',tab

NB. shuffle random rows 1 at a time
v=. ((100<.>.0.25*#v){.?~#v){v=. ,>{:jd'reads jdindex from ',tab

for_i. v do.
 t=. jd'read from ',tab,' where jdindex=',":i
 jd ('delete ',tab);'jdindex=',":i
 jd ('insert ',tab);,t
end.

NB. shuffle random rows in bulk
v=. ((100<.>.0.25*#v){.?~#v){v=. ,>{:jd'reads jdindex from ',tab
test=. 'jdindex in (',(}.;',',each":each v),')'
t=. jd'read from ',tab,' where ',test
jd ('delete ',tab);test
jd ('insert ',tab);,t

z=. /:~|:><"1 each ,.each {:jd'reads from ',tab
'shuffle failed' assert d-:z
y
)

cnts=: ;:'writestate readstate map resize'

cntsclear=: 3 : 0
cntslast=: ;".each (<'cnts_'),each cnts,each <'_jd_'
".each (<'cnts_'),each cnts,each <'_jd_=:0'
cntslast
)
