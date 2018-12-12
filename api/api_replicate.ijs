NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

REP=: 0 : 0
#REPLICATION

A Jd task handles operations sequentially. An new op waits until the previous has completed.

This is not a problem for a single user or for multiple users where the ops are all fast.
The problem is a slow op blocking other ops that are expected (required) to be fast.

Typically the slow op is a complicated query that blocks simple queries as well as udpates.

A solution is to have multiple Jd tasks that can handle the required ops. If one task is
busy with long op, other tasks can concurrently handle other ops.

Multiple tasks with read only access to a db could be easily handled. But not allowing
any updates is a big restriction. Allowing updates introduces serious complications.
Shared resources, such as the data in a column, would have to be interlocked with semaphores. 

Semaphores would significantly complicate Jd. They would affect performance and are the source
of particular nasty bugs.

To preserve simplicity and performance, Jd allows multiple tasks with replication rather
than semaphones.

With replication the db is duplicated so that each task has its own private copy of the db.
As there are no share resources, there is no need for complicated semphores to manage access.

Disk space is the least expensive of hardware resource and by far the easiest to scale up.
Multiple copies of even large dbs is a small price to pay for multiple concurrent tasks
using multiple cores to service Jd ops.

Jd replication easily scales out in a single machine. That is, multiple Jd task on the 
same machine can each serve concurrent requests on copies of the same data.

In addition to replication on the same machine, it is easy to extend so that a replicated
db could be served from another machine.
)


0 : 0
a task writing a file has a race condition with another task reading the file
semaphore could synch this, but it is complicated

adequate mechanism in some cases is to write a temp file (race free)
 and then rename it so the reader wil see it
 rename is atomic and the reader will see the file as intended
 
 task A      task B
 writes      reads     - race
 
 write temp  
 rename new  read new  - OK

***
a db is replicated to scale for analytical queries

changes are made to the original db and then are duplicated 
in one or more replicas that can be used to service independent queries

changes to the original db are written to an rlog folder
the rlog is used to update the replicas as required

ops that change original are written to a temp file and then
renamed into the rlog folder for use in updating replicas

replica update looks for rlog files in the rlog folder that are
new and then applies them before doing any query

the rename of temp to rlog folder file is atomic
when an update sees a new file it knows it is ready for use

the rlog folder can need a lot of files
for example, 200 updates a seconds would create (200*60*60*24*30)
or more than 500 million files in a month

disk space is an inexpensive resource - an rlog could have its own ssd drive

old rlog files could be erased whenver there was a full backup
of the db that contained the old files

every update op to the original db is written as an rlog file
the file has a name of the form n.rlog
where n start at 0 and increase by 1 for each op
and is displayed as a 19 digit number with leadin 0s
the rlog files are distributed across folders with same digits as the first rlogn file

a replica db needs to know the n that it last updated

rlog files are written after the op has succeeded!
an update from an rlog file that fails indicates a problem!

rlog files are written to the rlog folder

 
numbers are padded with leading 0s to be 19 digits 
 
db state:
 REPLICATE  - 0 if not replicate, 1 is source, 2 if snk
 RLOGFOLDER - folder for rlog files
 RLOGN      - rlog file number
)

coclass 'jd'

RLOGSIG=: 'RLOGRLOG' NB. rlog file record signature

foldercopy=: 3 : 0
'snk src'=. jpath each y
src=. dquote src
jddeletefolder snkpath
snk=. dquote snk

if. IFWIN do.
 r=. shell 'robocopy ',(hostpathsep src),' ',(hostpathsep snk),' *.* /E /xf jdlock' NB. can't copy jdlock
 if. +/'ERROR' E. r do.
  smoutput r 
  assert 0['robocopy failed'
 end.
else.
 shell 'cp -r -v -T ',src,' ',snk
end.
'copy folder failed'assert 2=ftypex }.}:snk
)

NB. validate rlog arg
reparg=: 3 : 0
t=. dltb ;y
if. '"'={.t do.
 'rlog unmatched "'assert '"'={:t
 t=. }.}:t
else.
 'rlog file name with blanks must be quoted'assert -.' 'e.t
end. 
t,'/'#~'/'~:{:t
)

NB. blanks in file name are a nuisance
jd_repsrc=: 3 : 0
fn=. reparg y
'already marked as replicate' assert 0=REPLICATE__dbl
'replicate folder is in use' assert -.(<jpath fn,'rlog')e.{:"1[1!:20''

if. IFWIN do.
 e=. 'rlogfolder file(s) in use'
 if. fexist fn,'rlog' do. e assert 1=ferase fn,'rlog' end.
 if. fexist fn,'end'  do. e assert 1=ferase fn,'end'  end.
end.

jddeletefolder fn
jdcreatefolder fn
'jdrlog'fwrite fn,'jdclass' NB. identifies and allows subsequent delete
REPLICATE__dbl=: 1
RLOGFOLDER__dbl=: fn
foldercopy (fn,'base');dbpath DB
NB. remove a few files for rlog base
ferase 1 dir fn,'base'
''fwrite RLOGFOLDER__dbl,'rlog'
(3 ic 0)fwrite RLOGFOLDER__dbl,'end'
writestate__dbl''
jd_close'' NB. normal open stuff
JDOK
)

jd_repsnk=: 3 : 0
fn=. reparg y
'already marked as replicate' assert 0=REPLICATE__dbl
'replicate folder is in use'     assert -.(<jpath fn,'rlog')e.{:"1[1!:20''
'replicate folder does not exist'assert 2=ftype fn
REPLICATE__dbl=: 2
RLOGFOLDER__dbl=: fn
RLOGINDEX__dbl=: 0
foldercopy (dbpath DB);fn,'base'
writestate__dbl''
jd_close'' NB. so table etc locales are opened
JDOK
)

NB. needs to be run in jd because ops like renamecol close and open database locale
NB. snk db - process new log records
jd_repupdate=: 3 : 0
'not replicated'assert 2=REPLICATE__dbl
m=. getrlogend RLOGFOLDER__dbl
c=. 0
while. RLOGINDEX__dbl<m do.
 t=. fread RLOGFH__dbl;RLOGINDEX__dbl,16
 'bad rlog record' assert RLOGSIG-:8{.t
 n=. _3 ic 8}.t
 r=. fread RLOGFH__dbl;(RLOGINDEX__dbl+16),n
 jd 3!:2 r
 RLOGINDEX__dbl=: RLOGINDEX__dbl+16+n
 writestate__dbl''
 c=. >:c
end.
,.'ops';c
)


NB. zip db
jd_zip=: 3 : 0
folder=. dquote jpath dbpath DB
ferase y
file=. dquote jpath y
if. UNAME-:'Win' do.
 zip=. dquote jpath'~tools/zip/zip.exe'
 'windows needs work' assert 0
else.
 zip=. 'zip'
 t=. 'cd ',folder,' ; zip ',file,' -r *'
end.
echo t
r=. shell t
)

NB. unzip zip file to current db
jd_unzip=: 3 : 0
'db not empty'assert 0=#>{.{:jd_info'table'
folder=. dquote jpath dbpath DB
file=. dquote jpath y
if. UNAME-:'Win' do.
 zip=. dquote jpath'~tools/zip/zip.exe'
 'windows needs work' assert 0
else.
 zip=. 'unzip'
 t=. 'cd ',folder,' ; unzip -qq -o ',file
end.
echo t
r=. shell t
NB. kludge to close admin and reopen to get it all set up
jdadmin 0
jdadmin }.}:folder NB. quotes gone
)
