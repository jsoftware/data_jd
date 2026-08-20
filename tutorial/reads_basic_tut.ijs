
jdadmin'sandp' NB. use sandp demo database

jd'reads from p'

NB. reads is complicated and this tutorial has only simple examples
NB. run reads_... for details on specific features

NB. reads [OPTIONS] [SELECT] from FROM [where WHERE] [order by ORDER BY]

NB. OPTIONS
jd'reads /lr from p' NB. labeled rows

NB. SELECT
jd'reads                            from p'
jd'reads color,weight               from p'
jd'reads avg weight                 from p' NB. aggregation
jd'reads avg wt:avg weight          from p' NB. alias
jd'reads avg wt:avg weight by color from p' NB. by


NB. FROM
jd'reads from p'
jd'reads from sp'
jd'reads from sp,sp.p' NB. sp has been joined to p (sp.pid -> p.pid) 

NB. WHERE
jd'reads from p'
jd'reads from p where color="Red"'
jd'reads from p where color="Red" and weight>12'

NB. ORDER BY
jd'reads from p'
jd'reads from p order by city'
jd'reads from p order by city desc'
