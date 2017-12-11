NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtnumeric'
coinsert 'jdtbase'

defqueries 0 :0
qless         <
qlessequal    <:
qgreater      >
qgreaterequal >:
)

qrange=: 3 : 0
y=. y, (2|#y)#imax NB. odd extends last range to end
r=. (dat>:{.y)*.dat<:1{y
y=. 2}.y
while. #y do.
 r=. r+.(dat>:{.y)*.dat<:1{y
 y=. 2}.y
end.
I.r
)

fixtype=: [: ,@boxopen fixtype_num

fixtypex=: fixtype_num

NB. =========================================================
coclass deftype_jdtnumeric_ 'boolean'
DATAFILL=: 0
DATASIZE=: 1
fixtype_num=: 3 : 0
  if. 1 ~: 3!:0 y do.
    NB. following line triggered 806 avx bug
    NB. throwif -. y *./@:e. 0 1
    NB. but it seems more complicated than needed and is replaced by the following
    a=. y
    y =. 0 ~: y
    throwif -.a-:y
  end. y
)

NB. =========================================================
coclass deftype_jdtnumeric_ 'int'
DATAFILL=: -~2
DATASIZE=: 8
fixtype_num=: 3 : 0
  if. 4 ~: 3!:0 y do.
    throwif y -.@-: int=. <. :: 0: y
    y=. int + -~ 2
    throwif 4 ~: 3!:0 y
  end. y
)

NB. =========================================================
coclass deftype 'index'
DATAFILL=: _1

NB. =========================================================
coclass deftype_jdtnumeric_ 'float'
DATASIZE=: 8
DATAFILL=: -~2.1
fixtype_num=: 3 : 0
  if. 8 ~: 3!:0 y do.
    throwif -. (3!:0 y) e. 1 4
    y=. y + -~ 2.1
  end. y
)
