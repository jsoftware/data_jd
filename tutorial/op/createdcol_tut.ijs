NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

0 : 0
derived col:
 calculated - usually from another col
 not mapped (not backed by a file)
 can't be updated by insert etc.
 can be used in ref
 not currently allowed in a ptable
)

jdadminnew'test'
jd'createtable f'
jd'createcol f b byte 4'
jd'createcol f e  edate'
jd'insert f';'b';(3 4$'abcdef');'e';'2014-10-12','2015-10-13',:'2016-10-14'
jd'reads from f'

jd'createdcol f catg  byte 2' NB. derived col - 2 byte category prefix from b4x col
jd'createdcol f year int'     NB. derived col - year as int from e col
jd'reads from f' NB. default verbs to create data return fill

[p=. jdpath_jd_'' NB. path to db folder
fread p,'f/catg/derive.ijs' NB. catg  derive verb for cat
fread p,'f/year/derive.ijs' NB. year derive verb for year

NB. getting data from a col
catgc=. jdgl_jd_'f catg' NB. locale for talbe f, col catg
NAME__PARENT__catgc  NB. name of the table (avoid hardwiring f)
bc=. jdgl_jd_ NAME__PARENT__catgc;'b' NB. locale for col b
dat__bc   NB. col b data
Tlen__bc  NB. rows in table
shape__bc NB. trailing shape

NB. define catg derive verb to be 2{."1 from b col data
(0 : 0,')') fwrite p,'f/catg/derive.ijs' 
derive=: 3 : 0
2{."1 dat__c[c=. jdgl NAME__PARENT;'b'
)

NB. new defn not loaded yet - close and open gets new defn
jd'close'
jd'reads from f' NB. catg is 2{."1 from b

NB. define year derive verb to be int year from e col
(0 : 0,')') fwrite p,'f/year/derive.ijs' 
derive=: 3 : 0
0".4{."1 sfe dat__c[c=. jdgl NAME__PARENT;'e'
)

jd'close'
jd'reads from f' NB. year is int year from e
