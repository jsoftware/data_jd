NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. demos built by jdtests''

NB. C.J.Date's suppliers and parts database (sandp)
NB. data matches that in the SQLite addon

setdemodb'sandp'

drd'from j'
dassert 'city';7 10 fixr 'Paris Rome Athens Athens London Oslo London'
drd'from p'
dassert 'city';6 10 fixr 'London Paris Oslo London Paris London'
drd'from s'
dassert 'city';5 10 fixr 'London Paris Paris London Athens'
drd'from sp'
dassert 'pid';12 3 fixr 'P1 P2 P3 P4 P5 P6 P1 P2 P2 P2 P4 P5'
drd'from spj'
dassert 'pid';24 3 fixr 'P1 P1 P3 P3 P3 P3 P3 P3 P3 P5 P3 P4 P6 P6 P2 P2 P5 P5 P6 P1 P3 P4 P5 P6'
drd'from sp where sid="S1" and qty > 250'
dassert 'qty';300 400;2 1
dassert 'sid';2 3 fixr 'S1 S1'
drd'pid,qty from sp where pid="P2"'
dassert 'qty';200 400 200 200;4 1
drd'sp.sid,sp.pid,sp.qty,s.city,p.city from sp,sp.s,sp.p where s.city=p.city'
dassert 's.city';6 10 fixr 'London London London Paris Paris London'
dassert 'p.city';6 10 fixr 'London London London Paris Paris London'
dassert 'sp.qty';300 200 100 400 200 300;6 1
drd'job_cnt:count jname by city from j'
dassert 'job_cnt';1 1 2 2 1;5 1
drd'sum weight by color from p where city<>"Paris"'
dassert 'color';2 10 fixr 'Red Blue'
dassert 'weight';45 17;2 1
drd'sum weight by color,city from p'
dassert 'weight';45 17 17 12;4 1
drd'avg weight by city,color from p'
dassert 'weight';15 17 17 12;4 1
drd'avg weight,pone:first pid by where:city,color from p'
dassert 'where';4 10 fixr 'London Paris Oslo Paris'
dassert 'pone';4 3 fixr 'P1 P2 P3 P5'
drd'min_st:min status by city from s'
dassert 'min_st';20 10 30;3 1
dassert 'city';3 10 fixr 'London Paris Athens'
drd'sum p.weight,min s.status by supplier:s.city from sp,sp.s,sp.p'
dassert 'supplier';2 10 fixr 'London Paris '
dassert 'p.weight';134 46;2 1
dassert 's.status';20 10;2 1
drd'sum p.weight by supp:s.city,part:p.city from sp,sp.s,sp.p'
dassert 'supp';5 10 fixr 'London London London Paris Paris'
dassert 'part';5 10 fixr 'London Paris Oslo London Paris'
dassert 'p.weight';59 58 17 12 34;5 1
drd'avg_qty:avg qty by supp:s.sname,part:p.city from spj,spj.s,spj.p order by avg_qty'
dassert 'supp';9 10 fixr 'Jones Blake Adams Adams Clark Adams Jones Smith Blake'
dassert 'part';9 10 fixr 'Paris Oslo Oslo Paris London London Oslo London London'
dassert 'avg_qty';100 200 200 260 300 400 442.85714285714283 450 500;9 1
drd'avg_qty:avg qty by part_col:p.color from spj,spj.p'
dassert 'part_col';3 10 fixr 'Red Blue Green'
dassert 'avg_qty';400 353.84615384615387 150;3 1
