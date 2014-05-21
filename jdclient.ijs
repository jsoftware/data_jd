NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

require '~addons/net/clientserver/jssc.ijs'

coclass 'jdclient'
coinsert 'jssc'
checkrc=: >@{:`(>@{: (13!:8) 3:)@.(0 ~: >@{.)
jd=: checkrc @ calljd
