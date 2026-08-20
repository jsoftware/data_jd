NB. update/upsert/delete/join
jdadminnew'test' NB. create new db (~tmep/jd/test)
d=: (4#2002 2003 2001);(?12$1000);(>12$2#'shoes';'hats');>12$'blue';'red'
d=: ('year';'sales';'product';'team'),.d
jd'createtable /pairs t1 ';,d NB. col names, types, shapes from pairs
jd'reads from t1'
jd'insert t1';'year';2004;'sales';999;'product';'socks';'team';'red'
jd'reads from t1 where year>=2003'
jd'reads *,jdindex from t1' NB. jdindex is table row index
d=: jd'read jdindex,sales from t1 where year=2002'
'index sales'=: ,{:"1 d
index
sales
jd'reads from t1 where year=2002'
jd'update t1';index;'sales';sales+1
jd'reads from t1 where year=2002'

jd'reads from t1 where year in (2002,2005)'
p=: 'year';2002 2005;'sales';5000 6000;'product';(>'shoes';'hats');'team';>'blue';'blue'
NB. upsert uses key (year product team) to update existing row or insert new row
jd'upsert t1';'year product team';p
jd'reads from t1 where year in (2002,2005)'

jd'reads from t1 order by year'
jd'delete t1 year=2001 or product="socks"'
jd'reads from t1 order by year'

jd'createtable t2 team byte 4,contact byte 10'
jd'insert t2';'team'; (>'blue';'red');'contact';>'4161231234';'7051231235'
jd'reads from t2'
jd'ref t1 team t2 team' NB. join t1 to t2
jd'info table'
jd'info ref' NB. table t1 col jdref_team_t2_team joins t1 to t2
jd'reads from t1,t1.t2'
jd'reads sum sales,first t2.contact by year,team from t1,t1.t2 order by sales'
jd'reads from t1,t1.t2 where t2.contact="7051231235"'
