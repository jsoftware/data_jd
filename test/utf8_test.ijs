NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

0 : 0
OSX pre catalina stored filenames in decomposed form
following accented a chars look the same, but have different values.
   a.i.'ä' NB. utf8 from J
195 164
   a.i.'ä' NB. after 'corruption' from file system
97 204 136   
)

jdadminx'test'
jd'createtable Käyf'
jd'createcol Käyf Käyfc int'
jd'insert Käyf';'Käyfc';i.5

jd'createtable Käyg'
jd'createcol Käyg Käygc int'
jd'insert Käyg';'Käygc';i.5

jd'ref Käyf Käyfc Käyg Käygc'
jd'reads from Käyf,Käyf.Käyg'
assert (2#<,.i.5)-:{:jd'reads from Käyf,Käyf.Käyg'

jd'dropcol Käyf jdref_Käyfc_Käyg_Käygc'
jd'renamecol Käyf Käyfc Käyfcxxx'
jd'reads Käyfcxxx from Käyf'

jd'renametable Käyf Käyfxxx'
jd'reads Käyfcxxx from Käyfxxx'

jd'droptable Käyfxxx'
'found'jdae'reads from Käyfxxx'
jd'droptable /reset Käyg'
jd'reads from Käyg'
