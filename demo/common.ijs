NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. demo common

builddemo=: 3 : 0
jd'close' NB. avoid file handle limit problem
jdadminx y
CSVFOLDER=: JDP,'demo/',y,'/csv'
jd'csvrestore'
jd'close' NB. avoid file handle limit problems

jdadminx y,'_shuffle'
CSVFOLDER=: JDP,'demo/',y,'/csv'
jd'csvrestore'
jdshuffle_jd_ each {."1 jdtables_jd_''
jd'close' NB. avoid file handle limit problems
)

dassert=: 3 : 0
'col val shape'=. y
i=.({.R)i.<col
if. i={:$R do. assert 0[smoutput 'bad col: ',col end.
d=. >i{"1{:R
if. -.shape-:$d do.
 smoutput 'bad shape: ',col,' ',":$d
 smoutput ,d
 assert 0
end. 
d=. ,d
if. val-:(#val){.d do. i.0 0 return. end.
smoutput 'bad value: ',col
smoutput val
smoutput d
assert 0
)

drd=: 3 : 0
R=: jd 'reads ',y
ALLR=: ALLR,<R
R
)
