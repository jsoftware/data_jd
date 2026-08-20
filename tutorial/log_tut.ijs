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
jd'createcol f a int';i.10
jd'createcol f b int';23+i.10
i.0 0
)

damage=: 3 : 0 NB. damage db
c=: jdgl_jd_'f a'
dat__c=: i.<:Tlen__c
i.0 0
)

LOGOPS_jd_=: 1
bld''
jdlogtxtshow_jd_ 10 NB. show last 10 log.txt lines
damage'' NB. damage db
'db marked as damaged'jdae'validate' NB. validate to detect damage
'db damaged'jdae'read from f'
jdlogtxtshow_jd_ 5
jdlogijfshow_jd_''     NB. show log.ijf summary
a=. jdlogijfshow_jd_ 0 NB. read component 0
>3{.each a              NB. show first bit

>{."1>a              NB. types of data in record

jdadmin 0          NB. close db
assert 'assertion failure'-:jdadmin etx 'test'
jdrepair_jd_'fixing it now'  NB. mark db as under repair
jdadmin'test'
jd'info validatebad'         NB. same validation failure
jd'dropcol f a'              NB. rough fix by dropping bad col
jd'createcol f a int _';i.10 NB. and creating anew
jd'validate'
jddamage_jd_'' NB. remove damage mark     

NB. jdadmin of a db with damage that has not been detected
bld''
damage''
jdadmin 0
jdadmin'test'
'damaged'jdae'validate' NB. detects damage and marks as damaged
'damaged'jdae'reads from f'
jdadmin 0
assert 'assertion failure'-:jdadmin etx'test'
13!:12''

NB. jdadmin of damaged db
jdadmin 0
assert 'assertion failure'-:jdadmin etx'test'
13!:12''

bld''
jd'info validate'
jd'info validatebad'
damage''
jd'info validate'
NB. x is X if there is a problem with the col
NB. fsize is the size of the mapped file
NB. jsize is the size of the mapped j noun
NB. fsize should be the same as msize

jd'info validatebad' NB. just the bad rows
NB. use jdgl to investigate the problem
t=. jdgl_jd_'f'   NB. locale for table
Tlen__t           NB. rows in table
assert 0=jdgl_jd_ :: 0:'f a' NB. fails because accessing damaged col marks db as damaged
jdrepair_jd_'fixing it now'  NB. mark db as under repair
c=. jdgl_jd_ 'f a'
c=. jdgl_jd_'f a' NB. locale for column a
countdat__c dat__c           NB. rows in column mapped noun dat

bld''
LOGOPS_jd_=: 0
