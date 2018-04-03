NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. C.J.Date's suppliers and parts database (sandp)
NB. data matches that in the SQLite addon

sandp_tests=: 3 : 0
drd'from j order by jid'
dassert 'city';'Paris     Rome      Athens    Athens    London    Oslo      London    ';7 10
drd'from p order by pid'
dassert 'city';'London    Paris     Oslo      London    Paris     London    ';6 10
drd'from s order by sid'
dassert 'city';'London    Paris     Paris     London    Athens    ';5 10
drd'from sp order by sid,pid'
dassert 'pid';'P1 P2 P3 P4 P5 P6 P1 P2 P2 P2 P4 P5 ';12 3
drd'from spj order by jid,pid,sid'
dassert 'qty';200 400 200 200 200 500 100 200 200 300 700 100 100 500 200 800 400 500 600 500 400 800 100 300;24 1
drd'from sp where sid="S1" and qty > 250 order by sid,pid'
dassert 'qty';300 400;2 1
drd'pid,qty from sp where pid="P2" order by qty'
dassert 'qty';200 200 200 400;4 1
drd'sp.sid,sp.pid,sp.qty,s.city,p.city from sp,sp.s,sp.p where s.city=p.city order by sp.sid,sp.pid'
dassert 'sp.qty';300 200 100 400 200 300;6 1
drd'job_cnt:count jname by city from j order by city'
dassert 'job_cnt';2 2 1 1 1;5 1
drd'sum weight by color from p where city<>"Paris" order by weight'
dassert 'weight';17 45;2 1
drd'sum weight by color,city from p order by color,city'
dassert 'weight';17 12 17 45;4 1
drd'avg weight by city,color from p order by color,city'
dassert 'weight';17 12 17 15;4 1

drd'avg weight,pone:first pid by where:city,color from p order by pone'
NB. can not validate shuffle (random and first)
if. 'sandp'-:DB_jd_ do. 
 dassert 'where';'London    Paris     Oslo      Paris     ';4 10
 dassert 'pone';'P1 P2 P3 P5 ';4 3
end.
ALLR=: }:ALLR NB. remove as result will differ because of shuffle vs first
drd'min_st:min status by city from s order by city'
dassert 'min_st';30 20 10;3 1
drd'sum p.weight,min s.status by supplier:s.city from sp,sp.s,sp.p order by supplier'
dassert 'supplier';'London    Paris     ';2 10
dassert 'p.weight';134 46;2 1
dassert 's.status';20 10;2 1
drd'sum p.weight by supp:s.city,part:p.city from sp,sp.s,sp.p order by p.weight'
dassert 'p.weight';12 17 34 58 59;5 1
drd'avg_qty:avg qty by supp:s.sname,part:p.city from spj,spj.s,spj.p order by supp,part'
dassert 'supp';'Adams     Adams     Adams     Blake     Blake     Clark     Jones     Jones     Smith     ';9 10
dassert 'part';'London    Oslo      Paris     London    Oslo      London    Oslo      Paris     London    ';9 10
dassert 'avg_qty';400 200 260 500 200 300 442.85714285714283 100 450;9 1
drd'avg_qty:avg qty by part_col:p.color from spj,spj.p order by part_col'
dassert 'avg_qty';353.84615384615387 150 400;3 1
)

jdadmin'sandp'
ALLR=: ''
sandp_tests''
ALLRSANDP=: ALLR

jdadmin'sandp_shuffle'
ALLR=: ''
sandp_tests''
ALLRSANDPSHUFFLE=: ALLR

assert ALLRSANDP-:ALLRSANDPSHUFFLE
