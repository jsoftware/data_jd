NB. Copyright 2017, Jsoftware Inc.  All rights reserved.
coclass 'jdtnumeric'
coinsert 'jdtbase'

DATAFILL=: -~2
DATASIZE=: 8
datcount=: ]

qnumtxt=: 0 : 0
qless         =: 3 : 'I.dat <  y'
qlessequal    =: 3 : 'I.dat <: y'
qequal        =: 3 : 'I.dat =  y'
qnotequal     =: 3 : 'I.dat ~: y'
qgreaterequal =: 3 : 'I.dat >: y'
qgreater      =: 3 : 'I.dat >  y'
qin           =: 3 : 'I.dat e. y'
qnotin        =: 3 : 'I.-.dat e. y'
qsample       =: 3 : 'y?Tlen'
qSample       =: 3 : 'y?.Tlen'
)

qrangetxt=: 0 : 0
y=. y, (2|#y)#IMAX NB. odd extends last range to end
r=. (dat>:{.y)*.dat<:1{y
y=. 2}.y
while. #y do.
 r=. r+.(dat>:{.y)*.dat<:1{y
 y=. 2}.y
end.
I.r
)

NB. qlike/qunlike inherited from base
NB. i1/i2/i4 qlike/qunlike assert error

". each <;._2 qnumtxt
qrange=: 3 : qrangetxt 

fixtype=: [: ,@boxopen fixtype_num

fixtypex=: fixtype_num

fixtype_num=: 3 : 0
if. 4 ~: 3!:0 y do.
 a=. y
 y=. 0+<. :: 0: y
 EINT assert a-:y
end.
y
)

ifromi1=: 3 : 'n-(n<128){256 0[n=. a.i.y'
ifromi2=: 3 : '_1 ic y'
ifromi4=: 3 : '_2 ic y'


coclass deftype_jdtnumeric_ 'boolean'
DATAFILL=: 0
DATASIZE=: 1
fixtype_num=: 3 : 0
if. 1 ~: 3!:0 y do.
 a=. y
 y=. 0 ~: y
 EBOOLEAN assert a-:y
end.
y
)

NB.int =========================================================
coclass deftype_jdtnumeric_ 'int'

NB. int1 =========================================================
coclass deftype_jdtnumeric_ 'int1'
DATASIZE=: 1

i1fromi=: 3 : '((2*#y)$;ifintel{0 1;1 0)#1 ic y'

". each <;._2 qnumtxt  rplc 'dat';'(ifromi1 dat)'
qrange=: 3 : (qrangetxt rplc 'dat';'(ifromi1 dat)')
qlike=: qunlike=: qlikeci=: qunlikeci=: 3 : '''like/unlike/unlike/unlikeci not supported for intx''assert 0'

fixtypex=: 3 : 0
a=. fixtype_num y
EINT1 assert (a<2^7),a>:-2^7
a
)

fixinsert=: i1fromi

NB. note special code for join with empty table
select=: 3 : 0
if. (0=#dat)*.0~:#y do.
 y{(1,shape)$DATAFILL
else.
 ifromi1 y{dat
end.
) 

modify=: 4 : 0
if. (<NAME)e.;{:"1 SUBSCR__PARENT do. update_subscr__PARENT <NAME end. NB. mark ref dirty if required
dat=: (fixinsert y) x} dat
)

NB. int2 =========================================================
coclass deftype_jdtnumeric_ 'int2'
DATASIZE=: 2
countdat=: 3 : '-:@#dat'
datcount=: +:

". each <;._2 qnumtxt  rplc 'dat';'(_1 ic dat)'
qrange=: 3 : (qrangetxt rplc 'dat';'(_1 ic dat)')
qlike=: qunlike=: qlikeci=: qunlikeci=: 3 : '''like/unlike/unlike/unlikeci not supported for intx''assert 0'

fixtypex=: 3 : 0
a=. fixtype_num y
EINT2 assert (a<2^15),a>:-2^15
a
)

fixinsert=: 3 : '1 ic y'

NB. note special code for join with empty table
select=: 3 : 0
if. (0=#dat)*.0~:#y do.
 y{(1,shape)$DATAFILL
else.
 ifromi2 ,(,(2*y),.1+2*y){dat
end.
)

modify=: 4 : 0
if. (<NAME)e.;{:"1 SUBSCR__PARENT do. update_subscr__PARENT <NAME end. NB. mark ref dirty if required
dat=: (fixinsert y) ((,(2*x),.1+2*x))} dat
)


NB. int4 =========================================================
coclass deftype_jdtnumeric_ 'int4'
DATASIZE=: 4
countdat=: 3 : '-:@-:@#dat'
datcount=: +:@+:

". each <;._2 qnumtxt  rplc 'dat';'(_2 ic dat)'
qrange=: 3 : (qrangetxt rplc 'dat';'(_2 ic dat)')
qlike=: qunlike=: qlikeci=: qunlikeci=: 3 : '''like/unlike/unlike/unlikeci not supported for intx''assert 0'

fixtypex=: 3 : 0
a=. fixtype_num y
EINT4 assert (a<2^31),a>:-2^31
a
)

fixinsert=: 3 : '2 ic y'

NB. note special code for join with empty table
select=: 3 : 0
if. (0=#dat)*.0~:#y do.
y{(1,shape)$DATAFILL
else.
 ifromi4 ,(,(4*y)+"0 1 i.4){dat
end.
) 

modify=: 4 : 0
if. (<NAME)e.;{:"1 SUBSCR__PARENT do. update_subscr__PARENT <NAME end. NB. mark ref dirty if required
dat=: (fixinsert y) ((,(4*x)+"0 1 i.4))} dat
)

NB. index =========================================================
coclass deftype 'index'
DATAFILL=: _1

NB. float =========================================================
coclass deftype_jdtnumeric_ 'float'
DATASIZE=: 8
DATAFILL=: -~2.1

fixtype_num=: 3 : 0
if. 8 ~: 3!:0 y do.
 EFLOAT assert (3!:0 y) e. 1 4
  y=. y + -~ 2.1
end.
y
)
