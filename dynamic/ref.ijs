NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtref'
coinsert 'jddbase'
coinsert 'jdtindex'

0 : 0
ref has only dat and supports only left1 join
#dat is Tlen or 0 if dirty
join sets dat if required by dirty
Subscription 0 has referencing columns
Subscription 1 has referenced column

delete left - leaves dirty as is
delete right - sets dirty
insert left/right - sets dirty
update left/right col in reference - sets dirty
)

typ =: 'ref'
MAP =: <'dat'
STATE=: STATE_jddbase_,<'dirty'
dirty=: 1

opentyp =: ]

NB. y 0 or 1
setdirty=: 3 : 0
if. dirty=y do. return. end.
if. y do. dat=: 0#2 end.
dirty=: y
writestate''
)

NB. create with empty mapped file
dynamicinit=: 3 : 0
y=. 'dat'
jdcreatejmf (PATH,y);HS_jmf_
jdmap (y,Cloc);PATH,y
(y)=: i.0
writestate''
)

getmapsize=: 3 : 0
try.
  msize_jmf_ 6 pick (({."1 mappings_jmf_) i. <y,Cloc){mappings_jmf_
catch.
  0
end.
)

NB. left1 join - set dat column
setdat=: 3 : 0
if. -.dirty do. return. end.
d=. getdb''
cola=. ;{.1{subscriptions
colb=. ;{.0{subscriptions
if. 1=#;{:1{subscriptions do. NB. single col
 a=. jdgl cola,' ', ;;{:1{subscriptions
 b=. jdgl colb,' ', ;;{:0{subscriptions
 ac=. #dat__a 
 bc=. #dat__b
 if. (bc*8)>getmapsize'dat' do.
  resizemap 'dat' ; Padvar*bc*8
 end.
 dat=: dat__a i: dat__b NB. i:
else. NB. multiple col
 a=. stitch 1{subscriptions
 b=. stitch 0{subscriptions
 ac=. #a 
 bc=. #b
 if. (bc*8)>getmapsize'dat' do.
  resizemap 'dat' ; Padvar*bc*8
 end.
 dat=: a i: b
end. 
dat=: _1 ((dat=ac)#i.#dat)}dat
setdirty 0
)

NB. dat may be out of date - ensure it is current
select =: 3 : 0
setdat''
y{dat
)

getreferenced=: 3 : 0
getloc '^.^.',>{.{:subscriptions
)

default_join =: 3 : 0
setdat''
'l r' =. y
'Tl Tr' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
'join - should not happen' assert 0=#l
j =. _1 ,. (i.Tlen__Tl) ,: dat
(#"1~ e.&r@:{:)^:(*@#r) j
)

inner_join=: left_join=: right_join=: outer_join=: 3 : 0
throw'jde: ref only supports left1 join'
)
