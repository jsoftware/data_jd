NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. asserts for platorm and environment
'Jd requires J64'assert IF64=1
('Jd not supported on UNAME: ',UNAME) assert (<UNAME)e.'Win';'Linux';'Darwin' 

3 : 0''
if. IFWIN do.
 'Jd requires Windows version > XP'assert 5<{:,(8#256)#:;'kernel32.dll GetVersion x' cd ''
 try. 'msvcr110.dll foo x'cd'' catch. end.
 t=. 'Jd requires msvcr110.dll',LF,'http://www.microsoft.com/en-ca/download/details.aspx?id=30679',LF,'download vcredist_x64.exe and run to install msvcr110.dll'
 t assert 2 0=cder''
end.
)

NB. production Jd library is ~addons/data/jd and it is installed/updated by JAL
NB.   load'data/jd' NB. sets JDP_z_ as path to production Jd library

NB. developer Jd library is repo at ~Jddev
NB.   load'~Jddev/jd.ijs' NB. sets JDP_z_ as developer Jd library
NB. driven by manifest.ijs - developer repo files are copied to an svn repo that
NB. is pushed to Jsoftware for building JAL data/jd packages

NB. all use of the Jd library is through JDP_z_

JDP_z_=: ;((<jpath'~addons/data/jd/jd.ijs')e. jpath each 4!:3''){'~Jddev/';'~addons/data/jd/'

load@:(JDP&,);._2 ]0 :0
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

(<;._1' base.ijs numeric.ijs') loadall JDP,'types/'
(<;._1' base.ijs hash.ijs')    loadall JDP,'dynamic/'
erase'loadall'

NB. initial values
3 : 0''
APIRULES_jd_=: 1
OP_jd_=: 'none'
ALLOW_FVE_jd_=:  0 NB. 1 allows hash float - see test/api_float.ijs
if. _1=nc<'TRACE_jd_' do. jdtrace_jd_ 0 end.
if. _1=nc<'TEMPCOLS_jd_' do. TEMPCOLS_jd_=: i.0 2 end.
if. -.IFJHS do. require'~addons/ide/jhs/sp.ijs' end.
if. IFQT do. labs_run_jqtide_=: 3 : 'spx''''' end.
i.0 0
)

echo 0 : 0 rplc 'BOOKMARK';jpath JDP,'doc/toc.html'
Jd is Copyright 2014 by Jsoftware Inc. All Rights Reserved.
Jd is provided "AS IS" without warranty or liability of any kind.

Commercial users must have a Jd License from Jsoftware.

Keep addons (base, JHS, jmf, etc) up to date.

There is a slight bias for JHS as the front end.
JHS is the base technology for Jd clent/server.

Get started:
   jdtests_jd_'' NB. validate - after install or update - takes minutes

   bookmark documentation in your browser:
     file:///BOOKMARK

   jdex_jd_''       NB. list examples from user.html
   jdex_jd_'insert' NB. run insert example
   jdrt_jd_''       NB. list tutorials
   jdrt_jd_'intro'  NB. run intro
)


echo IFQT#0 : 0
ctrl+j hijacked for managed execution of tutorials
ctrl+j will not work with traditional labs'
)

echo (0=#fdir'~temp/jd')#0 : 0

Run jdtests as the ~temp/jd folder does not exist!
   jdtests_jd_'' NB. validate install - takes minutes
)

3 : 0''
if. -.UNAME-:'Win' do.
 n=. ".}:2!:0'ulimit -n'
 if. n<4096 do.
  echo LF,(":n),' for "ulimit -n" is low. See Technotes "file handles" for details.'
 end.
end.
)
