NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

0 : 0
events are recorded in log.txt and log.ijf in the db folder

logs are of particular interest when there are problems
for example, trying to figure out how a db was damaged

normal events (jd op) log to log.txt 
unusal events (jddeletefolder failed) log to log.txt and signal error
nasty events (validate db failure)
- log to log.txt
- write data to log.ijf (component file)
- mark db as damaged (prevent further confusion until sorted out)
- signal error

addtional and ad hoc logging can be added as required
)

bld=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f a int'
i.0 0
)

damage=: 3 : 0 NB. damage db
c=: jdgl_jd_'f a'
dat__c=: ;i.<:Tlen__c
i.0 0
)

bld''
jd'insert f a';i.10000
jdlogtxtshow_jd_ 10 NB. show last 10 log.txt lines

damage'' NB. damage db
'db marked as damaged'jdae'validate' NB. validate to detect damage
'db damaged'jdae'read from f'
jdlogtxtshow_jd_ 5
jdlogijfshow_jd_''     NB. show log.ijf summary
a=. jdlogijfshow_jd_ 0 NB. read component 0
>3{.each a              NB. show first bit

>{."1>a              NB. types of data in record
i=. ({."1>a)i.<'jd_info''validatebad'''
[v=. >i{{:"1>a              NB. validatebad when log was written
NB. notice that f a dat has bad shape

jddamage_jd_'' NB. remove damage mark so we can work with db
assert v-:jd'info validatebad' NB. same validation failure
jddamage_jd_''
jd'dropcol f a'                 NB. rough fix by dropping bad col
jd'createcol f a int _';i.10000 NB. and creating anew
jd'validate' 

NB. jdadmin of a db with damage that has not been detected
bld''
damage''
jdadmin 0
jdadmin'test'
'damaged'jdae'validate' NB. detects damage and marks as damaged
'db damaged'jdae'reads from f'
assert 'assertion failure'-:jdadmin etx'test'
13!:12''

NB. jdadmin of damaged db
jdadmin 0
assert 'assertion failure'-:jdadmin etx'test'
13!:12''

NB. validate is run before/after insert/update/modify/delete

NB. info
bld''
jd'info validate'
damage''
jd'info validate' NB. 1 in bad col indicates f a dat has a problem
NB. jdtypex is the jtype of the jdtype col
NB. fsize is the size of the mapped file
NB. jsize is the size of the mapped j noun
NB. jdtypex should be the same as jtype
NB. jdshape should be the same as jshape
NB. fsize should be the same as msize
NB. bad has a 1 where there is a problem
jd'info validatebad' NB. just the bad rows

NB. use jdgl to investigate the problem
t=. jdgl_jd_'f'   NB. locale for table
Tlen__t           NB. rows in table
c=. jdgl_jd_'f a' NB. locale for column a
#dat__c           NB. rows in column mapped noun dat
