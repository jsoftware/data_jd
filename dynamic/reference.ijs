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
hashl =: {.('hash';'unique') FindProp__S >{:{.subscriptions
hashr =: {.('hash';'unique') FindProp__T >{:{:subscriptions
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
'hashl hashr' =: <@MakeHashed__PARENT__PARENT"_1 subscriptions
'S T' =. ([:getloc '^.^.'&,)&.> {."1 subscriptions
SUBSCR__S =: (/: LOCALE=getloc__S ::(a:"_)@>@:({."1)) SUBSCR__S
SUBSCR__T =: (/: LOCALE=getloc__T ::(a:"_)@>@:({."1)) SUBSCR__T
               ('index';$0) makecolfile 'datl'
erase 'Tlen' [ ('index';$0) makecolfile 'datr' [ Tlen=:Tlen__T
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
InsertSimple =: 3 : 0
definehash ''
'i ins'=.y
len =. # 0{:: 0{:: ins

outP =. pointer_to out=.len$2  NB. out must be integer-typed
hashP =. pointer_to_name 'hash__hash' [ hash =. i{::hashr;<hashl
l =. # cols =. getcols i{subscriptions
t =. 3|>: (;:'varbyte enum') i. 3 : '<typ__y'"0 cols
ind =. +/\ 0,}:t{1 2 2
col =. pointer_to_name@>  ; 3 :'ExportMap__y $0'&.> <"0 COLS__hash
ins =. pointer_to@> ; ins

lib =. LIBJD,' ref_insert > n x x x *x *x *x *x'
lib cd outP;hashP;l;t;ind;col;<ins
(i{::;:'datl datr') appendmap out
)

Insert=: 3 : 0
definehash ''
'i ins'=.y
len =. # 0{:: 0{:: ins

off =. #". datname =. i{::;:'datl datr'
outP =. pointer_to out=.len$2  NB. out must be integer-typed
hashP =. pointer_to_name 'hash__hash' [ hash =. i{::hashr;<hashl
l =. # cols =. getcols i{subscriptions
t =. 3|>: (;:'varbyte enum') i. 3 : '<typ__y'"0 cols
ind =. +/\ 0,}:t{1 2 2
col =. pointer_to_name@>  ; 3 :'ExportMap__y $0'&.> <"0 COLS__hash
ins =. pointer_to@> ; ins

refP =. pointer_to_name i{::;:'datr datl'

if. unique__hash do.
 linkP=. 0
else. 
 linkP =. pointer_to_name 'link__hash'
end. 

lib =. LIBJD,' ref_insert_2 > n x x x x *x *x *x *x x x'
lib cd off;outP;hashP;l;t;ind;col;ins;refP;<linkP
datname appendmap out
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
(#"1~ e.&r@:{:)^:(*@#r) ({. ,: ({&dat__active__Tr (-.@[-~*) ])@:{:) j
)

getcjoin=: 4 : 0 NB. y is the type of join
definehash''
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
