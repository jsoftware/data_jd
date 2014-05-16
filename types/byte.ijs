NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtbase'

NB. =========================================================
coclass deftype 'byte'
DATASIZE =: 8
DATAFILL =: ' '
fixvalue=: 3 : 0
'Invalid data rank' throwif (#$y) > ADDRANK + >:#shape
if. shape =&# $y do. y=.,:y end.
'Invalid data shape' throwif shape +./@:< }.$y
fixtype ({.~ #,shape"_) y
)
fixtype =: ,@boxopen [ throwif@:(2 ~: 3!:0)
fixtext =: >@:fixstring_jdcolumn_
