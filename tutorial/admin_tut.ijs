jdadmin 0      NB. remove all admin
jdadminx'test' NB. create new db test (~temp/jd/test)
jdadmin''      NB. admin report
NB. [w]   ...test - lock prevents interference from other tasks
NB. test ~temp/jd/test - DAN test uses this database folder
NB. test u/p           - user/pswds allowed
NB. test *             - ops allowed (* for all)

admin=: 0 : 0
'all' jdadminfp ''    NB. all DAN uses DB that contains this script
'all' jdadminup 'u/p' NB. user/pswds allowed access
'all' jdadminop '*'   NB. ops allowed

'ro'  jdadminfp ''
'ro'  jdadminup 'abc/def ghi/jkl'
'ro'  jdadminop 'read reads'
)

i.0 0[admin fwrite '~temp/jd/test/admin.ijs'

jdadmin 0     NB. remove all admin
jdadmin'test' NB. admin for ~temp/test (load ~temp/jd/test/admin.ijs)
jdadmin''

jdaccess'all u/p intask'    NB. DAN all uses admin rows with all
jd'createtable';'f';'a int'
jd'insert';'f';'a';23 24
jd'read from f'             NB. all ops allowed

jdaccess 'ro x/y intask'    NB. jd ops: ro with x/y intask
jd etx'read from f'         NB. fails - ro does not allow user x/y
jdlast

jdaccess 'ro ghi/jkl intask'
jd'read from f'
jd etx'delete';'j';'jid=J1' NB. fails - ro does not allow delete
jdlast
