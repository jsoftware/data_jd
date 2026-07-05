NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

load JDP,'test/util/beat.ijs'

NB. build database and create server folder
simple_build=: {{
jdserver'simple';'delete' NB. kill old server
jdadminnew'simple'
(fread JDP,'test/util/custom.ijs') fwrite '~temp/jd/simple/custom.ijs'
jdloadcustom_jd_'' NB. load custom ops - xdelete, xrdspin, xwrspin
jd'createtable t'
jd 'createcol t a int'
jdadmin 0 NB. so it can be opened again

NB. set admin.ijs
jdsetadmin'simple';'simple';'user0';'*' NB. simple dan user0 can do all ops
jdsetadmin'simple';'simple-ro';'user0';'info read reads'

NB. configure jd simple server-folder
jdserver'simple';'delete' NB. stop and delete an old simple
jdserver'simple';'create';65220;'simple'

NB. add users to test_upfile with encrypted pswd
jdsetuser 'test_upfile';'admin';'funny'
jdsetuser 'test_upfile';'user0';'pswd0'

NB. configure node simple node-folder
jdnode'simple';'delete' NB. stop and delete an old simple
jdnode'simple';'create';3000;'testup';'inspect-yes';NODE_TIME_jd_

URL=: 'https://localhost:3000'
LOGON=: 'logon simple user0 pswd0'
i.0 0
}}

create_simple_server=: {{
simple_build''
jdserver'simple';'start'
jdnode  'simple';'start'
simple=: URL jdclient
LOGON simple 'info summary'
}}

simple_play=: create_simple_server NB. kill off eventually
