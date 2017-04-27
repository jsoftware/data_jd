NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtbase'

NB. =========================================================
coclass deftype 'byte'
DATASIZE =: 1
DATAFILL =: ' '
fixvalue=: 3 : 0
'Invalid data rank' throwif (#$y) > ADDRANK + >:#shape
if. shape =&# $y do. y=.,:y end.
ESHAPE throwif shape +./@:< }.$y
fixtype ({.~ #,shape"_) y
)
fixtype =: ,@boxopen [ throwif@:(2 ~: 3!:0)
fixtext =: >@:fixstring_jdcolumn_
