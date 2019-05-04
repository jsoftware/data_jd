NB. Copyright 2019 Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. setscriptlists creates/runs script to create tests/tuts script lists
NB. tests and tuts scripts to define script lists
NB. leading digits in folders and files set order
NB. 999_ guys are sorted by name
NB. tut names must be unique
setscriptlists=: 3 : 0
NB. tests
p=. JDP
t=. 1 dir p,'test/*_test.ijs'
t=. /:~(#p)}.each t
t=. ;t,each LF
t=. 'tests=: <;._2 [ 0 : 0',LF,t,')'
f=. JDP,'base/tests.ijs'
t fwrite f
load f

NB. tuts
t=. 1 dir p,'tutorial/*_tut.ijs'
t=. /:~(#p)}.each t
t=. ;t,each LF
t=. 'testtuts=: <;._2 [ 0 : 0',LF,t,')'
f=. JDP,'base/testtuts.ijs'
t fwrite f
load f

tutchk''
)

tutcats=: 3 : 0
load JDP,'tools/tut.ijs'
a=. ;(' '=each tuts)i.each 0
>(a<}.a,0)#tuts
)

tutchk=: 3 : 0
load JDP,'tools/tut.ijs'
a=. ;(' '=each tuts)i.each 0
t=. (a>:}.a,0)#tuts
t=. dltb each t
f=. 1 dir'~Jddev/tutorial'
f=. _8}.each (>:;f i:each'/')}.each f
if. #t-.f do.
 echo 'tuts without files'
 echo >' ',each t-.f
end. 
if. #f-.t do. 
 echo 'files without tuts'
 echo >' ',each f-.t
end.
'tuts files mismatch'assert 0=#(f-.t),t-.f
'tuts duplicats'assert(#~.dltb each tuts_jd_)=#dltb each tuts_jd_
i.0 0
)
