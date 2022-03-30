NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that joins are performed in an optimal order

0 : 0
this test has serious problems
ref /left join does not work with 3 tables
 f,f.g,g.h - fails
 f,f-g,g-h - fails
joinorder stuff doesn't seem to give any real benefit
)

tc=: 4 : 0
jd'droptable';x
jd'createtable';x;'a int'
jd'insert';x;'a';y
)

NB. y is a list of boxed integer lists.
NB. For each make a table with the list in column a, and link them in order.
NB. Table names are f,g,...
tcs =: 3 : 0
jdadminx'test'
getname =. a.{~ (a.i.'f')&+
for_i. i.#y do.
  (getname i) tc i{::y
  if. i>0 do. jd 'ref ',;:^:_1 , (getname&.> (,~<:)i),.<'a' end.
end.
)

spjoin =: [: 7!:2@> (' ';'exact ') ('jd ',[:quote'read from ',,)&.> <

tcs 3#<2#i.1e4
NB. assert 4 < %~/ spjoin 'f,f.g,g.h where h.a<100'
NB. assert 10< %~/ spjoin 'f,f.g,g.h where h.a<100'
NB. assert 6< %~/  spjoin 'f,f.g,g.h where h.a<100'
NB. assert 4 < %~/ spjoin 'f,f-g,g-h where h.a<100'
NB. assert 10< %~/ spjoin 'f,f-g,g-h where h.a<100'
NB. assert 6< %~/  spjoin 'f,f-g,g-h where h.a<100'

tcs 500 10 1 #&.> 3#<i.10
NB. assert 2 < %~/ spjoin 'f,f-g,g-h where h.a=0'
