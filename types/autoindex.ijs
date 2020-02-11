NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtindex'
coclass deftype_jdtint_ 'autoindex'

STATE=: ;:'typ'
makecolfiles=: writestate
shape=: ''

visible =: 0
MAP =: 0$a:

countdat=: 3 : 'Tlen'
select =: ]

NB. read jdindex from part table returns index to full table
NB. read jdindex from f~2015 returns index to just that table
NB. index to full partition table, not just the sub table
select=: 3 : 0
if. -.OP-:'readptable' do. y return. end.
n=. NAME__PARENT
i=. n i. PTM
p=. i{.n
'parts tlens'=. getparts p
i=. parts i. <}.i}.n
y++/i{.tlens
)

defquery =: 3 : 0
template =. 'name =: 3 : ''(i.Tlen) I.@:(func"_1 _) y'''
template =. template;'namec =: 3 : ''Tlen I.@:(func"_1)&i. Tlen__y'''
template =. template,<'namef =: 2 : ''u I.@:(func"_1) v [ y'''
".&.> template rplc&.> <('name';'func') ,@,. y
EMPTY
)
defqueries 0 :0
qequal        =
qnotequal     ~:
qin           e.
qnotin        -.@e.
qless         <
qlessequal    <:
qgreater      >
qgreaterequal >:
)

qequalc =: qinc =: 3 : 'i. Tlen <. Tlen__y'

qequal=: 3 : 0
dat=. (getbase'')+i.Tlen
dat I.@:(-:"_1 _) y
)

qin=: 3 : 0
dat=. (getbase'')+i.Tlen
dat I.@:(e."_1 _) y
)

NB. same routine as in numeric.ijs
qrange=: 3 : 0
dat=. (getbase'')+i.Tlen
y=. y, (2|#y)#IMAX NB. odd extends last range to end
r=. (dat>:{.y)*.dat<:1{y
y=. 2}.y
while. #y do.
 r=. r+.(dat>:{.y)*.dat<:1{y
 y=. 2}.y
end.
I.r
)

qless=: 3 : 0
dat=. (getbase'')+i.Tlen
dat I.@:(<"_1 _) y
)

qlessequal=: 3 : 0
dat=. (getbase'')+i.Tlen
dat I.@:(<:"_1 _) y
)

qgreater=: 3 : 0
dat=. (getbase'')+i.Tlen
dat I.@:(>"_1 _) y
)

qgreaterequal=: 3 : 0
dat=. (getbase'')+i.Tlen
dat I.@:(>:"_1 _) y
)

getbase=: 3 : 0
if. PTM e.NAME__PARENT do.
 n=. NAME__PARENT
 i=. n i. PTM
 p=. i{.n
 'parts tlens'=. getparts p
 i=. parts i. <}.i}.n
 +/i{.tlens
else.
 0
end.
)

