NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. common ref/reference test utilities - used in api_xxx_ref.ijs

ti=: 3 : 0
jdadminx'test'
)

tc=: 4 : 0
jd'droptable';x
jd'createtable';x;'a int'
jd'insert';x;'a';y
)

tref=: 3 : 0
jd REF,' f a g a'
)

trd=: 3 : 0
;{:{:jd'read f.a from f,f.g'
)

tdata=: 3 : 0
{:"1 jd'read from f,f.g'
)

tsee=: 3 : 0
smoutput jd'read from f'
smoutput jd'read from g'
smoutput jd'read from f,f=g'
)
