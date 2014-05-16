NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtbase'
coclass deftype 'enum'

MAP =: ;:'dat nub'

makecolfiles=: 3 : 0
('int'; $0   ) makecolfile 'dat'
('byte';shape) makecolfile 'nub'
writestate''
)

DATAFILL =: ' '
fixtype =: 3 : 0
  if. 1=L.y do.
    'y_dat y_nub' =. y
    'Invalid index rank' throwif 1 ~: #$y_dat
    'Invalid nub shape' throwif shape -.@-: }.$y_nub
    y=. (fixtype_jdtint_ y_dat) ; (fixtype_jdtbyte_ y_nub)
  else.
    y=. ((i.~~.);~.) y
  end.
)
fixinsert =: 3 : 0
  new=.nub1-.nub [ 'dat1 nub1'=.y
  new ;~ (nub,new) i. dat1{nub1
)
fixtext =: fixtext_jdtbyte_

Revert=: 3 : 0
if. y>:#dat do. return. end.
dat =: y{.dat
nub =: (>: >./ dat) {. nub
)

select =: 3 : 'nub {~ y{dat'
modify =: modifyfilled=: 4 : 'throw ''Modifying enum columns not yet supported: '',NAME'

NB. =========================================================
NB. Primitive where queries
NB. y is data to test against (unboxed).
qequal=: 3 : 0
I. (y -: {&nub)"0 dat
)
qnotequal=: qnot@:qequal

qin=: 3 : 0
> qor&.>/ <@qequal"_1 y
)
qnotin=: qnot@:qin

qlike=: 3 : 0
  noRE =. 'invalid handle'
  y=. rxcomp :: (noRE"_) y
  if. noRE -: y do.
    throw '101 Invalid regular expression, ',rxerror''
  end.
  matches =. I. (y (_1<{.@,@rxmatch) {&nub)"0 dat
  matches [ rxfree y
)

NB. For columns
qequalc=: 3 : 0
  I. dat ({&nub@[ -: {&nub__y@])"0 dat__y
)

qequalf=: 2 : 0
  I. (u{dat) ({&nub@[ -: {&nub__y@])"0 v{dat__y
)
