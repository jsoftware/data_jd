NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

'new'jdadmin'tutorial'
jd'gen ref2 a 3 1 b 2'
jd'reads from a'
jd'reads from a order by akey desc'
jd'reads from a order by aref'
jd'reads from a order by aref,akey'
jd'reads from a order by aref desc,akey' 
jd'reads from b'
jd'reads akey,adata from a'
jd'reads from a,a.b'
jd'reads from a where akey<3'
jd'reads from a,a.b where akey<3 and b.bref=0'
jd'reads asdf:b.bb12 from a,a.b where akey<3 and b.bref=0'
jd'reads sum adata from a where akey>0'
jd'reads sum adata by aref from a'
