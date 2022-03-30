NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Template for a type class
NB. Atomic types will inherit from this

coclass 'jdtbase'
DATATYPES_jd_=: ;:'boolean int int1 int2 int4 index float autoindex byte timelike date datetime elike edate edatetime edatetimem edatetimen varbyte'
visible =: 1
static =: 1
MAP =: ;:'dat'

DATASIZE =: 8 NB. default 8 bytes
DATAFILL =: 0

countdat=: 3 : '#dat'
datcount=: ] NB. used in repair

testcreate=: ]
opentyp=: ]
makecolfiles=: 3 : 0
(typ;shape) makecolfile 'dat'
writestate''
)

getmessage=: 'Invalid ',".@:('typ'"_),' data'"_
throwif=: (throw@getmessage^:]) : (throw@[^:])

fixinsert=: ]

fixtype_where=: 3 : 0
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

fixtext=: fixtype_num&.,:@:fixnum

NB. note special code for join with empty table
select=: 3 : 0
if. (0=#dat)*.0~:#y do.
 y{(1,shape)$DATAFILL
else.
 y{dat
end.
) 

modify=: 4 : 0
if. (<NAME)e.;{:"1 SUBSCR__PARENT do. update_subscr__PARENT <NAME end. NB. mark ref dirty if required
dat=: y x} dat
)

NB. fixpairs has done scalar extension
Insert=: 3 : 0
if. 0=#MAP do. return. end.
if. typ-:'varbyte' do.
 'a b'=. fixinsert fixtype y
 appendval b
 appenddat a
else. 
 appenddat fixinsert y
end. 
)

Revert=: 3 : 0
if. 0=#MAP do. return. end.
y 4 :'(x) =: y{.".x'~^:(<#@".) >{.MAP
)

NB. =========================================================
deftype  =: 3 : 0
loc =. <'jdt',y
coinsert__loc coname ''
typ__loc =: y
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

qsample=: 3 : 'y?Tlen'
qSample=: 3 : 'y?.Tlen'

cd_qlike=: LIBJD_jd_,' qlike > x x x x x x' NB. jdt

qlike=:     1&liker
qlikeci=:   3&liker
qunlike=:   0&liker
qunlikeci=: 2&liker 

liker=: 4 : 0
b=. (#dat)#0
y=. y,{.a.
r=. cd_qlike cd JDT,x,(memhad'b'),(memhad'dat'),memhad'y'
if. 0~:r do. throw 'C qlike failed with code ',":r end.
I.b
)
