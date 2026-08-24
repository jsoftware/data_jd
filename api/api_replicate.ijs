NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

0 : 0
https://www.architecture-weekly.com/p/the-write-ahead-log-a-foundation

Jd cluster is a server that provides access to multiple copies of data.

Jd cluster is shared-nothing database cluster. Each node (server) operates independently with its own CPU, memory, and storage, and complete copy of the data.

Jd cluster uses write-ahead logs!

There is single rw copy of data. Updates to this data record all changes in a walfile.

There can be any number of ro copies of the data. These copies are updated as required from the walfile.

Earlier stabs at this used MTRO so that multiple tasks could access the same files
but that complicated the replication as each task had to remap as required.
Replication duplicates the files, but simplies updates.
)

coclass'jd'

NB. * db;tarfile;walfile
NB. make db a replicate source
jdrepsrc=: 3 : 0
'db tar wal'=. y
jdadmin 0
jdadmin db
'already a rep src or snk'assert 0=REPLICATE__dbl
tar=. jpath tar
'tar file already exists' assert 0=fexist tar
wal=. wal
'log file already exists' assert 0=fexist wal
''fwrite wal
shell'tar -czf ',(hostpathsep tar),' -C "',(hostpathsep PATH__dbl),'" .'
REPLICATE__dbl=: 1
TARFILE__dbl=: tar
WALFILE__dbl=: wal
writestate__dbl''
i.0 0
)

NB. * base_db ; db_path_to_replicate
NB. create new clone of db
NB. add clone name to repsnk list of clones
jdrepsnk=: 3 : 0
'dbsrc dbpath'=. y
jdadmin 0
jdadmin dbsrc
'not a repsrc'assert 1=REPLICATE__dbl
name=. NAME__dbl
tar=. TARFILE__dbl
'tarfile does not exist' assert 1=ftype tar
wal=. WALFILE__dbl
'walfile does not exist' assert 1=ftype wal
dbsnk=. dbpath,'/',name,'_clone_',":#CLONES__dbl
'dbsnk folder already exists'assert 0=ftype dbsnk
CLONES__dbl=: CLONES__dbl,<dbsnk
writestate__dbl'' 
jdadmin 0
jdadminnew dbsnk
shell'tar -xzf ',(hotspathsep tar),' -C "',(hostpathsep jpath dbsnk),'"'
REPLICATE__dbl=: 2
TARFILE__dbl=: tar
WALINDEX__dbl=: 0
WALFILE__dbl=: wal
writestate__dbl''
jdadmin 0
)

NB. replicate routines

NB. some ops are trouble - createdb table... csv... ???

WALSIG=: 'WAL' NB. wal record signature
WALC=: #WALSIG
WALHEADER=: WALC+8+4 NB. WALSIG,length,crc32

crc32=: 128!:3

NB. append wal record to walfile
NB. record has format: WALSIG,(8 byte length of data),(crc32 of data),data
NB. data is 3!:1 encoding of jd request
NB. do write-ahead-log if required before doing the op
NB. dead simple - fappend filename - no lock nothing
NB. need some stuff to be sure reader does not get confused
NB.! op may fail after it has been added to walfile
NB. torn page detection - crc32
NB. repsrc appends new requests to the walfile
rlog=: 3 : 0
'readop op a'=. y
'write op not allowed on clone' assert (REPLICATE__dbl~:2)+.readop
if. (-.readop) *. 1=REPLICATE__dbl do.
 t=. 3!:1 OP;<a
 d=. WALSIG,(3 ic #t),(2 ic crc32 t),t
 'rlog fappend failed' assert (#d)=d fappend WALFILE__dbl
end. 
)

NB. display walfile
jdwalread=: 3 : 0
r=. ''
d=. y
while. #d do.
  'bad wal signature' assert WALSIG-:WALC{.d
  'bad wal header length' assert WALHEADER<:#d
  n=. _3 ic 8{.WALC}.d
  'bad wal record length' assert (WALHEADER+n)<:#d
  crc=. 4{.(WALC+8)}.d
  a=.   n{.WALHEADER}.d
  'bad wal crc' assert (2 ic crc32 a)-:4{.(WALC+8)}.d
  r=. r,<3!:2 a
  d=. (WALHEADER+n)}.d
end.
,.r
)

NB. runs automatically before any op on a replicated db to do updates
NB. needs to be run in jd because ops like renamecol close and open database locale
NB. snk db - process new log records
NB. should be in db locale but there were unresolbed problems
NB. detect and ignore torn/corrupted page - get it next time
repupdate=: 3 : 0
if. 2~:REPLICATE__dbl do. return. end.
size=. fsize WALFILE__dbl
if. WALINDEX__dbl>:size do. return. end.
d=. fread WALFILE__dbl;WALINDEX__dbl,size-WALINDEX__dbl
while. #d do.
   try.
     'bad wal signature' assert WALSIG-:WALC{.d
     'bad wal header length' assert WALHEADER<:#d
      n=. _3 ic 8{.WALC}.d
      'bad wal record length' assert (WALHEADER+n)<:#d
      crc=. 4{.(WALC+8)}.d
      a=. n{.(WALHEADER)}.d
     'bad wal crc' assert (2 ic crc32 a)-:4{.(WALC+8)}.d
     'op a'=. 3!:2 a
     d=. (WALHEADER+n)}.d
     WALINDEX__dbl=: WALINDEX__dbl+WALHEADER+n
     REPLICATE__dbl=: 3 NB. allow replicate updates
     if. 0=L. a do. a=. op,' ',a else. a=. op;a end.
     r=. 0 jdi__dbl a NB. FIXPAIRSFLAG!!!
     REPLICATE__dbl=: 2
     writestate__dbl''
   catchd.
     t=. 13!:12''
     'replicate'logtxt ((t i.LF){.t),' ',":WALINDEX__dbl,size
     return.
   end.
end. 
)

NB. * rwdb 
NB. update clones and ferase tarfile and walfile
cluster_clear=: 3 : 0
rwdb=. y
jdadmin 0
???

NB. loop over all clones to get latest from wal and set WALINDEX=:0
jdadmin'clone'
jd'info schema' NB. get latest from wal
c=. dbl_jd_
WALINDEX__c=: 0
writestate__c''
jdadmin 0

jdadmin rwdb
tar=. TARFILE__dbl
wal=. WALFILE__dbl
ferase each tar;wal
''fwrite wal
jdadmin 0
)

NB. * rwdb
NB. cluster_reset then create tarfile
cluster_reset=: 3 : 0
rwdb=. y
cluster_clear rwdb
jdadmin rwdb
tar=. TARFILE__dbl
wal=. WALFILE__dbl
ferase tar;wal
jd'rep';tar;wal NB. create new tar and empty wal
jdadmin 0
)


