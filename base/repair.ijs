NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jd'

0 : 0
mark refs dirty
make cols all match Tlen
varbyte special treatment - pad with 0 0 or with total,0 ???
)

jdfix=: 3 : 0
n=. y-.' '
assert 0~:#y
d=. jd'info validatebad ',n
({.d)=. {:d
for_i. i.#column do.
 c=. jdgl n,' ',i{column
 do xp'c'
 
 shape=. ".1{jdshape
 do xp'shape'
 
 dat__c=: shape{.dat__c
end.
)