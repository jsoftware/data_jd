NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Tests for csv dump utility.

require '~addons/data/jd/test/core/util.ijs'

NB. enum type removed as it is not fully supported
nms =. toupper&.> types =. ;:'boolean int float byte varbyte'
DATA =: <@".;._2 ]0 :0
1 0 1
12 _15 6728637560195710578
0.5 _1.2 6.92857499
LF,TAB,0{a.
'\jkl"';'ABC';256$'1234'
)

jdadminx 'test'
jd 'createtable t'; ; ,&','&.> nms (,' '&,)&.> types
jd 'insert t'; , nms,.DATA

CSVFOLDER=: '~temp/jd/csv/'
jddeletefolder_jd_ CSVFOLDER
jd'csvwr t.csv t'


jd'csvrd t.csv tx'
assert (jd'reads from t')-:jd'reads from tx'



NB. write just 4 cols and 1 row
jd'csvwr /w a.csv t  BOOLEAN BYTE FLOAT INT *INT=12'
jd'csvrd a.csv a'
assert 2 4-:$jd'reads from a'
assert 12=>{:{:jd'reads from a'

NB. Tests for shaped columns
jd 'droptable t'
jd 'createtable t'; ; ,&','&.> nms (,' ',,&' 3')&.> types
jd 'insert t'; , nms,. ,:&.>DATA

NB.! CSTITCH does not work for boolean or varbyte
jd'dropcol t BOOLEAN'
jd'dropcol t VARBYTE'


jd'csvwr q.csv t'
jd'droptable tx'
jd'csvrd q.csv tx'
assert (jd'reads from t')-:jd'reads from tx'
