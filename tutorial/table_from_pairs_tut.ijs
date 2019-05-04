NB. create table from pairs
jdadminx'test'
jd'createtable /pairs f';'a';'abc';'b';1 2 3;'c';3 4$'qwerty'
jd'reads from f'

NB. type implicit from simple examination of data
jdadminx'test'
jd'createtable /pairs f';'a';1 2;'b';'1990-06-02',:'1990-07-12'
jd'reads from f'
jd'info schema f' NB. b is byte 10

NB. type explicit from name(type)
jdadminx'test'
jd'createtable /types /pairs f';'a(int)';1 2;'b(edate)';'1990-06-02',:'1990-07-12'
jd'reads from f'
jd'info schema f' NB. b is edate

NB. read[s] can provide explicit type
[jd'read /types from f'

NB. create table from pairs read from another table
NB. read  result is pairs (just needs ,)
NB. reads result is less convenient and the format has lost info (shape and varbyte)
jdadmin'sandp'
[d=. jd'read /types sp.sid,sp.pid,sp.qty,s.city,p.city from sp,sp.s,sp.p where s.city=p.city'
jd'createtable /types /pairs test';,d
jd'reads from test' NB. . replaced by __
jd'droptable test'
