NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jddbase'
coinsert 'jdcolumn'

NB. A dynamic column is a column that is not inserted to directly;
NB. rather, it subscribes to other columns and recieves their insertions
NB. through its own Insert verb.
NB.
NB. Each dynamic column can subscribe to multiple sets of columns, where
NB. each set is taken from a single table. For example, a reference column
NB. will subscribe the referencing and referenced columns as distinct sets.
NB.
NB. Insert takes (index of set);(insertion data) , where insertion data is
NB. simply the relevant elements of the argument to Insert_jdtable_ .

visible=: 0
static=: 0

STATE=: (STATE_jdcolumn_-.<'shape'),<'subscriptions'
subscriptions=: 0 2$a:

NB. y is (table);(list of column names)
subscribe =: 3 : 0
cols=.,&.>,boxxopen cols  [  'tab cols' =. ,&.> y
t =. getloc '^.^.',tab
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
