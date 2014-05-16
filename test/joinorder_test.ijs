NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that joins are performed in an optimal order

require '~addons/data/jd/test/core/utilref.ijs'

NB. y is a list of boxed integer lists.
NB. For each make a table with the list in column a, and link them in order.
NB. Table names are f,g,...
tcs =: 3 : 0
jdadminx'test'
getname =. a.{~ (a.i.'f')&+
for_i. i.#y do.
  (getname i) tc i{::y
  if. i>0 do. jd 'reference ',;:^:_1 , (getname&.> (,~<:)i),.<'a' end.
end.
)

sp =: [: 7!:2@> ('';'exact ') ('jd ',[:quote'read from ',,)&.> <

tcs 3#<2#i.1e4
assert 4 < %~/ sp 'f,f-g,g-h where h.a<100'
NB. assert 10< %~/ sp 'f,f.g,g.h where h.a<100'
assert 6< %~/ sp 'f,f.g,g.h where h.a<100'

tcs 500 10 1 #&.> 3#<i.10
assert 2 < %~/ sp 'f,f-g,g-h where h.a=0'
