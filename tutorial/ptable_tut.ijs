
0 : 0
A ptable (partition table) is logically a single table that is
physically made up of parts (multiple tables).

You work with a ptable just as you would with any other table.

Each part of a ptable has the same schema and is in fact a Jd table,
but you rarely, if ever work with individual parts.

Ptable pcol (partition col) is an int or edate col that determines
which part a ptable row is in. All part rows have the same pcol value.

A ptable can perform much better than a normal table.
Insert only affects parts indicated in the pcol of the new data.
Read only affects parts selected by the where clause.

Consider a ptable with 1e9 rows with an edate pcol. If the ptable
had 3 years of data that could be divided into roughly equal size
daily sets, then the ptable would have about 1000 parts each with
about 1e6 rows.

If most changes affected one part (e.g., the most recent) then
changes to that small part table would be much faster than changes
to a large normal table.

If most reads, as restricted by the where clause, were from a small
number of parts, then access would be much faster than from a large
normal table.

This tutorial shows how to work with ptables.
)

bld=: 3 : 0
jdadminx'test'
jd'createtable f'
jd'createcol f edt edate'
jd'createcol f val int'
jd'createcol f x int'
jd'createcol f k int'
jd'createptable f edt' NB. turn normal table into ptable with pcol edt
)

bld''
jd'reads from f'

gd=: 3 : 0 NB. data for insert
'edt';(y#>(<'2016-01-'),each (2":each<"0[>:i.#y)rplc each <' ';'0');'x';((+/y)$<.100*6!:1'');'val';((+/y)$i.3);'k';(0{,;{:jd'reads count k from f')+i.+/y
)

NB. insert creates parts as required - rows inserted to the relevant part
jd'insert f';gd 1 2 3   NB. 1 2 3 rows each for days 1 2 3
jd'reads from f'
jd'insert f';gd 5 4 3 2 NB. 5 4 3 2 rows each for days 1 2 3 4
jd'reads from f'
jd'info table'
jd'info schema'
jd'info summary'

0 : 0
f acts like a normal table - but is implemented as a number tables
normally you do not work with the parts, but they are there and it
can be instructive to understand what they are
)

jd'info table f^*'        NB. tables that make up ptable f
jd'reads from f^'         NB. f; has the sorted nub of the pcol values
jd'reads from f^20160101' NB. rows in this part - note pcol edate maps to yyyymmdd 

NB. reads from f can be from all parts
NB. or from just parts selected by the where clause
NB. where expressions on pcol can restrict the query to certain parts
jd'reads from f where val=0' NB. must read all parts - relatively slow
jd'info last' NB. accessed 4 (all) parts
jd'reads from f where val=0 and edt="2016-01-03"'
jd'info last' NB. read only 1 part - relatively fast
jd'reads from f where edt="2016-01-03" and val=0' NB. same as previous
jd'info last'
jd'reads from f where val=0 and edt in ("2016-01-01","2016-01-03")'
jd'info last'
jd'reads from f where val=0 and edt >= "2016-01-01" and edt <= "2016-01-03"'
jd'info last'

NB. update works as expected
jd'reads from f where edt="2016-01-02" and val=2'
jd'update f';'edt="2016-01-02" and val=2';'val';3 3 3
jd'reads from f where edt="2016-01-02"'
jd'update f';'edt="2016-01-02" and val=3';'val';2 2 2
jd'reads from f where edt="2016-01-02"'
jd'info summary' NB. note deleted rows from updates
jd'update f';'edt="2016-01-02" and val=2';'val';3 3 3
jd'reads from f where edt="2016-01-02"'
jd'update f';'edt="2016-01-02" and val=3';'val';2 2 2
jd'info summary' NB. modify does not delete any rows

NB. upsert works as epxected
data=: 'edt';(3 10$'2016-01-022016-01-022016-01-05');'val';1 2 9;'x';666 777 999;'k';13 99 123
jd'upsert f';'edt k';data
assert 666 777 999=,>{:jd'reads x from f where k in (13,99,123)'

NB. jdindex works as expected
jd'reads jdindex,* from f where val=0 and edt >= "2016-01-01" and edt <= "2016-01-03"'
jd'reads from f where jdindex=9'
NB. where jdindex expressions are not smart in restricting parts accessed
jd'info last' NB. accessed all parts - this could be made smarter

NB. ptable aggregations, by, and order by work the same as for a normal table
jd'reads count x:count x by edt from f where edt>"2016-01-02" order by count x' 
jd'reads sum x:sum x by edt from f where edt>"2016-01-02" order by sum x' 
jd'reads sum x:sum x,count x:count x by edt from f where edt>"2016-01-02" order by sum x' 
jd'reads avg x:avg x by edt from f where edt>"2016-01-02" order by avg x' 

NB. renamecol, dropcol, createcol,renametable work as expected
jd'renamecol f val foo'
jd'reads from f where jdindex=5'
jd'renamecol f foo val'
jd'createcol f boo int'
jd'reads from f where jdindex=5'
jd'dropcol f boo'
jd'renametable f goo'
jd'reads from goo where jdindex<3'
jd'renametable goo f'
jd'reads from f'

NB. ptable can join to other tables with ref
jd'droptable j'
jd'createtable j'
jd'createcol j val int'
jd'createcol j y int'
jd'insert j';'val';0 1 2;'y';23 24 25
jd'ref f val j val'
jd'reads from f,f.j'
jd'reads from f,f.j where edt="2016-01-02"'

NB. csv
jd'dropcol f jdref_val_j_val'
jd'droptable g'
CSVFOLDER=: '~temp/jd/csv/ptable'
jddeletefolder_jd_ CSVFOLDER
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert ({:jd'reads from f')-:{:jd'reads from g'
jd'info table g^*' NB. g is a ptable
dir CSVFOLDER NB. csvwr wrote csv files for each part
jddeletefolder_jd_ CSVFOLDER
jd'csvwr /combine fx.csv f' NB. combine parts into single csv file
dir CSVFOLDER
