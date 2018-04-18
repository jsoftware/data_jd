require 'plot'
require JDP,'tools/quandl.ijs'

0 : 0
www.quandl.com is a source for free, historical, stock data

you need a free quandl account and apikey to download data

www.quandl.com
 top right: SIGN IN
  bottom right: CREATE ONE
   fill in form: SIGN UP FOR FREE

welcome gives your apikey (also in your account settings)

run following sentence (with your apikey) to put your key in config

   '????' fwrite '~config/quandl_apikey.txt'
)

'you need to set your apikey'assert 10<#fread'~config/quandl_apikey.txt' 

jdadminx'quandl' NB. create empty quandl db
CSVFOLDER=: '~temp/jd/quandl/csv/' NB. folder for quandl csv files
jdcreatefolder_jd_ CSVFOLDER

NB. next step downloads the Proctor & Gamble csv file - can take a minute
quandl_get'pg'
fsize CSVFOLDER,'pg.csv'

quandl_cdefs'pg' NB. analyze csv file to build cdefs metadata file
fread CSVFOLDER,'eod.cdefs'

quandl_load'pg' NB. load pg.csv into table pg
jd'info table'
jd'info schema'
jd'reads #:count Date from pg' NB. number of rows in table
jd'reads latest:first Date,oldest:last Date from pg'
'Open' quandl_plot'pg'
'Split'quandl_plot'pg'
NB. note how the splits line up with open drops

NB. next step downloads the IBM csv file - can take a minute
quandl_get'ibm'
quandl_load'ibm' NB. uses eod.cdefs file built earlier
jd'info table'
'Volume'quandl_plot'ibm'
