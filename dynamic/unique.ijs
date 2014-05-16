NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtunique'
coinsert 'jdthash'

typ =: 'unique'
MAP =: ;:'hash'
unique =: 1

NB. 1
xxxTestInsert =: 3 : 0
y =. >;1{::y
NB. TODO performance?
if. 0 e. ~:y do. throw 'Inserted items are not unique' end.
if. _1 +./@:~: index"0 y do. throw 'Inserted items are not unique' end.
)

NB. does not work - i not defined - off not used - never tested
NB. intended to revert unique col after insert/update fails
Revert=: 3 : 0
if. y >: >./hash do. return. end.
off=.0
for_h. hash do.
  if. y<:h do.
    off =. off + 1
    hash =: _1 h_index} hash
  elseif. _1<h do.
    off =. h_index  -  (#hash) | combinedhash select h
    hash =: (h,_1) (i,h_index)} hash
  elseif. do.
    off =. 0
  end.
end.
NB. link =: y{.link !!! ebi - unique does not have link !!!
)


lookup =: index
