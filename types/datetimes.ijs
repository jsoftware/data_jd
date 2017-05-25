NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. date, datetime, and time types
coclass 'jdtint'
coclass deftype 'timelike'

DATAFILL =: -~2

fixdatetime=: 4 :0
fixtype_jdtint_ y
)

NB. =========================================================
coclass deftype 'date'
fixtype =: 'yyyymmdd'&fixdatetime

NB. =========================================================
coclass deftype 'datetime'
fixtype =: 'yyyymmdd.hhmmss'&fixdatetime

