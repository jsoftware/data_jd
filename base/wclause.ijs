NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

NB. not used
NB. try to get read where clause to use parsed words

coclass 'jdtable'

s__=: 'a=1 or a=2 or a=3'
s__=: 'a=1 and ( a=2 or a=3 ) or a=4'

fix__=: fixwhere_jdtable_
do__=: 3 : 0
wh_jdtable_ words_jd_ y
)


NB. scalar different that string from "s
wdot=:    <'.'
wcomma=:  <','
wlparen=: <'('
wrparen=: <')'

wconj=: <;._1' and && or ||'

wh=: 3 : 0
if. 0=#y do. '' return. end.
txt =. y

parenl =. +/\ ('(';')') -/@:(=/) txt

if. {:parenl do. throw 'Unmatched parenthesis in where clause' end.

if. 'not' -: ;{.txt do. 'qnot' ; <wh }.txt return. end.
if. '!' -: ;{.txt do. 'qnot' ; <wh }.txt return. end.

if. '(' = ;{. txt do.
  ndx=. 0 i.~ parenl
  bal=. }. ndx }. txt
  txt=. }. ndx {. txt
  
  sel=. wh txt
  if. #bal do.
    op=. ;{.bal
    
    NB. ind=. (1 i.~ e.&' ' > wherequoted_jd_) bal
    ('q',op) ; sel ; <wh }.bal
  end.
  return.
end.

msk=. 0=parenl
a=. msk#txt

bal=. txt

NB. get [t.]c relation data conjunction from arg

NB. get [t.]c relation from arg
if. wdot=1{bal do. NB. tab.col
 txt=. (<;3{.bal),3{bal
 bal=. 4}.bal
else.
 txt=. 2{.bal
 bal=. 2}.bal
end.

NB. data runs to conjunction or end
NB. get data - could be in parens

i=. <./bal i. wconj
val=. i{.bal
bal=. i}.bal
txt=. txt,<;val

if. 0=#bal do. <wh1 txt return. end.

op=. {.bal
bal=. }.bal

NB. bal=. (ndx+1) }. txt
NB. ind=. bal i. ' '
('q',;op) ; (wh txt) ; <wh bal
)

wh1=: 3 : 0
'bad or exists'assert 3=#y
i=. (dltb each qDFS) i. <,;1{y

'bad op' assert i<#qDFS
({.y),(i{qFNS),{:y
)


dequote=: 3 : 0
if. '"'={.y do. }.}:y else. y end.
)