NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtreference'
coinsert 'jddbase'
coinsert 'jdtindex'

NB. Subscription 0 is the list of referencing columns.
NB. Subscription 1 contains the referenced columns.
NB.
NB. If either subscription is not hashed, a hash will be created for it.
NB.
NB. datl stores indices of the referenced table and has length equal to
NB. that of the referencing table; datr is the opposite.

typ =: 'reference'
MAP =: ;:'datl datr'

opentyp =: ]

definehash=: 3 : 0
'S T' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
hashl =: {.HASH_TYPES FindProp__S >{:{.subscriptions
hashr =: {.HASH_TYPES FindProp__T >{:{:subscriptions
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

dynamicinit =: 3 : 0
'S T' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
('index';$0) makecolfile 'datl'
makecolfile_datr T  NB. datr has Tlen etc from the referenced table
'hashl hashr' =: <@MakeHashed__PARENT__PARENT"_1 subscriptions
SUBSCR__S =: (/: LOCALE=getloc__S ::(a:"_)@>@:({."1)) SUBSCR__S
SUBSCR__T =: (/: LOCALE=getloc__T ::(a:"_)@>@:({."1)) SUBSCR__T
writestate__S''
writestate__T''
dynamicreset''
)


dynamicreset =: 3 : 0
'dynamicreset reference'trace''
'datl datr' =: ;~$0
InsertSimple@:(,&<  [:3 :'<Export__y $0'"0 [:getcols {&subscriptions)"0 i.2
writestate''
)
NB. y is a row in subscriptions. Return the corresponding column locales.
getcols =: (([:getloc '^.^.',[) 4 :'getloc__x@> y' ])&>/"1

select =: 3 : 'y{datl'

NB. Ignore updates to the other reference column
InsertSimple =: 0&Insert

Insert=: 3 : 0
1 Insert y
:
definehash ''
'i ins'=.y
hash =. i{::hashr;<hashl
cols =. getcols i{subscriptions
datname =. i{::;:'datl datr'
off =. #".datname
datname appendmap out =. ref_insert__hash ins;<cols
if. x do.
  ref =. ". i{::;:'datr datl'
  ref_update_ind__hash off;ref;<out
end.
EMPTY
)

getreferenced=: 3 : 0
getloc '^.^.',>{.{:subscriptions
)

NB. =========================================================
NB. Joins

default_join =: 3 : 0
definehash''
flip =. >/ (+_*0&=)@:#@> 'l r' =. y
if. flip do.
  if. (*@#r) *. -.unique__hashr do. r =. _1,r-.link__hashr end.
  1 0 getcjoin~ l;r return.
end.
'Tl Tr' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
if. 0=#l do. j =. _1 ,. (I.dat__active__Tl) ,: dat__active__Tl # datl
else. j =. l ,: (_1~:l) (-.@[-~*) l{datl [ l=.(#~{&dat__active__Tl)l end.

NB. kludge to handle empty table in join
if. 0=#dat__active__Tr do.
 t=. 0
else.
 t=. dat__active__Tr
end. 

(#"1~ e.&r@:{:)^:(*@#r) ({. ,: ({&t(-.@[-~*) ])@:{:) j
)

getcjoin=: 4 : 0 NB. y is the type of join
definehash''

'unique not supported for this reference' assert -.unique__hashr

flip =. >/ (+_*0&=)@:#@> 'rl rr' =. x
'Tl Tr' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
args =. , (|.^:flip'l r') ,~&.>/&;: 'dat__active__T r dat link__hash'
args =. (pointer_to_name :: 0:&.> args) , <"_1 |.^:flip y
libl =. LIBJD,' join_len > x', ($~(#args)*$)' x'
c=.2$~ 2, libl cd args
args =. (<pointer_to_name ,'c'),args
lib =. LIBJD,' join > n', ($~(#args)*$)' x'
lib cd args
|.^:flip c
)

inner_join=: getcjoin&0 0`((#"1~ 0<{:)@:default_join)@.(".@:('unique__hashr'"_)) [ definehash@]
left_join =: getcjoin&1 0`default_join@.(".@:('unique__hashr'"_)) [ definehash@]
right_join=: getcjoin&0 1 [ definehash@]
outer_join=: getcjoin&1 1 [ definehash@]
