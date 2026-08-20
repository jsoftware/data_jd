NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. section/employee/region database
NB. Tables
NB.                          r(rno,name;popul)
NB.                          |
NB.               s(sno,sdiv,rnum;name)
NB.               |
NB.       e(ename,secnum)
NB.       |
NB. t(tno,enum,tname,tsize)

sed_tests=: 3 : 0
drd'from r order by rno'
drd'from s order by name,sname'
drd'from e order by ename'
drd'from t order by tno'
drd'ename,s.sno,s.sname,r.rno,r.rname,s.name from e,e.s,s.r order by ename'
NB. dassert'ename';6 12 fixr 'Smith Jones Robinson Jasper Steinberg Rafferty '
dassert's.sno';33 33 31 34 34 33;6 1
NB. dassert'r.rno';6 5 6 5 5 4;6 1
NB. dassert'r.rname';6 12 fixr 'Naples Rome Naples Rome Rome Naples'
NB. dassert's.name';6 12 fixr 'Clerical Engineering Clerical Engineering Engineering Sales'
drd'ename,s.sno,s.sname,r.rno,r.rname,s.name from e,e.s,s.r where r.rname="Rome" order by ename'
NB. dassert 'ename';'Jones Jasper Steinberg'
NB. dassert 's.sno';33 33 33;3 1
NB. dassert 's.sname';3 12 fixr 'Truck Truck Truck'
NB. dassert 'r.rno';5 5 5;3 1
NB. dassert 'r.rname';3 12 fixr 'Rome Rome Rome'
NB. dassert 's.name';3 12 fixr 'Engineering Engineering Engineering'
drd'from e,e.s,s.r where r.rname="Rome" order by e.ename'
NB. dassert 'e.ename';3 12 fixr 'Jones Jasper Steinberg'
NB. drd'from e,e.s where s.sname="Auto"'
NB. dassert 'e.ename';3 12 fixr 'Smith Robinson Rafferty'
drd'tno,ename,r.rname from t,t.e,e.s,s.r order by tno' 
NB. dassert 'ename';4 12 fixr 'Jones Jasper Smith Jones'
NB. dassert 'tno';11 12 13 14;4 1
)

jdadmin'sed'
ALLR=: ''
sed_tests''
ALLRSED=: ALLR

jdadmin'sed_shuffle'

ALLR=: ''
sed_tests''
ALLRSEDSHUFFLE=: ALLR

assert ALLRSED-:ALLRSEDSHUFFLE
