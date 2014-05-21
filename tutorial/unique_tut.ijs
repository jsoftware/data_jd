NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. createunique creates hash on 1 or more cols
NB. similar to hash except there is no link as there duplicates are not allowed
NB. a unique col can be used in a reference
NB. createunique signals error if not unique
NB. subsequent inserts/updates signal error if no unique

er=. 'not unique - ('

NB. createunique on an empty col
jdadminx'test'
jd'createtable g a int'
jd'createunique g a'
jd'insert g a';i.5
jd etx'insert g a';2
assert er-:(#er){.;1{jdlast

NB. createunique on an existing col
jdadminx'test'
jd'createtable g a int'
jd'insert g a';i.5
jd'createunique g a'
jd etx'insert g a';2
assert er-:(#er){.;1{jdlast

NB. createunique on existing col that isn't unique
jdadminx'test'
jd'createtable g a int'
jd'insert g a';2,i.5
jd etx 'createunique g a'
assert 'not unique'-:10{.;1{jdlast

NB. createunique can be done on multiple cols
jdadminx'test'
jd'createtable g a int,b byte'
jd'createunique g a b'
jd'insert g';'a';1 2 3;'b';'abc'
jd etx'insert g';'a';4 2;'b';'db'
assert er-:(#er){.;1{jdlast





