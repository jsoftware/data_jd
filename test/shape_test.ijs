NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. shape tests for insert/update/modify

ED=: 'domain error'

init=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f w  int'
jd'createcol f i  int'
jd'createcol f i2 int  2'
jd'createcol f b  byte'
jd'createcol f b2 byte 2'
jd'insert f';'w';0 1 2;'i';0 0 0;'i2';(3 2$0);'b';'abc';'b2';3 2$'aabbcc'
)

init''

NB. shape rules are the same for insert and update

NB. update 1 row
jd'update f';'w=0';'i';23;'i2';(1 2$23 23);'b';'x';'b2';1 2$'xx'       NB. exact shape
assert ED-:jd etx 'update f';'w=0';'i';23;'i2';23 23;'b';'x';'b2';'xx' NB. item not extended

NB. update 2 rows
jd'update f';'w ne 0';'i';23 24;'i2';(i.2 2);'b';'qw';'b2';2 2$'mnop' NB.exact shape
jd'update f';'w ne 0';'i';23 24;'i2';(2 2$25);'b';'qw';'b2';2 1$'x'       NB. byte {. last dimension
assert ED-:jd etx'update f';'w ne 0';'i';23 24;'i2';(2 1$25);'b';'qw';'b2';2 1$'x' NB. int {. last dimension fails


NB.modify shape rules similar to update but allow item to extend

NB. modify  1 row
jd'modify f';'w=0';'i';23;'i2';(1 2$23 23);'b';'x';'b2';1 2$'xx' NB. exact shape
jd'modify f';'w=0';'i';23;'i2';23 23;'b';'x';'b2';'xx'           NB. item extends

NB. update 2 rows
jd'modify f';'w ne 0';'i';27 28;'i2';(10+i.2 2);'b';'we';'b2';2 2$'poiu' NB.exact shape
jd'modify f';'w ne 0';'i';29;'i2';23 23;'b';'x';'b2';'xx'                 NB. item extends
jd'modify f';'w ne 0';'i';23 24;'i2';(2 2$25);'b';'qw';'b2';2 1$'x'       NB. byte {. last dimension
assert ED-:jd etx'update f';'w ne 0';'i';23 24;'i2';(2 1$25);'b';'qw';'b2';2 1$'x' NB. int {. last dimension fails
