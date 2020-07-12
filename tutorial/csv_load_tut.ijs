0 : 0
this tutorial will help you load csv files
you load a csv into Jd and, for free, it is in J
maximize ability to work with csv files with minimal Jd knowledge

the utils in this tutorial provide basic support
if you need more, you'll need to dig into Jd!
)

load JDP,'tools/csv_load.ijs' NB. simple csv utils
csvinit'new' NB. create csvload DB - y is 'new' or 'keep' to keep previous stuff

(0 : 0) fwrite '~temp/f.csv' NB. create csv file
123,nut
678,bolt
)
csvprepare 'abc';'~temp/f.csv'
csvload 'abc';0    NB. first row looks like data
jd'reads from abc' NB. labeled columns
jd'read from abc'  NB. labeled rows
'c1'jdfrom_jd_ jd'read from abc'
datatype 'c1'jdfrom_jd_ jd'read from abc'

(3!:1 jd'read from abc')fwrite '~temp/abc.dat' NB. write binary rep to a file
3!:2 fread '~temp/abc.dat' NB. get the data - perhaps in another J session

(0 : 0) fwrite '~temp/g.csv'
part_number,part_name
123,nut
678,bolt
)
csvprepare 'def';'~temp/g.csv'
csvload 'def';1    NB. first row looks like column headers
jd'reads from def' NB. labeled columns

(0 : 0) fwrite '~temp/h.csv'
part <number>,part <name>
123,nut
678,bolt
)
NB. some chars are not allowed in Jd colnames and are replaced by sequences
COLNRPLC_jd_
csvprepare 'ghi';'~temp/h.csv'
csvload 'ghi';1    NB. first row looks like column headers
jd'reads from ghi' NB. labeled columns

csvprepare 'jkl';JDP,'/demo/northwind/csv/Customers.csv'
csvload 'jkl';0    NB. default names
jd'reads from jkl where jdindex<5' NB. read first 5 rows
jd'reads c1,c6 from jkl where jdindex<5' NB. read 2 cols from first 5 rows

NB. you can provide your own col names in a .cnames file
(0 : 0) fwrite CSVFOLDER,'jkl.cnames'
Address
City
CompanyName
ContactName
ContactTitle
Country
CustomerID
Fax
Phone
PostalCode
Region
)

csvprepare 'jkl';JDP,'/demo/northwind/csv/Customers.csv'
csvload 'jkl';2    NB. names from .cnames file
jd'reads from jkl where jdindex<5' NB. read first 5 rows
jd'reads Address,Country from jkl where jdindex<5' NB. read 3 cols from first 5 rows
jd'reads count Address from jkl' NB. number of rows
jd'csvreport jkl'
