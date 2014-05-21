NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

3 : 0''
echo 'placeholder for Jd addon'
'addon is not ready for use'assert 0
)

PATH =. '~addons/data/jd/'
load@:(PATH&,);._2 ]0 :0
base/util.ijs
base/zutil.ijs
base/common.ijs
base/folder.ijs
base/database.ijs
base/table.ijs
base/column.ijs
base/read.ijs
base/where.ijs
base/jmfx.ijs
api/api.ijs
api/api_insert.ijs
api/apix.ijs
api/csv_api.ijs
api/adm_api.ijs
api/client.ijs
csv/csv.ijs
csv/csvinstall.ijs
)

loadall =: (''&$:) : (4 : 0)
y =. (,'/'-.{:) jpath y
load (<y) ,&.> (boxxopen x) ~.@, {."1 ]1!:0 y,'*.ijs'
)

load'data/jmf'

(<;._1' base.ijs numeric.ijs') loadall PATH,'types/'
(<;._1' base.ijs hash.ijs')    loadall PATH,'dynamic/'
erase'loadall'

echo 0 : 0 rplc 'BOOKMARK';jpath'~addons/data/jd/doc/toc.html'
Jd is Copyright 2014 by Jsoftware Inc. All Rights Reserved.
Jd is provided "AS IS" without warranty or liability of any kind.

Commercial users must have a Jd Commercial Support Agreement.
Jd software license is free.

Keep addons (base, JHS, jmf, etc) up to date.

There is a slight bias for JHS as the front end.
JHS is the base technology for Jd clent/server.

Get started:
   bookmark documentation in your browser:
     file:///BOOKMARK
   jdex_jd_''       NB. list examples from user.html
   jdex_jd_'insert' NB. run insert example
   jdrt_jd_''       NB. list tutorials
   jdrt_jd_'intro'  NB. run intro
)

3 : 0''
b=. *./('northwind';'sed';'sandp';'vr') e. {."1[ 1!:0 jpath'~temp/jd/*'
b=. b*.(fread'~addons/data/jd/manifest.ijs')-:fread'~temp/jd/manifest.ijs'
if. -.b do.
 echo ' '
 echo 'jdtests strongly reccomended!'
 echo '   jdtests_jd_'''' NB. validate install - create demos - takes minutes'
end.
)

NB. assert for platorm and environment
3 : 0''
'Jd requires J64'assert IF64=1
('Jd not supported on UNAME ',UNAME) assert (<UNAME)e.'Win';'Linux';'Darwin' 
'Jd libjd.dylib not current'assert -.UNAME-:'Darwin'
if. IFWIN do.
 'Jd requires Windows version > XP'assert 5<{:,(8#256)#:;'kernel32.dll GetVersion x' cd ''
 try. 'msvcr110.dll foo x'cd'' catch. end.
 t=. 'Jd requires msvcr110.dll',LF,'http://www.microsoft.com/en-ca/download/details.aspx?id=30679',LF,'download vcredist_x64.exe and run to install msvcr110.dll'
 t assert 2 0=cder''
end.
)

NB. initial values
3 : 0''
if. _1=nc<'ALLOW_DELETE_jd_' do.
 ALLOW_DELETE_jd_=: 1 NB. 1 allows delete (and update) with reference - problems now resolved
 ALLOW_FVE_jd_=:  0 NB. 1 allows hash float - see test/api_float.ijs
end.
if. _1=nc<'TRACE_jd_' do. jdtrace_jd_ 0 end.
if. _1=nc<'TEMPCOLS_jd_' do. TEMPCOLS_jd_=: i.0 2 end.

if. -.IFJHS do. require'~addons/ide/jhs/sp.ijs' end.
if. IFQT do. labs_run_jqtide_=: 3 : 'spx''''' end.
i.0 0
)
