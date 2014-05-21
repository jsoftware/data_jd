NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. demos built by jdtests''

NB. section/employee/region database
NB. Tables
NB.                          r(rno,name;popul)
NB.                          |
NB.               s(sno,sdiv,rnum;name)
NB.               |
NB.       e(ename,secnum)
NB.       |
NB. t(tno,enum,tname,tsize)

load'~addons/data/jd/demo/common.ijs'
setdemodb'sed'

drd'from r'
drd'from s'
drd'from e'
drd'from t'
drd'ename,s.sno,s.sname,r.rno,r.rname,s.name from e,e.s,s.r'
dassert'ename';6 12 fixr 'Smith Jones Robinson Jasper Steinberg Rafferty '
dassert's.sno';34 33 34 33 33 31;6 1
dassert'r.rno';6 5 6 5 5 4;6 1
dassert'r.rname';6 12 fixr 'Naples Rome Naples Rome Rome Naples'
dassert's.name';6 12 fixr 'Clerical Engineering Clerical Engineering Engineering Sales'
drd'ename,s.sno,s.sname,r.rno,r.rname,s.name from e,e.s,s.r where r.rname="Rome"'
dassert 'ename';3 12 fixr 'Jones Jasper Steinberg'
dassert 's.sno';33 33 33;3 1
dassert 's.sname';3 12 fixr 'Truck Truck Truck'
dassert 'r.rno';5 5 5;3 1
dassert 'r.rname';3 12 fixr 'Rome Rome Rome'
dassert 's.name';3 12 fixr 'Engineering Engineering Engineering'
drd'from e,e.s,s.r where r.rname="Rome"'
dassert 'e.ename';3 12 fixr 'Jones Jasper Steinberg'
drd'from e,e.s where s.sname="Auto"'
dassert 'e.ename';3 12 fixr 'Smith Robinson Rafferty'
drd'tno,ename,r.rname from t,t.e,e.s,s.r'
dassert 'ename';4 12 fixr 'Jones Jasper Smith Jones'
dassert 'tno';11 12 13 14;4 1
