NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Template for a type class
NB. Atomic types will inherit from this

coclass 'jdtbase'
DATATYPES_jd_ =: ''
visible =: 1
static =: 1
MAP =: ;:'dat'

DATASIZE =: IF64 { 32 64
DATAFILL =: 0

testcreate=: ]
opentyp=: ]
makecolfiles=: 3 : 0
(typ;shape) makecolfile 'dat'
writestate''
)

getmessage =: 'Invalid ',".@:('typ'"_),' data'"_
throwif =: (throw@getmessage^:]) : (throw@[^:]) NB. for use in fixtype
ADDRANK =: 0  NB. additional rank fixtype can handle
fixtype =: ,@boxopen
fixinsert =: ]

fixtype_where =: 3 : 0
d =. fixtext y
if. 0=#shape do.
  if. 1<*/$d do.
    throw 'Shaped data in where clause for unshaped column: ',y
  end.
  {.@, d return.
end.
if. shape <&# $d do.
  throw 'Data shape is larger than item shape: ',y
end.
if. ($d) > s =. (<:#$d) ({.,*/@:}.) shape do.
  throw 'Where data larger than column items: ',y
end.
shape $ s {.!.DATAFILL d
)
fixtext =: fixtype_num&.,:@:fixnum

select =: 3 : 'y{dat'
modify =: 4 : 'dat=: (fixinsert y) x} dat'
modifyfilled =: 4 : 'MAP replacemap&> fixtype y x} DATAFILL$~Tlen,shape'

NB. =========================================================
NB. Should only be called by the table.
Insert=: 3 : 0
if. 0=#MAP do. return. end.
assert. (dat +&# 0{::y) = Tlen
MAP appendmap&> fixinsert y  NB. fixinsert inherited from type
)

Revert=: 3 : 0
if. 0=#MAP do. return. end.
y 4 :'(x) =: y{.".x'~^:(<#@".) >{.MAP
)

NB. =========================================================
NB. fix a value for insertion
fixvalue=: 3 : 0
'Invalid data rank' throwif (#$y) > ADDRANK + >:#shape
if. shape =&# $y do. y=.,:y end.
'Invalid data shape' throwif shape ([ -.@-: #@[ {. ]) }.$y
fixtype y
)

NB. =========================================================
deftype  =: 3 : 0
  loc =. <'jdt',y
  coinsert__loc coname ''
  DATATYPES_jd_ =: DATATYPES_jd_, <typ__loc =: y
  'jdt',y
)


NB. =========================================================
NB. Primitive where queries
NB. y is data to test against

DEFQUERIES =: <;._2 ]0 : (0)
name  =: 3 : 'dat I.@:(func"_1 _) y'
namec =: 3 : 'dat I.@:(func"_1) dat__y'
namef =: 2 : '(u{dat) I.@:(func"_1) v{dat__y [ y'
)
NB. y is (qname ; J verb) where the J verb is a string.
NB. Define corresponding queries qname and qnamec.
defquery =: 3 : 0
".&.> DEFQUERIES rplc&.> <('name';'func') ,@,. y
EMPTY
)
defqueries =: defquery@:(({.~ ;&deb }.~) i.&' ');._2

NB. =========================================================
defqueries 0 :0
qequal        -:
qnotequal     -.@-:
qin           e.
qnotin        -.@e.
)

qsample=: 3 : 0
/:~ y (] {~ ((<.? ])#)) I.dat__active__PARENT
)
qSample=: 3 : 0
/:~ y (] {~ ((<.?.])#)) I.dat__active__PARENT
)

cd_qlike=: LIBJD_jd_,' qlike > x x x x x'

qlike=: 3 : 0
b=. (#dat)#0
r=. cd_qlike cd 1,(gethad'b'),(gethad'dat'),gethad'y'
if. 0~:r do. throw 'C qlike failed with code ',":r end.
I.b
)

qunlike=: 3 : 0
b=. (#dat)#0
r=. cd_qlike cd 0,(gethad'b'),(gethad'dat'),gethad'y'
if. 0~:r do. throw 'C qlike failed with code ',":r end.
I.b
)

