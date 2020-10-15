0 : 0
load Chicago business_licenses.csv - >250 MB, 35 cols, and >860e6 rows

original source: https://catalog.data.gov/dataset?res_format=CSV&tags=licenses&organization=city-of-chicago

put at www.jsoftware.com/download/jdcsv/business_licenses.zip

download (only done first time) can take a few minutes

load csv to Jd table can take 20 seconds on a slow machine
 and 1 second on a fast machine with ssd
)

CSVFOLDER=: '~temp/jd/csv/buslic/' NB. folder for csv files
jdcreatefolder_jd_ CSVFOLDER       NB. ensure folder exists
jdadminx'buslic'                   NB. new db ~temp/jd/test/
fcsv=: 'business_licenses.csv'

NB. next advance does download (if required) and takes minutes
NB. zip downloaded from www.jsoftware.com/jdcsv and unzipped in CSVFOLDER
getcsv_jd_ fcsv
fsize CSVFOLDER,fcsv

NB. csvprobe will set initial .cdefs metadata and read first 20 rows
jd'csvprobe /replace ',fcsv
NB. looking at data it is clear first row is column names
NB. subsequent rows look like data (rather than more headers)

NB. csvcdefs will set .cdefs metadata - /h 1 iindicates first row has col names
jd'csvcdefs /replace /h 1 ',fcsv

NB. csvcdefs sets metadata but based on only first 5000 rows
NB. csvscan wll scan entire file to get max col widths from all rows
jd'csvscan ',fcsv

fread CSVFOLDER,'business_licenses.cdefs' NB. final metadata

NB. csvrd will load csv file into Jd table buslic
jd'csvrd ',fcsv,' buslic'
jd'csvreport'

jd'reads count ID from buslic' NB. more than 860 thousand rows
jd'reads count:count ID by APPLICATION_TYPE from buslic'
jd'reads first LICENSE_DESCRIPTION,count:count ID by LICENSE_CODE from buslic order by count desc'
10{.>1{ {:jd'reads first LICENSE_DESCRIPTION,count:count ID by LICENSE_CODE from buslic order by count desc'
jd'reads ID,APPLICATION_TYPE,LEGAL_NAME from buslic where LEGAL_NAME = "CHICAGO GAME CO"'
d=: 'APPLICATION_TYPE'jdfrom_jd_ jd'read APPLICATION_TYPE from buslic'
$d
10{.d

