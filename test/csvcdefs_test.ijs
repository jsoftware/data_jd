NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

NB. csvdefs set cdefs types from data

0 : 0
dateX
all dateX fields must be of same format

 8 20001212
10 2000-12-12

 8 12122000
10 12-12-2000

14 20001212151515
19 2000-12-12-15-15-15

14 12122000151515
19 12-12-2000-15-15-15
)

NB. byte       abc;xxxxxxxxxxxxxxxxxxxxxxxxxxxxx


tests=: <;._2 [0 : 0
varbyte    abc;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
byte_30    abc;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
byte       ;;;
byte       ;    ;;
boolean    0;1;0;1
boolean    0;1;1;0;true;false;TRUE;FALSE
int        2;+23;-123
float      2;2.3;+2.3;2.3e7;-2.3E7;.23
int        20001212;20001213
int        12122000;12132000
int        20001212101010;20001213101010
int        12122000101010;12132000101010
edate      2001-10-10;2002-12-12
edatetime  2001-10-10T10;2002-12-13T10:10:10
edatetimem 2001-10-10T10:10:10.123;2002-12-13T10:10:10.123
edatetimen 2001-10-10T10:10:10.1234;2002-12-13T10:10:10.1234
)

run=: 3 : 0
r=. ''
a=. y
for_i. i.#a do.
 n=. ;i{a
 b=. n i. ' '
 type=. b{.n
 d=. dlb b}.n
 d=. <;._1 ';',d
 d=. >,each d
 t=. 40 gettypex_jd_ d
 t=. t rplc ' ';'_'
 if. -.type-:t do. echo 'failed: ',(2":i),' -  ',n end.
 r=. r,type-:t
end.
assert r
)

run''

CSVFOLDER=: jpath '~temp'
fcsv=:   CSVFOLDER,'/t1.csv'
fcdefs=: CSVFOLDER,'/t1.cdefs'

csv=: 0 : 0
name,num,price,text
"cog",30,12.34
"nut",,18.75,jkl mno
"pin",32,,qewrqwerqewr
)

csv fwrite fcsv

rd=: 3 : 0
'new' jdadmin 'test'
jd 'csvcdefs /replace /h 1 t1.csv'
jd 'csvrd t1.csv tab'
jd 'reads /types from tab'
)

assert ('name(byte 3)';'num(int)';'price(float)';'text(byte 12)')-:{.rd''