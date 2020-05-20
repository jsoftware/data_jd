jdadmin'sandp'

jd'reads from j'
jd'reads count jname from j'
jd'reads count jname by city from j'     NB. by col
jd'reads cnt:count jname by city from j' NB. alias

jd'reads from p'
jd'reads avg weight by color from p'
jd'reads avg_wt:avg weight by color from p'
jd'reads avg_wt:avg weight,max_wt:max weight by color from p'
jd'reads avg_wt:avg weight,max_wt:max weight by city,color from p'

NB. aliases are particularly useful with different aggregations to a column

NB. full syntax for an aggregation is:
NB.   Aggregation(,Aggregation)* by column(,column)*
NB.   Aggregation: [alias:] aggregator column

jd'info agg' NB. db aggregation functions

NB. first and last are the first and last occurrences in the table
NB. sorting is after aggregation, so not affected by "order by"

jdadminx'test'
jd'createtable f a int'
jd'insert f a';_1,(i.4),_1
jd'reads from f'
jd'reads count a from f'

NB. db custom aggregations fns are defined in db custom.ijs
NB. define avgnonneg to ignore negative values (null) in getting the average

custom=: 0 : 0
aggavgx=: 3 : '(+/t)%#t=. (y>:0)#y'
aggavgx addagg 'avgnonneg'
)

custom fwrite '~temp/jd/test/custom.ijs'
jdloadcustom_jd_'' NB. load changes

jd'info agg'
jd'reads avg-non-neg:avgnonneg a,avg:avg a from f'
