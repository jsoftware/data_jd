NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. setscriptlists creates/runs script to create tests/tuts script lists
NB. tests and tuts scripts to define script lists
NB. leading digits in folders and files set order
NB. 999_ guys are sorted by name
NB. tut names must be unique
setscriptlists=: 3 : 0
NB. tests
p=. jpath'~/gitdev/addons/data/jd/'
t=. 1 dir p,'test/*_test.ijs'
t=. /:~(#p)}.each t
t=. ;t,each LF
t=. 'tests=: <;._2 [ 0 : 0',LF,t,')'
f=. JDP,'base/tests.ijs'
t fwrite f
load f

NB. tuts
d=. {."1 dirtree JDP,'tutorial'

NB. fix order - guys that don't sort where we want them
zd=. d rplc each <'basic-epochdt_tut.ijs';'basic-zepochdt_tut.ijs'
zd=. zd rplc each <'basic-admin_tut.ijs';'basic-zzadmin_tut.ijs'

d=. d/:_8}.each zd
d=. (#JDP,'tutorial/')}.each d

d=. ;LF,~each d
t=. 'tuts=: <;._2 [ 0 : 0',LF,d,')'
f=. JDP,'base/tuts.ijs'
t fwrite f
load f
)