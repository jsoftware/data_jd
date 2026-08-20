NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

NB. tests that might help understand join types and how they work

bld=: 3 : 0
d=. i.3
'new'jdadmin'join'
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';>:d,d
jd'createtable g'
jd'createcol g b int'
jd'insert g';'b';>:i.3
)

show=: 3 : 0
c=. jdgl_jd_ 'f jdref_a_g_b'
if. 2=#dat__c do.
end.
i.0 0
)

bld''
jd'ref f a g b'
show''

jd'insert f';'a';4
show''

jd'insert g';'b';5
show''

jd'insert f';'a';5
show''

bld''
jd'ref /left f a g b'

show''

jd'insert f';'a';4
show''

jd'insert g';'b';5
show''


