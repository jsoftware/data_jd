NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. epoch datetime
coclass 'jdtint'

coclass deftype 'elike'

STATE=: STATE_jdcolumn_,;:'sep utc'

sep=: ','
utc=: 'Z'

ADDRANK=: 1
DATAFILL=: _9223372036854775808 NB. ''$efsx_jd_'1700' NB. invalid

coclass deftype 'edate'
eformat=: ',Zd'

coclass deftype 'edatetime'
eformat=: ',Zt'

coclass deftype 'edatetimem'
eformat=: ',Zm'

coclass deftype 'edatetimen'
eformat=: ',Zn'
