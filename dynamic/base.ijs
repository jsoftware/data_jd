NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jddbase'
coinsert 'jdcolumn'

NB. ref is a dynamic col

visible=: 0
static=: 0

STATE=: (STATE_jdcolumn_-.<'shape'),<'subscriptions'
subscriptions=: 0 2$a:

countdat=: 3 : '(dirty+.left){Tlen,~#dat' NB. left jams Tlen as it can't be calculated

NB. y is (table);(list of column names)
subscribe =: 3 : 0
cols=.,&.>,boxxopen cols  [  'tab cols' =. ,&.> y
t=. getloctab tab
np=.NAME__PARENT
relpath =. ((tab-.@-:np) # '^.',np,'.'),NAME  NB. path from t
writestate__t SUBSCR__t=: SUBSCR__t , relpath;(#subscriptions),&<cols
subscriptions=: subscriptions , tab,&<cols
)

NB. shape is secretly the subscriptions
makecolfiles =: 3 : 0
subscribe"1 shape
dynamicinit ''
writestate ''
)

dynamicreset =: dynamicinit =: ]
testcreate =: ]
TestInsert =: ]
Revert =: dynamicreset
