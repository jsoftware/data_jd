NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

0 : 0
this tutorial gives an overview of Jd features
 creates a db, tables, and columns
  inserts and updates data
   runs queries with where clauses, aggregations, and joins
    and more
)
jdadminx'test' NB. create new db test (~temp/jd/test)

jd'createtable t1 year int, sales int, product byte 5, team byte 4'

year=: 2#2002 2003 2001
sales=: ?6$1000
product=: 6 5$'shoes'
team=: >(6$i.2){'blue';'red'

jd'insert t1';'year';year;'sales';sales;'team';team;'product';product
jd'reads from t1'

sales=: ?6$1000
product=: 6 5$'hats '
jd'insert t1';'year';year;'sales';sales;'team';team;'product';product
jd'reads from t1'
jd'read  from t1' NB. col name row header
jd'reads year,team,sales from t1'
jd'reads from t1 order by year'

jd'reads from t1 where year<2003'
jd'reads from t1 where year<2003 and team="blue"'
jd'reads from t1 where year<2003 and team="blue" and product="hats"'

jd'reads sum sales from t1'
jd'reads sum sales by year from t1 order by year'
jd'reads sum sales by team from t1'
jd'reads sum sales by product from t1'
jd'reads sum sales by year,team from t1 order by year'
jd'reads sum sales by year,product from t1 order by year'
jd'reads sum sales by team,product from t1'

jd'reads sum sales:sum sales by year from t1'
jd'reads sum sales:sum sales,max sale:max sales by year from t1'
jd'reads sum sales:sum sales,max sale:max sales by year,team from t1 order by max sale'

jd'reads sum sales by year,team from t1 order by year'
jd'reads sum sales:sum sales by year,team from t1 order by sum sales'
jd'reads sum sales:sum sales,max sale: max sales by year,team from t1 order by sum sales'

jd'createtable t2 team byte 4,contact byte 10'
jd'insert t2';'team'; (>'blue';'red');'contact';>'4161231234';'7051231235'
jd'reads from t2'

jd'ref t1 team t2 team' NB. join t1 to t2

jd'reads from t1,t1.t2'

jd'reads sum sales:sum sales,phone:first t2.contact by year,team from t1,t1.t2 order by sum sales'

jd'reads from t1,t1.t2 where year=2004'
jd'insert t1';'year';2004 2004;'team';(>'red';'blue');'sales';23 123;'product';>'hats';'shoes'
jd'reads from t1,t1.t2 where year=2004'

jd'reads from t1,t1.t2 where year=2004 and team="red"'
jd'reads from t1       where year=2004 and team="red"'

jd'update t1';'year=2004 and team="red"';'sales';33
jd'reads from t1       where year=2004 and team="red"'

jd'read jdindex,* from t1 where year=2004 and team="red"' NB. jdindex is table row index
[i=. ,'jdindex' jdfrom_jd_ jd'read jdindex,* from t1 where year=2004 and team="red"'

jd'reads from t1 where jdindex=',":i
jd'update t1';i;'sales';44 NB. update where clause can be indexes
jd'reads from t1 where jdindex=',,":i

jd'reads from t1 where year=2002'
jd'read jdindex,sales from t1 where year=2002'
'index sales'=: ,{:"1 jd'read jdindex,sales from t1 where year=2002'
index
sales
jd'update t1';index;'sales';sales+1
jd'reads from t1 where year=2002'

jd'reads from t1,t1.t2 order by t1.year'
jd'delete t1 year=2001'
jd'reads from t1,t1.t2 order by t1.year'

jd'gen test f 5' NB. generate test table f with 5 rows
jd'reads from f'
jd'reads /lr from f' NB. labeled rows (same as read)

jd'gen ref2 a 10 0 b 5' NB. test tables a and b with a joined to b
jd'reads from a,a.b'

jdadmin 0 NB. remove admin - no db available
jd etx 'reads from t1 where year<2003 and team="blue" and product="hats"'
jdlast

jdadmin'test' NB. admin for db test
jd'reads from t1 where team="blue" and product="hats"'

jd'info table'
jd'info schema'
jd'info schema t1'

jd'dropdb'
jd etx 'reads from t1'
jdlast
jd 'createdb'
jd'info schema'

jd 'createtable food'  NB. oops, typo
jd 'droptable food'
jd 'createtable foo'

jd 'createcol foo color varbyte'
jd 'createcol foo n0 int' 
jd 'createcol foo n1 int'
jd 'createcol foo n2 int'
jd 'reads from foo'

jd 'insert foo'; , (;:'color n0 n1 n2') ,. (<'blue');8;1;600
jd 'reads from foo'
jd 'insert foo'; , (;:'color n0 n1 n2') ,. ('red';'green';'grey');2 6 3;1 1 1;800 90 234
jd 'reads from foo'

jd 'dropcol foo n1'
jd 'reads from foo'
jd 'delete foo';'color = "green"' NB. delete the rows where color is green
jd 'reads from foo'

jd 'update foo';'color in ("blue","red")'; 'n2';621 778
jd 'reads from foo'

0 : 0
probably worthwhile to at least skim the other basic tutorials
do advanced tutorials as questions and issues come up
ptable tutorial is relevant for tables with many rows (200e6 to billions)
)