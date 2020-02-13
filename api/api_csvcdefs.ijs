NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. [options] csvfile
jd_csvcdefs=: 3 : 0
a=. ca'/replace 0 /c 0 /h 1 /u 0 /v 1'getopts y
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

dtbm=: 3 : '>dtb each<"1 y'


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
 assert IMIN~:v
 if. *./0=(86400*1e9)|v do. 'edate'      return. end.
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
