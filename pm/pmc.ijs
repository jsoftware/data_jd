NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. performance measurement for large tables and multiple drives

NB. 'f 1000 10' tm tm_csvcreate
tm_csvcreate=: 0 : 0
*jdadminx'pmcsv'
gen one A0 A1 A2
*jdflush_jd_''
)

NB. '~temp/csv' tm tm_csvdump
tm_csvdump=: 0 : 0
*jdadminx'pmcsv'
*CSVFOLDER=: 'A0'
*deletefolder CSVFOLDER
*jdflush_jd_''
csvdump
*jdflush_jd_''
)

NB. '~temp/csv' tm tm_csvdump
tm_csvrestore=: 0 : 0
*jdadminx'pmcsv'
*CSVFOLDER=: 'A0'
*jdflush_jd_''
csvrestore
*jdflush_jd_''
)
