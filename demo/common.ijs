NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. demo common

builddemo=: 3 : 0
jdadminx y
CSVFOLDER=: '~addons/data/jd/demo/',y,'/csv'
jd'csvrestore'
jd'loadcustom'
jd'createdynamic'

jdadminx y,'_shuffle'
CSVFOLDER=: '~addons/data/jd/demo/',y,'/csv'
jd'csvrestore'
jd'loadcustom'
jd'createdynamic'
jdshuffle_jd_ each {."1 jdtables_jd_''
)

0 : 0 NB. old ref stuff
jdadminx y,'_ref'
CSVFOLDER=: '~addons/data/jd/demo/',y,'/csv'
jd'csvrestore'
f=. '~temp/jd/',y,'_ref/custom.ijs'
d=. fread f 
(d rplc 'reference';'ref')fwrite f
jd'loadcustom'
jd'createdynamic'
)

setdemodb=: 3 : 0
if. -.(<DB_jd_)e.y;y,'_reference' do. jdadmin y end.
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

fixr=: 4 : 0
x;~,x{.><;._1 ' ',deb y
)

drd=: 3 : 0
R=: jd 'reads ',y
)
