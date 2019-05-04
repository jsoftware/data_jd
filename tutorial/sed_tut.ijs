NB. section/employee/region database
NB. Tables
NB.                          r(rno,name;popul)
NB.                          |
NB.               s(sno,sdiv,rnum;name)
NB.               |
NB.       e(ename,secnum)
NB.       |
NB. t(tno,enum,tname,tsize)

jdadmin'sed'
jd'reads from r'
jd'reads from s'
jd'reads from e'
jd'reads from t'
jd'reads ename,s.sno,s.sname,r.rno,r.rname,s.name from e,e.s,s.r'
jd'reads ename,s.sno,s.sname,r.rno,r.rname,s.name from e,e.s,s.r where r.rname="Rome"'
jd'reads from e,e.s,s.r where r.rname="Rome"'
jd'reads from e,e.s where s.sname="Auto"'
jd'reads tno,ename,r.rname from t,t.e,e.s,s.r'
