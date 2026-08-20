
NB. see tutorial csv for common csv work
NB. this tutorial has details not relevant for general use

jdadminx'test'

csv0=: 0 : 0
23,chevrolet,red,1.1,23,1024,1234,2001-03-07 10:58:12
24,toyota,blue,22.22,24,1025,12345,2001-03-07 10:58:13
25,rambler,pink,33.33,25,1026,123456,2001-03-07 10:58:14
)

csv0a=: 0 : 0
23,chevrolet,red,1.1,23,1024,1234,2001-03-07 10:58:12
24,toyota,bluetoolong,22.22,24,1025,12345,2001-03-07 10:58:13
25,rambler,pink,33.33,25,1026,123456,2001-03-07 10:58:14
)

csv1=: 0 : 0
26,ford,green,1.1,23,1024,1234,2001-03-07 10:58:15
27,lexus,black,22.22,24,1025,12345,2001-03-07 10:58:16
28,honda,mauve,33.33,25,1026,123456,2001-03-07 10:58:17
)

jdcreatefolder_jd_ '~temp/jd/csv'
csvfile0=: jpath'~temp/jd/csv/csv0.csv'
csv0 fwrite csvfile0

csvfile0a=: jpath'~temp/jd/csv/csv0a.csv'
csv0a fwrite csvfile0a

csvfile1=: jpath'~temp/jd/csv/csv1.csv'
csv1 fwrite csvfile1

NB. columns 4 5 6 and 7 are ignored
cdef=: 0 : 0
1  vin      int
2  make     varbyte
3  color    byte    5
8  datetime datetime
options , LF NO NO 0
)

build_tab0=: 3 : 0
jdfolder=: jpath'~temp/jd/test/tab0'        NB. JD table to create
csvreportclear_jdcsv_''                     NB. clear log file of old reports
csvdefs_jdcsv_ cdef                         NB. column definitions
csvfolder=: jpath'~temp/jd/test/csv'        NB. temp folder for csv loader
csvload_jdcsv_ csvfolder;csvfile0;0         NB. csvfolder files <- csvfile
jdfromcsv_jdcsv_ jdfolder;csvfolder         NB. JD table <- csvfolder files
)

build_tab0''
jd'reads from tab0'
csvreport_jdcsv_''
csvreportsummary_jdcsv_''

build_tab0a=: 3 : 0
jdfolder=: jpath'~temp/jd/test/tab0a'    NB. JD table to create
csvreportclear_jdcsv_''                  NB. clear log file of old reports
csvdefs_jdcsv_ cdef                      NB. column definitions
csvfolder=: jpath'~temp/jd/test/csv'     NB. temp folder for csv loader
csvload_jdcsv_ csvfolder;csvfile0a;0     NB. csvfolder files <- csvfile
jdfromcsv_jdcsv_ jdfolder;csvfolder      NB. JD table <- csvfolder files
)

build_tab0a''
jd'reads from tab0a'
csvreportsummary_jdcsv_''
csverror
csverrorcount


NB. you can append multiple csv files with the same format
build_tab1=: 3 : 0
jdfolder=: jpath'~temp/jd/test/tab1'      NB. JD table to create
csvreportclear_jdcsv_''                   NB. clear log file of old reports
csvfolder=: jpath'~temp/jd/test/csv0'     NB. temp folder for csv loader
csvdefs_jdcsv_ cdef                       NB. column definitions
csvload_jdcsv_   csvfolder;csvfile0;0     NB. csvfolder files <- csvfile
csvappend_jdcsv_ csvfolder;csvfile1;0
jdfromcsv_jdcsv_ jdfolder;csvfolder       NB. JD table        <- csvfolder files
)

build_tab1''
csvreportsummary_jdcsv_'' NB. note reports for each file
jd'reads from tab1'

NB. you can append the result of a load to an existing conformable table
build_tab2=: 3 : 0
jdfolder=: jpath'~temp/jd/test/tab2'     NB. JD table to create
csvdefs_jdcsv_ cdef                      NB. column definitions
csvfolder=: jpath'~temp/jd/test/csv'     NB. temp folder for csv loader
csvload_jdcsv_ csvfolder;csvfile0;0      NB. csvfolder files <- csvfile
jdfromcsv_jdcsv_ jdfolder;csvfolder      NB. JD table <- csvfolder files

jdfolder=: jpath'~temp/jd/test/tab3'     NB. JD table to create
csvload_jdcsv_ csvfolder;csvfile1;0      NB. csvfolder files <- csvfile
jdfromcsv_jdcsv_ jdfolder;csvfolder      NB. JD table <- csvfolder files
)

