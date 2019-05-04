
jdadminnew'tutorial'
jd'gen test f 10'
jd'reads from f'
jd'delete f';3 5
jd'reads from f'
jd'delete f';'x<3'
jd'reads from f'
jd'key /in f';'int';104 107               NB. key selects 2 rows 
jd'delete f';'int';104 107
jd'reads from f'
jd'key /in f';'int';108 109;'boolean';1 1 NB. key selects 1 row
jd'delete f';'int';108 109;'boolean';1 1  NB. delete row(s) selected by key
jd'reads from f'
'access'jdadmin''
