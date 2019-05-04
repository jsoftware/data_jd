NB. reads result can be used to create a table
jdadmin'sandp'
jd'reads from sp'
jd'reads /table abc from sp where sid="S2"' NB. create table abc (replace if already exists)
jd'reads from abc'
jd'reads from sp,sp.p'
jd'reads from sp,sp.p where sp.sid="S1" and p.color ne "Green"'
jd'reads /table viewall from sp,sp.p where sp.sid="S1" and p.color ne "Green"'
jd'reads from viewall' NB. . in col names replaced by __
jd'reads /table viewsome  sp.sid,p.color,p.city  from sp,sp.p where sp.sid="S1" and p.color ne "Green"'
jd'reads from viewsome'
