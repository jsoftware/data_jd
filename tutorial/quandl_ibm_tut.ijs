
0 : 0
www.quandl.com is a financial data source
with a free signup you can easily download interesting sample csv files
with a paid subscription, you have whatever you want at your fingertips

for this tutorial the EOD-IBM.csv file was downloaded and put at:
 www.jsoftware.com/download/jdcsv/eod-ibm.zip

download (only done first time) can take a minutes
)

require'plot'

CSVFOLDER=: '~temp/jd/csv/ibm/' NB. folder for csv files
jdcreatefolder_jd_ CSVFOLDER    NB. ensure folder exists
jdadminx'ibm'                   NB. new db ~temp/jd/ibm
fcsv=: 'EOD-IBM.csv'

NB. next advance does download (if required) and takes minutes
NB. zip downloaded from www.jsoftware.com/jdcsv and unzipped in CSVFOLDER
getcsv_jd_ fcsv
fsize CSVFOLDER,fcsv

NB. csvprobe sets set initial .cdefs metadata and reads first 20 rows
jd'csvprobe /replace ',fcsv
NB. looking at data it is clear first row is column names
NB. subsequent rows look like data (rather than more headers)

NB. csvcdefs will set .cdefs metadata - /h 1 iindicates first row has col names
jd'csvcdefs /replace /h 1 ',fcsv

NB. csvcdefs sets metadata but based on only first 5000 rows
NB. csvscan wll scan entire file to get max col widths from all rows
jd'csvscan ',fcsv

fread CSVFOLDER,'EOD-IBM.cdefs' NB. final metadata

NB. csvrd will load csv file into Jd table buslic
jd'csvrd ',fcsv,' ibm'
jd'csvreport'

jd'reads count Date from ibm'
[minmax=.,;{:jd'reads min Open,max Open from ibm'
[t=. (":minmax)rplc' ';','
jd'reads Date,Open from ibm where Open in (',t,')'

stockplot=: 3 : 0
if. IFTESTS_jd_ do. return. end. NB. avoid plot in jdtests_jd_''
title=. 'title IBM Open prices',,' ',.;{:jd'reads min Date,max Date from ibm'
title plot |.>{:{.jd'read Open from ibm'
)

stockplot''