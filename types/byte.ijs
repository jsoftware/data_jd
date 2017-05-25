NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtbase'

NB. =========================================================
coclass deftype 'byte'
DATASIZE =: 1
DATAFILL =: ' '
fixtype=: ,@boxopen [ throwif@:(2 ~: 3!:0)
fixtext=: >@:fixstring_jdcolumn_

fixtypex=: 3 : 0
ETYPE assert 2=3!:0 y
y
)
