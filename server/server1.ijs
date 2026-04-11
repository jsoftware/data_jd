NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

NB. build database and create server folder
s1_build=: {{
jdadminnew'simple'
jd'createtable t'
jd 'createcol t a int'
jd 'createcol t byte byte 3'
jdadmin 0 NB. so it can be opened again

NB. set admin.ijs
jdsetadmin'simple';'simple';'user0';'*' NB. simple dan user0 can do all ops
jdsetadmin'simple';'simple-ro';'user0';'info read reads'

NB. add users to test_upfile with encrypted pswd
jdsetuser 'test_upfile';'admin';'funny'
jdsetuser 'test_upfile';'user0';'pswd0'

jdserver :: [ 'server1';'delete' NB. stop and delete an old server1
jdserver 'server1';'create';65220;3000;'simple';'testup';'inspect-yes'

url=: 'https://localhost:3000'
i.0 0
}}

s1_play=: {{
s1_build''
jdserver'server1';'start'
s1=: url jdclient
s1'logon simple user0 pswd0'
echo '   s1''free'' NB. when you are done'
}}
