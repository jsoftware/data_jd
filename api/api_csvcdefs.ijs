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

n=. d{.~ 1 i.~rs E. d NB. first row - could be headers

if.     TAB e. n do. colsep=. 'TAB'    [ cs=. TAB
elseif. ',' e. n do. colsep=. ','      [ cs=. ','
elseif. ';' e. n do. colsep=. ';'      [ cs=. ';'
elseif. '|' e. n do. colsep=. '|'      [ cs=. '|'
elseif. ' ' e. n do. colsep=. 'BLANK ' [ cs=. ' '
elseif. 1        do. assert 0['unable to determine colsep'
end.

quoted=. '"'
escaped=. 'NO'

cnames=. fread csvfpcnames
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
 cnb=. jdremq_jd_ each cs strsplit_jd_ debq_jd_ n-.CRLF
else.
 t=. fread csvfpcnames
 cnb=. <;._2 toJ t,>(LF={:t){LF;''
end.
cols=. #cnb
cn=. >jdaddq each cnb
nums=.  >(( #":cols)":each<"0 >:i.cols)rplc each <' ';'0'

c=. ,LF,.~nums,.' ',.cn,"1 ' byte ',":>:varb
c=. c,'options ',colsep,' ',rowsep,' ',quoted,' ',escaped,' ',(":headers),' iso8601-char ',LF
jd'droptable csvprobe'
c fwrite csvfpcdefs
jd_csvrd '/rows 5000 CSVF csvprobe'rplc 'CSVF';csvy
if. _1-:cnames do. ferase csvfpcnames else. cnames fwrite csvfpcnames end. NB. restore original cnames
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
NB. csvrd has permissive conversions - 'abc123def' -> int 123
NB. csvcdefs has strict conversions  - 'abc123def' -> byte 9 
NB. varbyte if varb <width
NB. byte width if width>29 (efs max len)
NB. byte if all fields empty or missing
NB. remove all missing/empty fields as these do not determine type
NB. byte if no fields
NB. boolean if all fields (lowercase) are 0, f, false, 1, t, or true
NB. int/float if __".y conversion has no __
NB. efs if efs conversion has no errors
NB. field starting with 'null' (any case) and followed by blanks
NB.  is not used to determine type
gettype=: 4 : 0
varb=. x

w=. {:$y
if. varb<w do. 'varbyte' return. end.
if. 29<w   do. 'byte ',":w return. end. NB. efs max len is 29
a=. <"1 y

NB. remove rows that are 'null',blanks (not case sensitive)
n=. tolower each  dtb each a
a=. (n~:<'null')#a
if. 0=#a do. 'int' return. end. NB. all null treated as int
a=. dlb each a NB. trailing blanks have already been dropped
a=. a-.a:
if. 0=#a do. 'byte' return. end.
NB. a is dltb boxed items with empties removed

NB. boolean
b=. tolower each a
b=. b e. ,each '0';'f';'false';'1';'t';'true'
if. *./b do. 'boolean' return. end.

NB. int/float
t=. ;__".each a
if. -.__ e. t do. ;(2 4 i. 3!:0[t){'boolean';'int';'float' return. end.

NB. test for is08601
v=. ;efs each a
if. *./IMIN~:v do.
 if. *./0=(86400*1e9)|v do. 'edate'      return. end.
 if. *./0=1e9|v         do. 'edatetime'  return. end.
 if. *./0=1e6|v         do. 'edatetimem' return. end.
 'edatetimen' return.
end.
'byte ',":w
)


