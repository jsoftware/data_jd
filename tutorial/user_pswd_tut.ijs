NB. server users and passwords

0 : 0
an upfile (user/pswd) validates client logon to the node task
test_upfile is used by test servers
upfile is used by production servers
)

jdsetuser'test_upfile'                 NB. list users
jdsetuser'test_upfile';'newbie';'xxxx' NB. add user and encrypted pswd
jdsetuser'test_upfile'
jdsetuser'test_upfile';'newbie'        NB. remove user
