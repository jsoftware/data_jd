NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

jd_tableinsert=: 3 : 0
y=. ca y
ECOUNT assert 2 3 e.~#y
'snkt srct srcdb'=. y
NB. 'srcdb same as snkdb' assert -.DB-:&filecase_j_ srcdb
d=. getdb''
snktloc=. getloc__d snkt
a=. jdcols snkt
snkcs=. {:"1 a
snkns=. {."1 a
db=. DB
try.
 jdaccess srcdb NB. possible security implication
 d=. getdb''
 a=. jdcols srct
 srccs=. {:"1 a
 srcns=. {."1 a
 srctloc=. getloc__d srct
 new=. Tlen__srctloc
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.
jdaccess db
t=. snkns-.srcns
if. #t do. throw 'required cols missing in src: ',;' ',each t end.
for_i. i.#snkns do.
 a=. i{snkcs
 b=. i{srccs
 assert NAME__a-:NAME__b
 assert typ__a-:typ__b
 assert shape__a-:shape__b
 
 getloc__snktloc NAME__a NB. make sure col is mapped
 getloc__srctloc NAME__b  NB. make sure col is mapped
 
 assert (}.$dat__a)-:}.$dat__b
end.
update_subscr__snktloc'' NB. mark ref dirty
setTlen__snktloc new+Tlen__snktloc
for_i. i.#snkns do.
 a=. i{snkcs
 b=. i{srccs
 if. 'varbyte'-:typ__a do.
   v=. 0,~#val__a 
  'val' appendmap__a val__b
  'dat' appendmap__a v+"1 dat__b
 else.
  'dat' appendmap__a dat__b
 end. 
end.
JDOK
)

jd_tablecopy=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'snk src srcdb'=. y
'srcdb same as snkdb' assert -.DB-:&filecase_j_ srcdb
snkpath=. jpath(dbpath DB),'/',snk
assert 0=#1!:0<jpath snkpath['snk table already exists'

db=. DB
try.
 jdaccess srcdb NB. possible security implication
 srcpath=. jpath(dbpath DB),'/',src
 assert 'table'-:jdfread srcpath,'/jdclass'
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
snkpath=. '"',snkpath,'"'
srcpath=. '"',srcpath,'"'
jd_close''
if. IFWIN do.
 r=. shell 'robocopy ',(hostpathsep srcpath),' ',(hostpathsep snkpath),' *.* /E'
 if. +/'ERROR' E. r do.
  smoutput r 
  assert 0['robocopy failed'
 end.
else.
 shell 'cp -r ',srcpath,' ',snkpath
end.
assert (2=ftypex) snkpath-.'"'['tablecopy failed'
JDOK
)

jd_tablemove=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'snk src srcdb'=. y
'srcdb same as snkdb' assert -.DB-:&filecase_j_ srcdb
snkpath=. jpath(dbpath DB),'/',snk
assert 0=#1!:0<jpath snkpath['snk table already exists'

db=. DB
try.
 jdaccess srcdb NB. possible security implication
 srcpath=. jpath(dbpath DB),'/',src
 assert 'table'-:jdfread srcpath,'/jdclass'
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
jd_close'' NB. does not release lock
assert 1=snkpath frename srcpath['frename failed'
JDOK
)