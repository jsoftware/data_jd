0 : 0
this tutorial will help you load csv files
you load a csv into Jd and, for free, it is in J
maximize your ability to work with csv files
with minimal Jd knowledge

utils in this tutorial provide basic support
if you need more, you'll need to dig into Jd!
)

load JDP,'tools/csv_load.ijs'

(0 : 0) fwrite '~temp/f.csv' NB. create csv file
123,nut
678,bolt
)

csvprepare 'abc';'~temp/f.csv' NB. table_name ; csv_file
csvload 'abc';0    NB. first row looks like data
jd'reads from abc' NB. labeled columns
jd'read from abc'  NB. labeled rows
1{::0{jd'read from abc'
jd'read c2 from abc'

(3!:1 jd'read from abc')fwrite '~temp/abc.dat' NB. write binary rep file
3!:2 fread '~temp/abc.dat' NB. get the data - perhaps in another session

(0 : 0) fwrite '~temp/g.csv'
part/number,"part/common,name"
123,"wing,nut"
678,bolt
)

csvprepare 'def';'~temp/g.csv'
csvload 'def';1    NB. first row looks like column headers
jd'reads from def' NB. labeled columns
jd'reads from abc' NB. table abc still there

csvprepare 'abc';JDP,'/demo/northwind/csv/Customers.csv'
csvload 'abc';0    NB. default names
jd'reads from abc where jdindex<5' NB. first 5 rows
jd'reads c1,c6 from abc where jdindex<5' NB. 2 cols from first 5 rows

NB. you can rename cols to have your names
newn=: ;:'Address City CompanyName ContactName ContactTitle Country CustomerID Fax Phone PostalCode Region'
oldn=: {."1 jd'read from abc' NB. current names
csvrename 'abc';oldn;<newn
jd'read from abc where jdindex=0'
jd'reads count Address from abc' NB. number of rows
jd'csvreport abc'
NB. csvload DB gets cluttered
#{."1 dirtree'~temp/jd/csvload' NB. files in csvload DB
dir'~temp/jd/csvload'
jd'dropdb' NB. delete csvload DB
dir'~temp/jd/csvload'
