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

padn=: 3 : 0
(19j0":y)rplc' ';'0'
)


NB.  get rlog file - from record y to end
NB. getrlog 'rlog folder';30000;123
getrlog=: 3 : 0
'folder per n'=: y
r=. ''
while. 1 do.
 f=. padn per*<.n%per
 q=. fread folder,f,'.rlogd/',(padn n),'.rlogn'
 if. _1=q do. break. end.
 r=. r,(3 ic #q),q
 n=. >:n
end.
r fwrite '~temp/jnk.txt'
shell 'zip j64-807-user/temp/jnk.zip j64-807-user/temp/jnk.txt'
fsize 'j64-807-user/temp/jnk.zip'
)

NB. blanks in file name are a nuisance
jd_repsrc=: 3 : 0
ECOUNT assert 1=#bdnames y NB.! quoted with blanks
 'already marked as replicate' assert 0=REPLICATE__DBL
fn=. dltb y
fn=. fn,'/'#~'/'~:{:fn
jddeletefolder fn
jdcreatefolder fn
'jdrlog'fwrite fn,'jdclass' NB. identifies and allows subsequent delete
REPLICATE__DBL=: 1
RLOGFOLDER__DBL=: fn
RLOGN=: 0         NB. next file in current folder
writestate__DBL''
JDOK
)

jd_repsnk=: 3 : 0
'already marked as replicate' assert 0=REPLICATE__DBL
fn=. dltb y
fn=. fn,'/'#~'/'~:{:fn
jdcreatefolder fn
REPLICATE__DBL=: 2
RLOGFOLDER__DBL=: fn
RLOGN__DBL=: 0
writestate__DBL''
JDOK
)

jd_repupdate=: 3 : 0
while. 1 do.
 f=. padn RLOGPER__DBL*<.RLOGN__DBL%RLOGPER__DBL
 r=. fread RLOGFOLDER__DBL,f,'.rlogd/',(padn RLOGN__DBL),'.rlogn'
 if. _1=r do. JDOK return. end.
 RLOGN__DBL=: >:RLOGN__DBL
 jd 3!:2 r
 writestate__DBL''
end. 
JDOK
)

coclass 'jddatabase'
coinsert 'jd'

rops=:      ;:'delete insert update upsert sort ref'
rops=: rops,;:'createcol createtable createptable'
rops=: rops,;:'renamecol renametable'

NB. some ops are trouble - createdb table... csv... ???

NB. called from database locale - write next rlog record
rlog=: 4 : 0
if. 1~:REPLICATE do. return. end.
if. -.(<x) e. rops do. return. end.
'rlog write failed' assert _1~:(3!:1 y)fwrite RLOGFOLDER,'rlog'
a=. padn RLOGN
c=. padn RLOGPER*<.RLOGN%RLOGPER
if. 0=RLOGPER|RLOGN do. 1!:5 <jpath RLOGFOLDER,c,'.rlogd' end.
new=. RLOGFOLDER,c,'.rlogd/',a,'.rlogn'
'rlog rename failed'assert 1=new frename RLOGFOLDER,'rlog'
RLOGN=: >:RLOGN
)

