0 : 0
logon is required to access a server
   s1=: 'https://localhost:3000'jdcdefine
   s1'logon dan user pswd'
user/pswd is validated against a user/pswd file

a server is configured to use test_upfile or upfile
upfiles are maintained in jdscpath/up

pswd in an upfile is encrypted

jdsetuser manages upfiles
)

dir jdscpath_jd_,'up'
fread jdscpath_jd_,'up/test_upfile'

jdsetuser'test_upfile' NB. report users
jdsetuser'test_upfile';'newuser';'guess' NB. add user
jdsetuser'test_upfile' NB. report users
jdsetuser'test_upfile';'newuser' NB. remove user
jdsetuser'test_upfile' NB. report users

0 : 0  
a server provides access to 0 or more databases

the db admin.ijs determines what dan(s) can be used to access the db
and what users and ops are allowed for that dan

jdsetadmin manages db admin.ijs
)
load JDP,'server/server1.ijs'
s1_start''
jdserver'server1';'stop'

jdsetuser'test_upfile';'newuser';'guess' NB. add user
jdsetuser'test_upfile'

jdsetadmin'simple' NB. report admin.ijs for db simple
jdsetadmin'simple';'simple-ro';'newuser';'info read reads'
jdsetadmin'simple';'simple-rw';'newuser';'info read reads insert'
jdsetadmin'simple'

jdserver'server1';'start'
s1=: 'https://localhost:3000'jdcdefine
s1'logon simple-ro newuser guess'
s1'info summary'
s1'read from t'
0 s1'insert t';'a';23;'byte';'xxx'

s1'logon simple-rw newuser guess'
s1'info summary'
s1'insert t';'a';23;'byte';'xxx'
s1'read from t'
s1'free'
