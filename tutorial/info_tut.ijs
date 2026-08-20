jdadminnew'test'
jd'gen ref2 a 3 0 b 2' NB. gen ref2 tables a and b jointed
jd'reads from a,a.b'
jd'info table'
jd'info summary'
jd'info summary b'
jd'info schema'
jd'info schema a'
jd'info schema a aref'
jd'info ref'       NB. table a reference - joins aref to b bref
jd'info agg'       NB. aggregations
jd'reads from a'
jd'info last'            NB. performance data
jd'info validate a'      NB. validate table
jd'info validate a aref' NB. validate table col
jd'info validatebad a'   NB. report problems
