NB. performance for big tables

0 : 0
Generalizations and guidelines on performance are necessarily rough
and depend on table data, schema, etc.

Performance depends mostly on J being able to work with the required
data (col data, temp copies, etc.) in ram without paging.

In simplest terms, performance depends on ram vs table rows.
Typically cols that most affect performance have elements that are
8 bytes (int and ref cols, rather than wide byte cols) so the size
that matters is probably (8*rows) bytes.

If ram is > 7 times size (8*rows), performance is probably good.
If ram is < 6 times size, performance is probably bad.

>7 allows working with more than a single col, temps, etc.
<6 can easily get caught in page thrash that kills performance.

8*100e6 rows is 0.8 gb
0.8*6 7 is 4.8 5.6 which hints that table(s) with 100e6 rows
would perform badly wtih 4gb ram and OK with 6gb

8*500e6 rows is 4 gb
4*6 7 is 24 28 which hints that table(s) with 500e6 rows
would perform OK with 24gb ram.

Utilities in this tutorial can be used to run tests of common
operations at difference row counts to see how they perform on 
your hardware. In general performance should be OK within the 
limits given above. And if you push much beyond you will start to see
thrash in some of the operations.
)

setsize=: 3 : 0
assert (y>0)*.y<:2000
SIZE=: y
)

CSVFOLDER=: '~temp/jd/csvjdpm'

NB. create tables for simple performance tests
NB. cr 1 - create table f with 1e6 rows
NB. table g is created with 1e6 rows
cr=: 3 : 0
n=. SIZE*1e6
jdadmin 0
jdcreatefolder_jd_'~temp/jdpm'
jdadminx'~temp/jdpm/','d',(":y)
pmclear_jd_''
a=. (n$3,<.2^34)+i.n NB. avoid small int range hashing
b=. 5*i.>FORCELEFT_jd_{1e6;1000 NB. left join y=/x out of memory
jd'createtable f'
jd'createcol  f a  int _';a
jd'createcol  f b  int _';n$b  NB. ref f b g b - many to one
jd'createcol  f c  int _';i.n  NB. data

jd'createtable g'
jd'createcol  g b int _';|.b
i.0 0
)

rf=: 3 : 0
jd'ref f b g b'
i.0 0
)

rd=: 3 : 0
jd'reads from f,f.g where c=7'
)

run=: 3 : 0
pmclear_jd_'' NB. clear and start recording
setsize y
cr''
rf''
rd''
pmclear_jd_ 0 NB. stop recording
pmr_jd_''
)

csv=: 3 : 0
pmclear_jd_'' NB. clear and start recording
jd'csvdump /replace'
jd'csvrestore /replace'
pmclear_jd_ 0 NB. stop recording
pmr_jd_''
)

pmhelp_jd_

run 2 NB. create table f with 2e6 rows
jd'info summary'
jd'info schema'
jd'info ref'
csv'' NB. dump and restore database

0 : 0
with 6gb ram on an average processor:
 50 100 150 200 250 300 - run arg
 30 64  198 255 667 842 - seconds
 
run with 200 is fast and still nearly linear
but slows quickly with large args

although run 200 is fast, it is very simple and
not indicative of performance with complicated schema and queries
limiting to about 100e6 rows with 6gb rows is likely to peform well
)

0 : 0
with 24gb ram on a faster processor:
 400 500 600 700 800 900 1000 - run arg
 133 163 198 366 394 457  537 - seconds
 
run with 1000 is fast and still nearly linear
but slows quickly with larger args

although run 1000 is fast, it is very simple and
not indicative of performance with complicated schema and queries
limiting to about 500e6 rows with 24gb rows is likely to perform well
)
