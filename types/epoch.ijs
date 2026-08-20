NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. epoch datetime
coclass 'jdtint'

coclass deftype 'elike'

STATE=: STATE_jdcolumn_,;:'sep utc'

sep=: ','
utc=: ' '

DATAFILL=: _9223372036854775808 NB. efs_jd_'1700' NB. invalid

fixinsert=: 3 : 0
if. JCHAR=3!:0 y do. ('d039'{~TYPES_E i.<typ) efs y else. y end.
)

fixtype=: 3 : ',@boxopen fixtype_num fixinsert y'

fixtypex=: 3 : 'fixtype_num fixinsert y'

NB. fixtype should be defined to do efs

coclass deftype 'edate'
coclass deftype 'edatetime'
coclass deftype 'edatetimem'
coclass deftype 'edatetimen'
