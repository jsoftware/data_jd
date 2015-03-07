NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtref'
coinsert 'jddbase'
coinsert 'jdtindex'

NB. simple reference has only datl and supports only join left1
NB. inserts/updates/deletes set dirty
NB. join sets datl if required by dirty
NB. Subscription 0 has referencing columns
NB. Subscription 1 has referenced column

typ =: 'ref'
MAP =: <'datl'
STATE=: STATE_jddbase_,<'dirty'
dirty=: 1

opentyp =: ]

NB. y 0 or 1
setdirty=: 3 : 0
if. dirty=y do. return. end.
dirty=: y
writestate''
)

NB. y is subscriptions
testcreate =: 4 : 0
s =. ({.,(,&.>@:,@:boxxopen)&.>@{:)@:(,&.>)"1 y
assert. 2 = #s
'R T' =. getloc__x@:('^.'&,)&.> {."1 s
assert. R-:x
'Rc Tc' =. (R,T) 4 :'getloc__x@>&.> y'"0 {:"1 s
assert. *./ Rc -:&(3 :'typ__y'"0) Tc
assert. *./ Rc -:&(3 :'shape__y'"0) Tc
)

NB. dynamicinit=: 3 : 0
NB. ('index';$0) makecolfile 'datl'
NB. writestate''
NB. )


NB. create with empty mapped file - setdatl will resize as required
dynamicinit=: 3 : 0
y=. 'datl'
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

NB. f,f.g
NB. (f.active stitch fcols) i. adjusted-g.active stitch g cols
NB. g.active adjusted so deleted rows won't match
setdatl=: 3 : 0
if. -.dirty do. return. end.
d=. getdb''
NB. insist on no deletes for either left or right
a=. jdgl (;{.1{subscriptions),' jdactive'
t=. *./dat__a
a=. jdgl (;{.0{subscriptions),' jdactive'
t=. t*.*./dat__a
'ref can not be built (see Technical|ref)' assert t
a=. jdgl (;{.1{subscriptions),' ', ;;{:1{subscriptions
b=. jdgl (;{.0{subscriptions),' ', ;;{:0{subscriptions
ac=. #dat__a 
bc=. #dat__b
if. (bc*8)>getmapsize'datl' do.
 resizemap 'datl' ; Padvar*bc*8
end.
datl=: dat__a i. dat__b
datl=: _1 ((datl=ac)#i.#datl)}datl
setdirty 0
)

NB. datl may be out of date - ensure it is current
select =: 3 : 0
setdatl''
y{datl
)

InsertSimple =: 3 : 0
assert 0
)

Update=: setdirty@1:
Insert=: setdirty@1:

getreferenced=: 3 : 0
getloc '^.^.',>{.{:subscriptions
)

default_join =: 3 : 0
setdatl''
'l r' =. y
'Tl Tr' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
if. 0=#l do. j =. _1 ,. (I.dat__active__Tl) ,: dat__active__Tl # datl
else. j =. l ,: (_1~:l) (-.@[-~*) l{datl [ l=.(#~{&dat__active__Tl)l end.
(#"1~ e.&r@:{:)^:(*@#r) ({. ,: ({&dat__active__Tr (-.@[-~*) ])@:{:) j
)

inner_join=: left_join=: right_join=: outer_join=: 3 : 0
throw'jde: ref only supports left1 join'
)

