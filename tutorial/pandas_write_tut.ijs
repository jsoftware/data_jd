NB.   jdrt'pandas_load' NB. prerequisite tutorial

load JDP,'tools/pandas/pandas.ijs'

jdadmin :: ('new'&jdadmin) 'pandas_db'

bld=: 3 : 0
jd'droptable foo'
jd'createtable foo'
jd'createcol foo i int'
jd'createcol foo b byte'
jd'createcol foo b3 byte 3'
jd'createcol foo f float'
jd'createcol foo tn edatetimen'
jd'insert foo';'i';1 2 3;'b';'abc';'b3';(3 3$'abcd');'f';(2.3+i.3);'tn';694312540000000000 694312423000000000 694313601000000000
jd'read from foo'
)

bld''

NB. database ; table ; count ; op ; file ; parms
NB. database - jdadmin arg
NB. table    - Jd table to write to file
NB. count    - rows to write - 'all' for all rows
NB. op       - pandas op
NB. file     - file to write
NB. parms    - parameters to pandas op

[pandas_write_ops_jd_ 

pandas_write_jd_ 'pandas_db';'foo';'all';'to_csv';'~temp/tst.csv';''
fread'~temp/tst.csv'

pandas_write_jd_ 'pandas_db';'foo';'all';'to_parquet';'~temp/tst.parquet';''
100{.fread'~temp/tst.parquet'
