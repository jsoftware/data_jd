NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. setscriptlists creates/runs script to create tests/tuts script lists

setscriptlists=: 3 : 0
p=. jpath'~/gitdev/addons/data/jd/'
t=. 1 dir p,'test/*_test.ijs'
t=. /:~(#p)}.each t
t=. ;t,each LF
tsts=. 'tests=: <;._2 [ 0 : 0',LF,t,')'

t=. 1 dir p,'tutorial/*_tut.ijs'
t=. /:~(#p)}.each t
t=. ;t,each LF
tuts=. 'tuts=: <;._2 [ 0 : 0',LF,t,')'

t=. toJ 'NB. Copyright 2017, Jsoftware Inc.  All rights reserved.',LF,'coclass''jd''',LF,tsts,LF,tuts
t fwrite p,'base/scriptlists.ijs'
load p,'base/scriptlists.ijs'
)
