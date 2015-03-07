NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. demos built by jdtests''

NB. C.J.Date's suppliers and parts database (sandp)
NB. data matches that in the SQLite addon

'run jdtests_jd_ to create demos' assert 'database'-:jdfread_jd_'~temp/jd/sandp/jdclass'
jdadmin'sandp'
jd'reads from j'
jd'reads from p'
jd'reads from s'
jd'reads from sp'
jd'reads from spj'
jd'reads from sp where sid="S1" and qty > 250'
jd'reads pid,qty from sp where pid="P2"'
jd'reads sp.sid,sp.pid,sp.qty,s.city,p.city from sp,sp.s,sp.p where s.city=p.city'
jd'reads job_cnt:count jname by city from j'
jd'reads sum weight by color from p where city<>"Paris"'
jd'reads sum weight by color,city from p'
jd'reads avg weight by city,color from p'
jd'reads avg weight,pone:first pid by where:city,color from p'
jd'reads min_st:min status by city from s'
jd'reads sum p.weight,min s.status by supplier:s.city from sp,sp.s,sp.p'
jd'reads sum p.weight by supp:s.city,part:p.city from sp,sp.s,sp.p'
jd'reads avg_qty:avg qty by supp:s.sname,part:p.city from spj,spj.s,spj.p order by avg_qty'
jd'reads avg_qty:avg qty by part_col:p.color from spj,spj.p'
