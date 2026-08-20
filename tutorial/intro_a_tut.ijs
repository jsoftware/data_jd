NB. create db, table, columns
NB. read - select, where, aggregation
jdadminnew'test' NB. create new db (~temp/jd/test)
c=: ' year int, sales int, product byte 5,team byte 4'
jd'createtable t1 ',c
jd'reads from t1'
d=: (4#2002 2003 2001);(?12$1000);(>12$2#'shoes';'hats');>12$'blue';'red'
d=: ('year';'sales';'product';'team'),.d
,d NB. list of pairs
jd'insert t1';,d  NB. insert list of pairs
jd'reads from t1' NB. names on top
jd'read  from t1' NB. names on left
jd'info table'
jd'info schema'

''jdae'reads from t7' NB. jdae - accept expected error
jdlast  NB. last error
jdlasty NB. last jd arg 

jd'reads from t1'
jd'reads year,sales from t1'
jd'reads from t1 order by year'
jd'reads from t1 where year<2003'
jd'reads from t1 where year<2003 order by year'
jd'reads from t1 where year<2003 and team="blue"'
jd'reads from t1 where year<2003 and team="blue" or product="hats"'
jd'reads from t1 where year<2000'

jd'reads sum sales from t1'
jd'reads alias:sum sales from t1'
jd'reads sum over sales:sum sales from t1'
jd'reads sum sales by year from t1 order by year'
jd'reads sum sales by team from t1'
jd'reads sum sales by product from t1'
jd'reads sum sales by team,product from t1'
jd'reads sum sales by year,team from t1 order by year'
jd'reads sum sales by year from t1'
jd'reads sum sales,max sales by year from t1'
s=: 'reads sum over sales:sum sales , max over sales:max sales by year from t1'
jd s
jd s,' order by sum over sales' NB. order by uses alias
jd s,' order by max over sales'

NB. worthwhile skimming other basic tutorials
NB. do advanced tutorials as questions come up
NB. ptable tutorial for tables with many rows (300e6 to billions)
