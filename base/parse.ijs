NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

0 : 0
parsing ops is complicated by the variety of rules for different ops
parsing is a significant overhead for ops that do little else (read from small table or insert 1 row)

problems:
 read - alias - from - where - order by
 createtable coldefs - LF and comma delimiters
 createcol - byte n - data
)

coclass 'jd'

NB. if in "s - remove "s and \" -> "
jdremq=: 3 : 0
if. *./'"'={.{:y do. (}.}:y) rplc '\"';'"' else. ,y end.
)

NB. if contains " or blank - put in "s and " -> \"
jdaddq=: 3 : 0
if. +./' "'e. y do. '"',~'"',y rplc '"';'\"' else. ,y end.
)

NB. y is string of coldefs , or LF delimited
NB. return boxed list of name;type;shape
cutcoldefs=: 3 : 0
if. *./y=' ' do. '' return. end.
r=. 3{.each ' 'strsplit each ((LF e. y){',',LF) strsplit debq y
jdremq each L:1 r-.<3{.a:
)

NB. box blank delimited names - blanks in "s ignored - "s removed from names in result
bdnames=: 3 : 0
if. 0=#y do. y return. end.
if. 0=L.y do.
 jdremq each ' 'strsplit_jd_ debq y
else.
 ,each dltb each y
end.
)

strsplit=: 4 : 0
y=. x,y
q=. wherequoted y
b=. I.(x=y)*.q
d=. 'a' b}y
,each dltb each(x=d) <;._1 y
)

cutcommas=: 3 : 0
if. (#y)=+/y=',' do. '' return. end.
','strsplit y
)

NB. cutnames - cut string on blanks or commas.
cutnames=: (a: -.~ e.&', ' <;._1 ]) @ (' '&,)
stripsp=: #~ (+. +./\ *. +./\.)@(' '&~:)
wherequoted=: ~:/\@:(=&'"' *. 1,'\'~:}:)
NB. deb, but only where y is not quoted
debq=: #~ wherequoted +. (+. (1: |. (> </\)))@(' '&~:)

blankquoted_jd_=: 3 : 0
if. ''-:y do. y return. end. NB. avoid bug in wherequoted
' ' (I.wherequoted y)}y
)

NB. clean args
NB. box delimited args
NB. args delimited by blanks
NB. arg can be in "s - to allow blanks - \" escape allows " in arg
NB. * (outside of "s) allowed only for csvwr - escapes to include remainder in final arg
NB. dltb and , applied to each
NB. ca' a  bc  d\"e  "d"  "de" "de (f)*g" "a\"f" *   123\"41234   '
ca=: 3 : 0
if. 1<:L.y do. ,each dltb each y return. end.
a=. y
r=. ''
'LF not allowed' assert -.LF e. a
a=. a rplc '\"';LF
while. #a=.dlb a do.
 if. '"'={.a do.
  a=. }.a
  i=. a i.'"'
  'unmatched double quote' assert i<#a
  r=. r,<i{.a
  a=. }.i}.a
  'closing double quote not followed by blank' assert ' '={.a
 elseif. '*'={.a do.
  '* allowed only for csvwr'assert FEOP-:'csvwr'
  r=. r,<,dltb(}.a) rplc LF;'\"'
  a=. '' 
 elseif. 1 do.
  i=. a i.' '
  r=. r,<i{.a
  a=. }.i}.a
 end.
end.
r rplc each <LF;'"'
)

word1=:    '.:,><=-()'
word2=:    '>=';'<=';'<>'
wordstop=: ' ',word1

0 : 0 NB. words parse rules
" runs to closing " (\" escape is ")
word2 - 2 chars is a word
word1 - 1 char is a word
others run to non-blank or word1
)

words=: 3 : 0
a=. y
r=. ''
while. #a=.dlb a do.

if. '"'={.a do.
  a=. }.a
  t=. ''
  while. 1 do.
   i=. a i.'"'
   'unmatched "' assert i<#a
   if. '\'=(i-1){a do.
    t=. t,'"',~}:i{.a
    a=. }.i}.a
    continue.
   end.
   t=. t,i{.a
   a=. }.i}.a
   break.
  end. 
  r=. r,<t

 elseif. word2 e.~ <2{.a do.
  r=. r,<2{.a
  a=. 2}.a

 elseif. word1 e.~ {.a do.
  r=. r,<{.a
  a=. }.a
  
 elseif. 1 do.
  i=. <./a i. wordstop
  r=. r,<i{.a
  a=. i}.a
 end.  
end.
r
)

NB. box blank delimited name and the rest
bd2=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (i{.t);}.i}.t
else.
 dltb each y 
end.
)

NB. strip off next arg from boxed list or blank delimited string
getnxt=: 3 : 0
if. 0~:L.y do. (<}.y),{.y  return. end.
a=. dlb y
i=. a i.' '
a=. (i}.a);i{.a
)

getoption=: 3 : 0
if. 0~:L.y do.
 {.;{.y
else.
 {.dlb y
end.
)

NB. y is jd_... ... 
NB. x is list of options and their type
NB. result is y with options stripped
NB. option_name_jd_ set as option value
NB. options not provided are set to 0
NB. option type 0 set to 1
NB. option type 1 must be positive integer
NB. option type a (alloc) must be 3 positive integer/float
NB. option type s is a string - if string arg it can be in "s
NB. a=. '/e 0 /nx 1 /a a /s s'getopt '/e /nx 23 /a 1 2 3.5 /s "abc def"'
getopts=: 4 : 0
t=. ca x
t=. (2,~-:#t)$t
n=. {."1 t
c=. {:"1 t
p=. ;(<'_jd_ '),~each (<'option_'),each}.each n
(p)=: 0 NB. default value for options not provided
a=. y
while. '/'=getoption a do.
 'a b'=. getnxt a
 i=. n i. <b
 EOPTION assert i < #n
 p=. 'option_',(}.b),'_jd_'
 v=. ''$;i{c
 select. v
 case. '0' do.
  v=. 1
 case. '1' do.
  'a b'=. getnxt a
  v=. 0+_".;b
  EOPTIONV assert 4=3!:0 v
  EOPTIONV assert 0<:v
 case. 'a' do. NB. createtable /a - 3 values and float allowed
  'a v0'=. getnxt a
  'a v1'=. getnxt a
  'a v2'=. getnxt a
  v=. 0+_".(;v0),' ',(;v1),' ',;v2
  EOPTIONV assert (3=#v),(0<:v),_~:v
 case. 's' do. NB. string - asdf or "abc def"
  a=. dlb a
  if. '"'={.a do.
   a=. }.a
   i=. a i. '"'
   EOPTIONV assert i<#a
   v=. i{.a
   a=. }.i}.a
  else.
   'a v'=. getnxt a
  end.
 case. do.
  'bad option type' assert 0
 end.
 (p)=: v
end.
a
)

getopt=: 4 : 0
t=. ca x
t=. (2,~-:#t)$t
n=. {."1 t
c=. {:"1 t
p=. ;(<'_jd_ '),~each (<'option_'),each}.each n
(p)=: 0 NB. default value for options not provided
a=. y
while. '/'={.;{.a do.
 p=. 'option_',(}.;{.a),'_jd_'
 i=. n i. {.a
 EOPTION assert i<#n
 select. ''$;i{c
 case. '0' do.
  a=. }.a
  v=. 1
 case. '1' do.
  EOPTIONV assert 1<#a
  v=. 0+_".;1{a
  EOPTIONV assert 4=3!:0 v
  EOPTIONV assert 0<:v
  a=. 2}.a
 case. 'a' do. NB. createtable /a - 3 values and float allowed
  EOPTION assert 3<#a
  v=. 0+_".each 1 2 3{a
  EOPTIONV assert (0<:v),_~:v
  a=. 4}.a
 case. 's' do. NB. string - asdf or "abc def"
  EOPTION assert i<#n
  v=. 1{a
  a=. 2}.a
 case. do.
  'bad option type' assert 0
 end.
 (p)=: v
end.
a
)

NB. work in progress to support RESERVEDCHARS in col names
NB. "s to delimit col and alias names - "how ,.:\" now"

0 : 0
[agg ][alias:][tab].col [,...]
)

spec=: ' ,.:' NB. chars used in parsing read select clause

selfix=: 3 : 0
a=. wherequoted y
b=. y e. spec
i=. I.a*.b
((spec i. i{q){'ABCD') i}y
)
