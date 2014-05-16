NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. the reads "from" section
NB. create some tables and references as follows:
NB.               A
NB.              / \
NB.             B   F
NB.            / \ /
NB.           C   E
NB.           |
NB.           D

jdadminx 'ref'
jd 'createtable A           bid int, fid int, word varbyte'
jd 'createtable B   id int, cid int, eid int, word varbyte'
jd 'createtable C   id int, did int,          word varbyte'
jd 'createtable D   id int,                   word varbyte'
jd 'createtable E   id int,                   word varbyte'
jd 'createtable F   id int, eid int,          word varbyte'

jd 'insert A'; ".LF-.~0 :0
'bid';  0 4 2 2 1;
'fid';  3 2 1 1 2;
'word'; <<;._1' red orange yellow green blue'
)
jd 'insert B'; ".LF-.~0 :0
'id';   0 1 2 3;
'cid';  5 2 0 1;
'eid';  0 1 2 3;
'word'; <<;._1' Al Bob Charlie Dan'
)
jd 'insert C'; ".LF-.~0 :0
'id';   0 1 2 3 4;
'did';  1 2 3 4 8;
'word'; <<;._1' C0 C1 C2 C3 C4'
)
jd 'insert D'; ".LF-.~0 :0
'id';   0 1 2 3;
'word'; <<;._1' hammer saw screwdriver wrench'
)
jd 'insert E'; ".LF-.~0 :0
'id';   2 0 1;
'word'; <<;._1' Washington Texas Virginia'
)
jd 'insert F'; ".LF-.~0 :0
'id';   0 1 2;
'eid';  2 0 1;
'word'; <<;._1' first middle last'
)

NB. create references between tables
jd 'reference A bid B id'
jd 'reference A fid F id'
jd 'reference B cid C id'
jd 'reference B eid E id'
jd 'reference C did D id'
jd 'reference F eid E id'

NB. from must contain at least one table, the root.
jd 'reads from A'
NB. other tables included joined from a parent.
jd 'reads from A,A.B'
NB. we can add more tables
jd 'reads from A, A.B, A.F, B.C'
NB. the list of tables doesn't have to be ordered
NB. a table's parent can  come before or after it
jd 'reads from B.C, A, A.F, A.B'
NB. tables can be given aliases
NB. once an alias is given, the table's full name cannot be used.
jd 'reads from t1:A, t2:t1.B, t1.F, t2.C'
NB. we can do multiple joins at once, skipping a table.
jd 'reads from A, A.F.E'
NB. it is possible to reach the same table in two different ways
NB. in this case, an alieas is required to avoid name conflict
jd 'reads from A, E1:A.B.E, E2:A.F.E'
NB. another way to refer to a table is to use the name of the reference
NB. column which connects the current table to the next table
NB. reference columns are named with jdreference_a1_a2_B_b1_b2
NB. where a1 and a2 are referencing columns
NB. and B is the referenced table, and b1 and b2 are the referenced columns
NB. this is required if there are two or more reference columns from A to B
jd 'reads from A, B:A.jdreference_bid_B_id'

NB. above examples used (.) for the default or left1 join
NB. other joins are inner (-), left (>), right (<), and outer (=).

NB. left1 join lists exactly one match for each column on the left (the
NB. last one in the table to the right), or a fill row if there is no match
NB. left1 computes much faster than other joins, but isn't always what is wanted

NB. inner join includes a row for every match between left and right sides

NB. left join contains the rows in the inner join, but also adds a fill row
NB. if one of the items on the left does not match anything

NB. The right join is the same as the left join with the two sides reversed

NB. outer join contains all the rows in either the left or right join
NB. so NB. that all rows on both sides appear at least once

jd 'reads *.word from C, C=D' NB. Outer join
jd 'reads *.word from C, outer C.D' NB. Alternative notation
jd 'reads *.word from C, C>D' NB. Left join
jd 'reads *.word from C, C<D' NB. Right join
jd 'reads *.word from C, C-D' NB. Inner join
