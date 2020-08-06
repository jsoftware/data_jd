NB. write/read/dump/restore csv files

jdadminx'test'
jd'gen test f 3'
jd'createcol f edt edatetime _';_1e12,0,1e12
jd'reads from f' NB. edt col iso8601 format
CSVFOLDER=: F=: '~temp/jd/csv/junk/'

NB. csvwr/csvrd
jddeletefolder_jd_ F
jd'csvwr f.csv f'
dir F
fread F,'f.csv'    NB. edt formated as in reads (./, Z/blank)
fread F,'f.cdefs'  NB. parameters required to load f.csv 
jd'csvrd f.csv fx' NB. load f.csv to table fx
jd'reads from fx'
assert (jd'reads from f')-:jd'reads from fx'

NB. epoch cols by default are iso8601 char, but can be int
jd'droptable fx'
jd'csvwr /e f.csv f' NB. /e option - iso6001-int
fread F,'f.csv'      NB. note edt col is ints
fread F,'f.cdefs'    NB. note iso8601-int
jd'csvrd f.csv fx'   NB. load f.csv to table fx
jd'reads from fx'
assert (jd'reads from f')-:jd'reads from fx'

NB. csvdump/csvrestore
jddeletefolder_jd_ F
jd'csvdump'
dir F
jd'dropdb'
jd'createdb'
jd'csvrestore' NB. restore db from csv files
jd'info summary'
jd'reads from f'

NB. csvdump/csvrestore epoch as int (more efficient)
jddeletefolder_jd_ F
jd'csvdump /e'
jd'dropdb'
jd'createdb'
jd'csvrestore' NB. restore db from csv files
jd'reads from f'

NB. csvwr options
jd'csvwr /h1 f.csv f' NB. /h1 writes header of col names
fread F,'f.csv'
fread F,'f.cdefs' NB. options .... 1 - indicates 1 header

jd'csvwr f.csv f byte4 int' NB. wr only two cols 
fread F,'f.csv'

jd'csvwr /w f.csv f byte4 int *int<102' NB. where clause 
fread F,'f.csv'

jd'csvwr f.csv f'
jd'droptable k'  NB. drop table k if it exists
jd'csvrd f.csv k'
jd'reads from k'
jd'droptable k'
jd'csvrd /rows 2 f.csv k' NB. read 2 rows
jd'reads from k'
jd'droptable k'
jd'csvrd /rows 0 f.csv k' NB. /rows 0 reads all rows
jd'reads from k'

NB. csvrd /cdefs option reads cdefs from CDEFSFILE
jd'droptable k'
erase 'CDEFSFILE'
assert 'domain error'-:jd etx'csvrd /cdefs f.csv k'
;1{jdlast
CDEFSFILE=: '~temp/jnk.cdefs'
ferase CDEFSFILE
assert 'domain error'-:jd etx'csvrd /cdefs f.csv k'
;1{jdlast
(fread CSVFOLDER,'f.cdefs')fwrite CDEFSFILE
jd'csvrd /cdefs f.csv k'
jd'reads from k'

jdadminx'test'
jddeletefolder_jd_ F NB. delete .csv and .cdefs files
jd'gen test f 3'
jd'gen test g 2'
'test1'fwrite'test1.ijs',~jdpath_jd_'' NB. db related file(s) - copied by dump/restore

jd'csvdump' NB. dump all tables and scripts
assert 8=#dir F
dir F

jdadminx'test'
jd'csvrestore'   NB. load csv files
jd'csvreport'    NB. summary report on all tables
jd'csvreport f'  NB. report on table f
jd'csvreport /f' NB. full report on all tables
jd'reads from f'
jd'reads from g'

NB. damage data (byte4 field too long) to see how errors are reported
((fread F,'f.csv')rplc 'IJKL';'xxxxyyyy')fwrite F,'f.csv'
jdadminx'test'  NB. recreate test as empty
jd'csvrestore'  NB. load csv files
jd'csvreport'   NB. note ETRUNCATE error

jd'reads from f'
jd'reads from g'

NB. loading new csv files without defs
jdadminx'test'
csvtesta=: 0 : 0
0,23,2.3,a,red,aaaaaaaaaaaaa,2001-03-07 10:58:12,2012-10-10,03-07-2012 10:58:12,10-10-2013
1,24,1.2,b,12324,bbbbbbb,2001-03-07 10:58:13,2012-10-11,03-07-2012 10:58:12,10-10-2013
0,25,2.5,c,1 2,ccc,2001-03-07 10:58:14,2012-10-12,03-07-2012 10:58:12,10-10-2013
)

cnames=: 0 : 0
bools
ints
floats
byte
bytes
varbs
dts
ds
dtxs
dxs
)

jddeletefolder_jd_ F
jdcreatefolder_jd_ F
csvtesta fwrite F,'a.csv'
cnames fwrite F,'a.cnames'
(csvtesta,~LF,~}:cnames rplc LF;',')fwrite F,'aa.csv'

fread F,'a.csv'  NB. just data
fread F,'aa.csv' NB. 1st row is col names header

NB. csvrd csv a.csv will fail because there is no cdefs file to describe columns
'not found' jdae 'csvrd a.csv a'
jdlast

NB. csvdefs samples first 5000 rows to guess col type - this will often be right
NB. but always check csvcdefs result against your knowledge of the data

NB. /replace - replaces x.cdefs if it already exists
NB. /h 0     - csv has no headers to skip
NB. /c       - get colnames from x.cnames
jd'csvcdefs /replace /h 0 /c a.csv'
fread F,'a.cdefs'
jd'droptable a'
jd'csvrd a.csv a'
jd'reads from a'

NB. /replace  - replaces cdefs if it already exists
NB. /h 1      - csv has 1 header to skip
NB. get colnames from file header
jd'csvcdefs /replace /h 1 aa.csv'
fread F,'aa.cdefs'
assert (_15}.fread F,'a.cdefs')-:_15}.fread F,'aa.cdefs' NB. differ only in header value
jd'droptable aa'
jd'csvrd aa.csv aa'
jd'reads from aa'
assert (jd'reads from a')-:jd'reads from aa'

csvtestb=: 0 : 0
b,b2,b3,b4,b5,b6
a,aa,aaa,aaaa,aaaaa,aaaaaa
b,b,b,b,b,b
)

csvtestb fwrite F,'b.csv'
jd'csvcdefs /replace /h 1 b.csv'
[t=. fread F,'b.cdefs' NB. note no varbyte
assert 0=+/'varbyte' E. t
jd'droptable b'
jd'csvrd b.csv b'
jd'read from b' NB. note no varbyte

NB. /v 4 - byte cols in sample rows with more than 4 bytes are treated as varbyte
jd'csvcdefs /replace /h 1 /v 4 b.csv'
[t=. fread F,'b.cdefs' NB. note varbyte
assert 2=+/'varbyte' E. t
jd'droptable bv'
jd'csvrd b.csv bv'
jd'read from bv' NB. note no varbyte

NB. use csvcdef and csvrd to explore the data to refine cdefs

csvtestc=: 0 : 0
abc,123
def,567
ghi,1000
)

csvtestc fwrite F,'c.csv'
NB. /u default cnames for n cols
jd'csvcdefs /replace /h 0 /u c.csv'
fread F,'c.cdefs'
jd'droptable c'
jd'csvrd c.csv c'
jd'reads from c'

csvtestd=: 0 : 0
h1,h2
abc,123
def,567
ghi,1000
)

csvtestd fwrite F,'d.csv'
jd'csvprobe /replace d.csv'
NB. visual inspection shows 1st row is col names
NB. run csvcdefs with /h 1 to get col names
jd'csvcdefs /replace /h 1 d.csv'
fread F,'d.cdefs'
jd'droptable d'
jd'csvrd d.csv d'
jd'reads from d'

csvteste=: 0 : 0
a,,aaa,aaaa,aaaaa,aaaaaa
b,,b,b,b,b
)
NB. col2 has no data and will be treated as byte 1
NB. col7 and later have no data and will be ignored
csvteste fwrite F,'e.csv'
jd'csvcdefs /replace /h 0 /u e.csv'
fread F,'e.cdefs'

NB. null NULL
NB. fields with 'null' (any case) followed by blanks are not used by csvcdefs to determine type

'new'jdadmin'test'

csv=: 0 : 0
name,num,price
"cog",301234,12.34
"nut",null,18.75
"gear",,20.23
"pin",12,Null
)

csv fwrite CSVFOLDER,'f.csv'

jd'csvcdefs /replace /h 1 f.csv'

fread CSVFOLDER,'f.cdefs' NB. num col is int (null treated as ECBADNUM)

jd'csvrd f.csv f'
jd'read from f' NB. note IMIN for int, but (unfortunately) 0 for float
jd'info schema'

0 : 0
csvprobe and csvscan are additional tools for working with csv files
the following steps build a somewhat larger csv file and show
how you would go about getting it loaded with a proper cdefs files
)

jdadminx'test'
bld=: 3 : 0 NB. rows base width
'r b w'=. y
i=. b+i.r
t=. ',',~each":each<"0 i
t=. t,each',',~each":each<"0 i+0.5
t=. t,each<'x,'   NB. col with 1 byte - avoid 0 bytes
t=. t,each<'x,'   NB. col with 1 byte
t=. t,each<'yy,'  NB. col with 2 bytes
t=. t,each<"1 [(r,w)$'abd def' NB. col with different counts
;t,each LF
)

bld 2 100 5
;bld each 2 100 5; 2 200 8

('a,b,c,d,e,f',LF,;bld each 6000 0 5;3 6000 8)fwrite CSVFOLDER,'new.csv'
NB. new.csv has 6003 rows and last 3 rows have last col with more bytes

jd'csvprobe /replace new.csv' NB. read first 12 rows as byte cols for inspection
NB. visual inspection indicates first row is col headers
jd'csvcdefs /replace /h 1 new.csv' NB. create cdefs - based on first 5000 rows
fread CSVFOLDER,'new.cdefs'
NB. note that col f has width 5 - based on first 5000 rows
jd'csvscan new.csv' NB. scan entire file to get proper width
fread CSVFOLDER,'new.cdefs' NB. note width adjusted to 8
jd'csvrd new.csv new'
jd'read count a from new'
assert 6003=;{:jd'reads count a from new'
jd'info schema'
_ _ 0 _ 2 8-:,'shape'jdfroms_jd_ jd'info schema'
'abc' fappend CSVFOLDER,'new.csv' NB. damage the csv file
'ECTOOMUCH' jdae'csvscan new.csv'

NB. try the previous examples without the header row
(;bld each 6000 0 5;3 6000 8)fwrite CSVFOLDER,'new.csv'
jd'csvprobe /replace new.csv' NB. read first 12 rows as byte cols for inspection
NB. visual inspection indicates there are no headers
jd'csvcdefs /replace /u new.csv' NB. create cdefs with default col names
fread CSVFOLDER,'new.cdefs'
NB. note that col f has width 5 - based on first 5000 rows
jd'csvscan new.csv' NB. scan entire file to get proper width
fread CSVFOLDER,'new.cdefs' NB. note width adjusted to 8
jd'droptable new'
jd'csvrd new.csv new'
jd'read count c1 from new'
assert 6003=;{:jd'reads count c1 from new'
jd'info schema'
_ _ 0 _ 2 8-:,'shape'jdfroms_jd_ jd'info schema'



NB. nasty things can happen with incorrect cdefs (that is, not from a csvwr)
NB. if you create a cdefs always csvrd some records and study them carefully
NB. use /rows to read just a few rows before reading all (which may take a long time)
NB. always check csvreport

jddeletefolder_jd_ F
jdadminx'test'
jd'gen ref2 a 10 0 b 5'
[d=. jd'reads from a,a.b'
jd'csvdump'
jdadminx'test'
jd'csvrestore'
assert d-:jd'reads from a,a.b'
