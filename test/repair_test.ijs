NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

jdadminx'test'
jd'gen test f 5'
c=. jdgl_jd_'f int'
dat__c=: (<:Tlen__c){.dat__c
'damaged'jdae'reads from f'
repair_jd_''

jdadminx'test'
jd'gen test f 5'
c=. jdgl_jd_'f int'
d=. jdgl_jd_'f byte4'
dat__c=: (<:Tlen__c){.dat__c
dat__d=: (<:Tlen__d){.dat__d
'damaged'jdae'reads from f'
repair_jd_''

jdadminx'test'
jd'gen ref2 f 5 2 g 3'
jd'reads from f,f.g'
c=. jdgl_jd_'f adata'
dat__c=: (<:Tlen__c){.dat__c
'damaged'jdae'reads from f'
repair_jd_''



