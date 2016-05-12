NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass'jd'

JDTIMING=: 1 NB. avoid errors on timing tests - set 0 to check timings

NB. setscriptlists creates/runs script to create tests/tuts script lists

NB. y ''                      run csv-tests, build-demos, and all tests and tutorials
NB. y 'fast'                  skip csv-tests and build-demos
NB. y 'csv'                   run just csv-tests
NB. x 0 or elided             do not echo test scripts as they are run
NB. x 1                       echo test scripts as they are run
jdtests=: 3 : 0
0 jdtests y
:
NB. assert -.(<'jjd')e. conl 0['jdtests must be run in task that is not acting as a server'
cocurrent'base' NB. defined in jd, but must run in base
OLDFLUSHAUTO_jd_=: FLUSHAUTO_jd_
FLUSHAUTO_jd_=: 0 NB. tests run more than 2 times slower with flush
OLDALLOC_jd_=: ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: 4 1 0 NB. lots of resizecsvonly=. 'csv'-:y
fast=. 'fast'-:y
csvonly=. 'csv'-:y
t=. ALLTESTS=:  tests_jd_,tuts_jd_,demos_jd_
if. fast do. t=. t-.'test/dynamic_test.ijs';'tutorial/unique_tut.ijs' end. NB. remove slow tests
t=. t,~each<JDP
if. -.IFJHS do. t=. t-.<JDP,'tutorial/server_tut.ijs' end.
failed=: ''
jdt=: i.0 2
'test start'logjd_jd_''
if. csvonly+.-.fast do.
 start=. 6!:1''
 jd'option sort 1' NB. sort required for now
 jda=. 6!:1''
 load JDP,'csv/csvtest.ijs'
 RESIZESTRESS_jdcsv_=: 0
 tests''
 RESIZESTRESS_jdcsv_=: 1
 tests''
 RESIZESTRESS_jdcsv_=: 0
 jdt=: jdt,(jda-~6!:1'');'csv tests'
 jd'option sort 0'
 echo (":<.start-~6!:1''),' seconds to run csv tests'
end. 
if. csvonly do.
 FLUSHAUTO_jd_=: OLDFLUSHAUTO_jd_ 
 'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: OLDALLOC_jd_
 i.0 0
 return.
end.
load JDP,'demo/common.ijs'
if. -.fast  do.
 start=. 6!:1''
 jda=. 6!:1''
 builddemo'northwind'
 builddemo'sandp'
 builddemo'sed'
 jdt=: jdt,(jda-~6!:1'');'build demos'
 echo (":<.start-~6!:1''),' seconds to build demos'
end. 
jdserverstop_jd_''
jd'close'
jdadmin 0
start=. 6!:1''
for_n. i.#t do.
 a=. n{t
 'test file'logjd_jd_ (#JDP_jd_)}.;a
 jda=. 6!:1''
 if. x do. echo 'loadd''','''',~;a end.
 try.
  load a
 catch.
  'failed'logjd_jd_ LF,13!:12''
  echo LF,('failed: ',;n{t),LF,13!:12''
  failed=: failed,a
 end.
 jdt=: jdt,(jda-~6!:1'');;a
end.
jdserverstop_jd_''
jd'close'
jdadmin 0
failedx=: >LF,~each(<'loadd'''),each failed,each<''''
if. #failed do.
 echo LF,'following tests failed:'
 echo failedx
end.
if. #conl 1 do.
 echo LF,'check for orphan locals in conl 1'  
end.
echo LF,(":#t),' tests run',LF,(":#failed),' failed'
jdt=: (\:;{."1 jdt){jdt
FLUSHAUTO_jd_=: OLDFLUSHAUTO_jd_ 
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: OLDALLOC_jd_
echo LF,(":<.start-~6!:1''),' seconds to run tests and tutorials'
(;{:jd'list version')fwrite'~temp/jd/jdversion' NB. avoid welcome
'test end'logjd_jd_''
i.0 0
)

jd_testerrors=: 3 : 0
select. y
case. 'best'  do. ('table * does not have col *'erf'abc';'def')assert 0
case. 'bare'  do. assert 0
case. 'right' do. assert 0['simple assert right'
case. 'left'  do. 'simple assert left'assert 0
case. 'leftx' do. ('formatted assert X on left'rplc'X';'88')assert 0
case. 'throw' do. throw 'thrown X'rplc'X';'999'
case. 'plain' do. 1+'a'
end.
)

jdtesterrors=: 3 : 0
jdadminx'test'
t=. 'best';'bare';'right';'left';'leftx';'throw';'plain'
for_n. t do.
 n=. >n
 try. 
  jd'testerrors ',n
 catch.
  t=. LASTRAW_jd_
  t=. dltb each }.each<;._2 t
  v=. >{.t
  if. 'assertion failure: assert'-:v do.
   r=. >1{t
   if. ''''={:r do.
    r=. }:r
    r=. r rplc '''''';{.a.
    i=. r i: ''''
    r=. }.i}.r
    r=. r rplc ({.a.);''''
   end.
  elseif. ': assert'-:_8{.v do.
   r=. _8}.v
  elseif. ': throw'-:_7 {.v do.
   r=. _7}.v
  elseif. 1 do.
   r=. ;  ( {.t) ,(<': '), }.t
  end.
  echo r
 end.
end. 
)

setscriptlists=: 3 : 0
p=. jpath'~/gitdev/addons/data/jd/'
t=. 1 dir p,'test/*_test.ijs'
t=. /:~(#p)}.each t
t=. 'test/core/testall.ijs';t
t=. ;t,each LF
tsts=. 'tests=: <;._2 [ 0 : 0',LF,t,')'

t=. 1 dir p,'tutorial/*_tut.ijs'
t=. /:~(#p)}.each t
t=. ;t,each LF
tuts=. 'tuts=: <;._2 [ 0 : 0',LF,t,')'

t=. toCRLF 'NB. Copyright 2015, Jsoftware Inc.  All rights reserved.',LF,'coclass''jd''',LF,tsts,LF,tuts
t fwrite p,'base/scriptlists.ijs'
load p,'base/scriptlists.ijs'
)
