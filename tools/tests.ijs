NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

coclass'jd'

JDTIMING=: 1 NB. avoid errors on timing tests - set 0 to check timings

NB. actions are logged to ~temp/jd.txt'
NB. y ''                      run csv-tests, build-demos, and all tests and tutorials
NB. y 'fast'                  skip csv-tests
NB. y 'csv'                   run just csv-tests
NB. x 0 or elided             do not echo test scripts as they are run
NB. x 1                       echo test scripts as they are run
jdtests=: 3 : 0
0 jdtests y
:
NB. assert -.(<'jjd')e. conl 0['jdtests must be run in task that is not acting as a server'
jdadmin 0
load JDP,'base/tests.ijs'
load JDP,'base/testtuts.ijs'
cocurrent'base' NB. defined in jd, but must run in base
IFTESTS_jd_=: 1
OLDALLOC_jd_=: ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: 4 1 0 NB. lots of resizecsvonly=. 'csv'-:y
OLDLOGOPS_jd_=: LOGOPS_jd_
fast=. 'fast'-:y
csvonly=. 'csv'-:y
EXCLUDETESTS=: (<'_tut.ijs'),each~(<'tutorial/'),each 'stock_data';'bus_lic';'taxi';'quandl_ibm';'jctask'
t=. ALLTESTS=:  (tests_jd_,(testtuts_jd_))-.EXCLUDETESTS
t=. t,~each<JDP
if. -.IFJHS do. t=. t-.<JDP,'tutorial/jhs_tut.ijs' end.
if. -.fexist'~addons/net/jcs/jcs.ijs' do. t=. t-.<JDP,'tutorial/jcs_tut.ijs' end. 
if. IFWINE do.   NB. blacklist tests failed on wine
 t=. t-.<JDP,'tutorial/jcs_tut.ijs'
 t=. t-.<JDP,'tutorial/link_tut.ijs'
 t=. t-.<JDP,'test/replicate_test.ijs'
 t=. t-.<JDP,'tutorial/replicate_tut.ijs'
end.
failed=: ''
jdt=: i.0 2
'test start'logtest_jd_''
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
 'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: OLDALLOC_jd_
 i.0 0
 return.
end.
jddeletefolder_jd_'~temp/jd/northwind'
builddemos_jd_''
jdserverstop_jd_''
jd'close'
jdadmin 0
start=. 6!:1''
for_n. i.#t do.
 a=. n{t
 'test file'logtest_jd_ (#JDP)}.;a
 jda=. 6!:1''
 if. x do. echo 'loadd''','''',~;a end.
 try.
  if. 0 do. return. end. NB. a-:JDP,'one to stop on'
  load a
 catch.
  NB. reset to native Jd after jdc error
  jd__=: jd_jd_
  jdaccess__=: jdaccess_jd_
  'failed'logtest_jd_ LF,13!:12''
  echo LF,('failed: ',;n{t),LF,13!:12''
  failed=: failed,a
 end.
 jdt=: jdt,(jda-~6!:1'');;a
end.
jdserverstop_jd_''
jd'close'
jdadmin 0
failedx=: >(<'loadd'''),each failed,each<''''
if. #failed do.
 echo LF,'following tests failed:'
 echo failedx
end.
if. #conl 1 do.
 echo LF,'check for orphan locals in conl 1'  
end.
echo LF,(":#t),' tests run',LF,(":#failed),' failed'
jdt=: (\:;{."1 jdt){jdt
IFTESTS_jd_=: 0
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: OLDALLOC_jd_
LOGOPS_jd_=: OLDLOGOPS_jd_
echo LF,(":<.start-~6!:1''),' seconds to run tests and tutorials'
'test end'logtest_jd_''
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
  t=. dltb each (}.^:('|'={.))each<;._2 t
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
