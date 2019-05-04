NB. the reads "from" section
NB. create some tables and refs as follows:
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

NB. create ref between tables
jd 'ref A bid B id'
jd 'ref A fid F id'
jd 'ref B cid C id'
jd 'ref B eid E id'
jd 'ref C did D id'
jd 'ref F eid E id'

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
NB. in this case, an alias is required to avoid name conflict
jd 'reads from A, E1:A.B.E, E2:A.F.E'
