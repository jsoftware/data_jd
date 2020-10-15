NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

NB. csvrd types from explicit cdefs

CSVFOLDER=: '~temp/csv/'
fn=: CSVFOLDER,'f.csv'
fncdef=: CSVFOLDER,'f.cdefs'

badnum=:   'ECBADNUM'
badepoch=: 'ECEPOCH'
missing=:  'ECMISSING'

init=: 4 : 0
'new'jdadmin'test'
jd'createtable f'
jd'createcol f ',(x-.' '),' ',x
jd'csvwr /h1 f.csv f'
(y,LF) fappend fn
)

NB. numeric types
test=: 3 : 0
'type arg val'=. y
tps=. ;:'boolean int int1 int2 int4 float edate edatetime edatetimem edatetimen date datetime'
bad=. (tps i. <type){0,IMIN_jd_,I1MIN_jd_,I2MIN_jd_,I4MIN_jd_,__,5#IMIN_jd_
type init arg
jd'droptable g'
jd'csvrd f.csv g'
if. csverrorcount do.
 e=. ,;1{ {:csverror
 e=. (e i.' '){.e
 flage=. ' x'{~-.val-:e
 v=. {:;{:{:jd'read /e from g'
 flagv=. 'x '{~v-:bad
 v=. flage,flagv,' ',(10{.type),(12{.'|',arg,'|'),' ',(":v),' ',":val
else.
 flage=. ' x'{~2=3!:0 val
 v=. {:;{:{:jd'read /e from g'
 flagv=. 'x '{~v-:val
 v=. flage,flagv,' ',(10{.type),(12{.'|',arg,'|'),' ',":v
end. 
60{.v
)

NB. byte types - does all at once, not one at a time 
testb=: 3 : 0
'type arg'=. y
type init arg NB. empty at end
jd'droptable g'
jd'csvrd f.csv g'
jd'reads from g'
)



NB. 'int' run ints
run=: 4 : 0
>".each q=: (<'test'),each(<'''',x,''';'),each(<;._2 y),(''''';missing');'''    '';missing'
)

booleans=: 0 : 0
'0'     ; 0
'f'     ; 0 
'F'     ; 0
'1'     ; 1
't'     ; 1
'T'     ; 1
' 0'    ; 0
' 1'    ; 1
' 1xxx' ; 1
'2'     ; badnum
)

ints=: 0 : 0
'70000'     ;  70000
'   70000'  ;  70000
'70000   '  ;  70000
'-70000'    ; _70000
'+70000'    ;  70000
'ab70000cd' ;  70000
'12.12'     ;  12
'abc'       ;  badnum
'.12'       ;  badnum
'+.12'      ;  badnum
'.'         ;  badnum
'-'         ;  badnum
'+'         ;  badnum
'+.'        ;  badnum
'- 1'       ;  badnum
)

int1s=: 0 : 0
'123'   ; 123
'  123' ; 123
'-123'  ; _123
' -123' ; _123
'127'   ; I1MAX_jd_
'-128'  ; I1MIN_jd_
'128'   ; badnum
'-129'  ; badnum
)

int2s=: int1s rplc '127';'32767'     ;'-128';'-32768'     ;'I1MIN_jd_';'I2MIN_jd_';'I1MAX_jd_';'I2MAX_jd_';'128';'32768';'-129';'-32769'

int4s=: int1s rplc '127';'2147483647';'-128';'-2147483648';'I1MIN_jd_';'I4MIN_jd_';'I1MAX_jd_';'I4MAX_jd_';'128';'2147483648';'-129';'-2147483649'

floats=: 0 : 0
'ab.12'     ; 0.12
'ab12.12ab' ; 12.12
'12..23'    ; 12
)

dates=: 0 : 0
'20011212'    ; 20011212
'2001-02-02'  ; 20010202
'1900-2-1'    ; 19000201
' 20011212'   ; 20011212
'20011212 '   ; 20011212
'19-2-1'      ; badnum
'2001'        ; badnum
'200112125'   ; badnum
'abc'         ; badnum
)

edates=: 0 : 0
'2001'     ; efs_jd_ '2001'
'   2001'  ; efs_jd_ '2001'
'2001   '  ; efs_jd_ '2001'
'2001-10'  ; efs_jd_ '2001-10'
'2001+10'  ; badepoch
'2001  23' ; badepoch
)

byte6s=: 0 : 0
a

ab
    
abc
abcd
abcde
abcdef
abcdefghijk
)

testbyte=: 3 : 0
testb 'byte';byte6s
a=. jd'read from g'
a=. ;{:"1 a
b=. ,>1{.each<;._2 byte6s,LF
assert a-:b
assert 10=>{:{:jd'info summary g'
assert 2=#jd'csvreport /errors g'
'ECTRUNCATE'-:10{.,;2{ {:jd'csvreport /errors'
)


testbyteN=: 3 : 0
testb ('byte ',":y);byte6s
a=. jd'read from g'
a=. ;{:"1 a
b=.>y{.each<;._2 byte6s,LF
assert a-:b
assert 10=>{:{:jd'info summary g'
assert 2=#jd'csvreport /errors g'
'ECTRUNCATE'-:10{.,;2{ {:jd'csvreport /errors'
)

testvarbyte=: 3 : 0
testb 'varbyte';byte6s
a=. jd'read from g'
a=. >,>{:"1 a
assert a-:><;._2 byte6s,LF
assert 10=>{:{:jd'info summary g'
assert 1=#jd'csvreport /errors g'
)


runall=: 3 : 0
testbyte''  NB. byte
testbyteN 1 NB. byte 6
testbyteN 6 NB. byte 1
testvarbyte''
r=. 'boolean' run booleans
r=. r,'int'   run ints
r=. r,'int1'  run int1s
r=. r,'int2'  run int2s
r=. r,'int4'  run int4s
r=. r,'float' run floats
r=. r,'date'  run dates
r=. r,'edate' run edates
)

checkall=: 3 : 0
'runall has bad result' assert ' '=,2{."1 runall''
)

NB.! checkall''
