NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtable'

NB. =========================================================
fixwhere=: 3 : 0
if. ' ' *./@:= y do. '' return. end.
txt =. debq_jd_ y

quoted =. wherequoted_jd_ txt
if. {:quoted do. throw 'Open quote in where clause' end.
parenl =. +/\ (-.quoted) * '()' -/@:(=/) txt
if. {:parenl do. throw 'Unmatched parenthesis in where clause' end.

if. 'not ' -: 4{.txt do. 'qnot' ; <fixwhere 4}.txt return. end.
if. '!' -: {.txt do. 'qnot' ; <fixwhere }.txt return. end.
if. '(' = {. txt do.
  ndx=. 0 i.~ parenl
  bal=. dlb (ndx + 1) }. txt
  sel=. fixwhere }. ndx {. txt
  if. #bal do.
    ind=. (1 i.~ e.&' ' > wherequoted_jd_) bal
    ('q',ind {. bal) ; sel ; <fixwhere (ind + 1) }. bal
  end.
  return.
end.

msk=. (-.quoted) *. 0=parenl
conj =. <;._1' and && or ||'
ndx=. 1 i.~ msk *. +./ ((' ',,&' ')&.> conj) E.&> <txt
if. ndx=#txt do. <fixwhere1 txt return. end.

bal=. (ndx+1) }. txt
ind=. bal i. ' '
('q',(|.conj)rplc~ind{.bal) ; (fixwhere ndx {. txt) ; <fixwhere ind }. bal
)

NB. =========================================================
fixwhere1=: 3 : 0
sel=. ~:/\@:(=&'"' *. 1,'\'~:}:) y
'ndx ind'=. ((],i.)<./) i.&1@:>&sel&> qDFS E.&.> <y
if. ndx = #sel do.
  if. -.' 'e.y do. 'exists';<y return. end.
  throw '101 Unrecognised where statement: ',y
end.
len=. # ind pick qDFS
strip =. (}.^:(' '={.)) @: (}:^:(' '={:))
bal=. strip (ndx + len) }. y
(strip ndx {. y) ; (ind pick qFNS) ; strip bal
)


require 'regex'

NB. =========================================================
NB.*qFNS n list of selection functions
NB. qDFS n corresponding definitions

NB. pad with spaces if alphabetic
pad =. (' ',,&' ')^:(+./@:e.&(,+&(i.26)&.(a.&i.)"0 'aA'))

'qFNS qDFS' =: <"_1 |: ; <@({.,.pad&.>@}.)@:cut;._2 (0 : 0)
qgreaterequal ge >=
qlessequal le <=
qnotequal ne <>
qequal eq is =
qgreater gt >
qless lt <
qrange range
qin in
qnotin notin
qlike like
qlikeci likeci
qunlike unlike
qunlikeci unlikeci
qsample sample
qSample sample.
)

NB. function definitions
NB. Modifiers: take one or two lists of indices
qand=: [#~e.
qor=: /:~@~.@,
qnot=: 4 : 'y-.~i.Tlen'

NB. getwhere v get row index
getwhere=: 3 : 0
if. #y do.
  getwherex fixwhere y
else.
  i.Tlen
end.
)

NB. =========================================================
NB. getwherex v returns selection mask
getwherex=: 3 : 0
select. #y
case. 0 do.
  i. Tlen
case. 1 do.
  'col fn val'=. 0{::,y
  if. '.' e. col do.
    'tab col' =. (({.~ ; (}.~>:)) i.&'.') col
    r =. getreadref tab
    tab =. getloc '^.',>{.{:subscriptions__r
    dat__r I.@:e. >:getwherex__tab ,<col;fn;val
    return.
  end.
  getwheresimp 0{::,y
case. 2 do.
  'opn sel'=. y
  opn~ getwherex sel
case. 3 do.
  'opn sel1 sel2'=. y
  sel1 opn~&getwherex sel2
end.
)

getwheresimp=: 3 : 0
'col fn val' =. y
if. ',' e. col do.
  if. -.(<fn) e. ;:'qequal qin' do.
    throw 'Multicolumn syntax not allowed for operations other than = and in'
  end.
  cols =. getlocq&.> col =. cutcommas col
  cols 4 :'assertfunc__x y'&> <fn
  val =. (fn;<cols) fixtype_fn_jdcolumn_ val
  lookup =. [: qand&.>/ cols 4 :'qequal__x y'&.> ]
  > qor&.>/ , lookup"1 val
  return.
end.
col=.getlocq col
if. (<val) e. NAMES do.
  getwhere2__col fn ,&< getlocq val
else.
  getwhere1__col fn; val
end.
)

NB. =========================================================
coclass 'jdcolumn'
coinsert 'jd'

assertfunc=: 3 : 0
if. 3 ~: 4!:0 <y do.
  throw 'Error: query ',y,' is not available for type ',typ
end.
)

getwhere1=: 3 : 0
'fn y'=. y
assertfunc fn
if. 0=Tlen do. '' return. end.
fn~  fn fixtype_fn y
)

NB. select between two columns
getwhere2=: 3 : 0
'fn col'=. y
assertfunc fn=.fn,'c'
assert. typ=typ__col
fn~ col
)

NB. select on a foreign column
getwheref=: 3 : 0
'fn col u v'=. y
if. 2 ~: 4!:0 <fn=.fn,'f' do.
  throw 'Error: query ',fn,' is not available for type ',typ
end.
assert. typ=typ__col
(u fn~ v)  col
)

NB. Type conversion
fixtype_fn =: 4 : 0
if. 1<:L.x do. NB. multicolumn query
  'x cols' =. x
  fixtype_where =. cols&fixtype_where_multi
end.
select. x
  case. 'qlike';'qunlike';'qlikeci';'qunlikeci' do.
    fix1string y
  case. 'qsample';'qSample' do.
    if. #@$ y =. fixnum y do. throw 'Too many numbers for sample: ',":y end.
    if. y<0 do. throw 'Negative argument to sample: ',":y end.
    y
  case. 'qin';'qnotin';'qrange' do.
    parenl =. ([: +/\ -.@wherequoted_jd_ * '()' -/@:(=/) ]) y
    y =. stripsp@}.@}: ^: (*./*(,#)}:parenl) y
    if. 0=#y do. DATAFILL $~ 0,shape return. end.
    allowed =. -.@wherequoted_jd_ ([ *. 0 = +/\@:*) '()' -/@:(=/) ]
    r=. (fixtype_where@:stripsp;._1~ =&',' *. allowed) ',',y
    if. x-:'qrange' do. 'range is not sorted' assert (-:/:~)r end.
    r 
  case. do.
    fixtype_where y
end.
)

fixstring =: [:($~1-.~$) [:fix1string&.> a.-.~ (<;._1~ =&' ' *. -.@wherequoted_jd_)@,~&' '
fix1string =: 3 : 0
  if. 0 e. }:@:wherequoted_jd_ y do.
   throw 'invalid string'
  end.
  cescape_jd_}.}: y
)

fixnum=: 3 : 0
if. ('edate'-:5{.typ) *. '"'={.y do. 
 r=. efs }.}:y
else.
 r=. __".y
 if. __ e. r do. 'invalid number' assert -.+./(__=r) *. _=_".y end.
 NB. Temporary fix for bug in dyad ".
 if. 0*.(4 = 3!:0 r) *. *@# (i =. (2<.@^52) I.@:<: |r) do.
  r =. (".@> i { a: -.~ <;._1 ' ',y) i} r
 end.
end.
r
)

fixtype_where_multi =: 4 : 0
parenl =. ([: +/\ -.@wherequoted_jd_ * '()' -/@:(=/) ]) y
y =. }.@}: ^: (*./*(,#)}:parenl) y
y =. (<@stripsp;._1~ ~:&',' +: wherequoted_jd_) ',',y
'Number of columns does not match number of values' assert x =&# y
x  4 :(':';'fixtype_where__x y')&.>  y
)
