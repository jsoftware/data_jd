NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass'jd'

JDTIMING=: 1 NB. avoid errors on timing tests - set 0 to check timings

NB. assume headers are non-numeric and end at first number in any column
NB. y ''              runs all tests
NB. y 'fast'          skip build demos, unique_tut, csv tests
NB. y 'testa'         runs all tests except testa
NB. y 'testa';'testb' runs all tests except
NB. y 0               just sets ALLTESTS
NB. x 0 or elided     do not echo test scripts as they are run
NB. x 1               echo test scripts as they are run
jdtests=: 3 : 0
0 jdtests y
:
start=. 6!:1''
cocurrent'base' NB. defined in jd, but must run in base
OLDFLUSHAUTO_jd_=: FLUSHAUTO_jd_
FLUSHAUTO_jd_=: 0 NB. tests run more than 2 times slower with flush
OLDALLOC_jd_=: ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: 4 1 0 NB. lots of resize
jd'option sort 1' NB. required for tests for now
NB. assert -.(<'jjd')e. conl 0['jdtests must be run in task that is not acting as a server'
jdserverstop_jd_''
jd'close'
jdadmin 0
RESIZESTRESS_jdcsv_=: 0
t=. _4}.each 1 dir JDP,'test/*.ijs'
t=. (>:;t i: each '/')}.each t
tsts=. 'core/testall';t
tsts=. (<JDP,'test/'),each tsts,each<'.ijs'
tuts=. {."1[ 1!:0 <jpath JDP,'tutorial/*.ijs'
tuts=. (<JDP,'tutorial/'),each tuts
tuts=. tuts,demos_jd_
t=. ALLTESTS=:  /:~tuts,tsts NB. sorted so they run in same order on windows and linux
NB. remove tests listed in y
n=. >:>t i:each '/'
n=. n}.each t
n=. _4}.each n
b=. -.n e. boxopen y
t=. b#t
if. -.IFJHS do. t=. t-.<JDP,'tutorial/server.ijs' end.
failed=: ''
if. 0-:y do. i.0 0 return. end.
jdt=: i.0 2
load JDP,'demo/common.ijs'

fast=. 'fast'-:y
if. fast do.
 t=. t-.<JDP,'tutorial/unique_tut.ijs'
else.
 jda=. 6!:1''
 builddemo'northwind'
 builddemo'sandp'
 builddemo'sed'
 jdt=: jdt,(jda-~6!:1'');'build demos'
end.

for_n. i.#t do.
  a=. n{t
  jda=. 6!:1''
  if. x do. echo 'loadd''','''',~;a end.
  try.
    load a
  catch.
   echo LF,('failed: ',;n{t),LF,13!:12''
   failed=: failed,a
  end.
  jdt=: jdt,(jda-~6!:1'');;a
end.

jdserverstop_jd_''

if. -.fast do.
 jda=. 6!:1''
 NB. csv tests
 load JDP,'csv/csvtest.ijs'
 RESIZESTRESS_jdcsv_=: 0
 tests''
 RESIZESTRESS_jdcsv_=: 1
 tests''
 RESIZESTRESS_jdcsv_=: 0
 jdt=: jdt,(jda-~6!:1'');'csv tests'
end. 

jdt=: (\:;{."1 jdt){jdt

jd'close'
jdadmin 0

if. #failed do.
 NB. echo LF,'known problems:'
 echo LF,'following tests failed:'
 echo each (<'loadd'''),each failed,each<''''
end.
if. #conl 1 do.
 echo LF,'check for orphan locals in conl 1'  
end.
echo LF,(":#t),' tests run',LF,(":#failed),' failed'
FLUSHAUTO_jd_=: OLDFLUSHAUTO_jd_ 
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: OLDALLOC_jd_
jd'option sort 0'
echo LF,(":start-~6!:1''),' seconds to run tests'
(;{:jd'list version')fwrite'~temp/jd/jdversion' NB. avoid welcome
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
