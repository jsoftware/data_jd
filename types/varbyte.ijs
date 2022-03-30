NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtbase'
coclass deftype 'varbyte'

MAP =: ;:'dat val'

makecolfiles=: 3 : 0
('int';shape,2) makecolfile 'dat'
('byte'; $0   ) makecolfile 'val'
writestate''
)

DATAFILL=: <''

fixtype=: 3 : 0
y =. boxopen y
throwif 1 < L. y
  if. (2 *./@:= 3!:0@>) y do.
    if. +./(1 < #@$)@> y do. throw 'jde: (COL) varbyte data item must be scalar or list'rplc'COL';NAME end.
    shp=. 1:`$@.(0~:#@$) y
    y=. ((($$+/\@:(_1&(|.!.0))@,) ,"0 ])@:(#@>) ; ;@,) ,y
    y=. (((shp&$)&.>)@{.,{:) y
  end.
y
)

fixtext=: fixstring_jdcolumn_

fixinsert=: 3 : 0
((0,~#val)&+"1&.>@{. , {:) y
)

fixtypex=: 3 : 0
ETYPE assert 1=L. y
ETYPE assert 2=;3!:0 each y
ETYPE assert 2>;$@:$each y
y
)

Revert=: 3 : 0
if. y>:#dat do. return. end.
NB. val =: ({.@, y{dat) {. val
val =: val{.~ +/dat{~ (i. >./) y{. {."1 dat  NB. max starting position after update
dat =: y{.dat
)

NB. note special code for join with empty table
select=: 3 : 0
if. (0=#dat)*.0~:#y do.
 <@:({&val)@:(+i.)/"1 y{(1,2)$0
else.
NB.  <@:({&val)@:(+i.)/"1 y{dat
 val (<;.0~ ,."1) y{dat
end.
)

NB. done in place if it fits, otherwise appended to end
modify=: 4 : 0
for_n. i.#x do.
 i=. n{x
 'j k'=. i{dat
 if. 1=#y do.
  d=. ;{.y NB. scalar extension
 else. 
  d=. ;n{y
 end. 
 if. k>:#;d do.
  dat=: (j,#d) i}dat 
  val=: d (j+i.#d)}val
 else.
  dat=: ((#val),#d) i}dat
  appendval d
 end.
end. 
)

NB. Primitive where queries
NB. y is data to test against (boxed).

NB. all varbyte queries are done in C
NB.  col  eq/ne       data
NB.  col  in/notin    (a,b,d)
NB.  col  like/unlike regexp
NB.  col1 eq/ne col2 
NB.  col1 eq/ne foreign col

varbyte=: LIBJD_jd_,' varbyte > x x x x x x x x x x x' NB. jdt


NB. dat val y 0    0    0 0
NB. dat val 0 daty valy 0 0
NB. dat val 0 daty valy u v
NB.! BC global arg ugly
callit=: 4 : 0
b=. BC#0
r=. varbyte cd JDT,x,(memhad'b'),y
if. 0~:r do. throw 'C varbyte failed with code ',":r end.
I.b
)

call=: 4 : 0
BC=: #dat
if. 0=L.y do. y=. y,{.a. end. NB. regex needs trailing null
x callit (memhad'dat'),(memhad'val'),(memhad'y'),0,0,0,0
)

callc=: 4 : 0
BC=: #dat
x callit (memhad'dat'),(memhad'val'),0,(memhad'dat__y'),(memhad'val__y'),0,0
)

qequal=:     1&call
qnotequal=:  0&call
qin=:        1&call
qnotin=:     0&call
qlike=:      1&call
qlikeci=:    3&call
qunlike=:    0&call
qunlikeci=:  2&call

qequalc=:    1&callc
qnotequalc=: 0&callc

NB. column eq foreign column
qequalf=: 2 : 0
y NB. necessary to enable explicit use of y u v
u
v
BC=: #u
1 callit (memhad'dat'),(memhad'val'),0,(memhad'dat__y'),(memhad'val__y'),(memhad'u'),memhad'v'
)

NB. column ne foreign column
qnotequalf=: 2 : 0
y NB. necessary to enable explicit use of y u v
u
v
BC=: #u
0 callit (memhad'dat'),(memhad'val'),0,(memhad'dat__y'),(memhad'val__y'),(memhad'u'),memhad'v'
)
