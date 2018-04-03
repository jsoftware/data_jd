require'pacman' NB. httpget

NB. quandl_get 'ibm' 
quandl_get=: 3 : 0
jd'droptable ',y
k=. '?api_key=',fread'~config/quandl_apikey.txt'
'rc fn'=. httpget_jpacman_ 'https://www.quandl.com/api/v3/datasets/EOD/',(toupper y),'.csv',k
'httpget failed'assert 0=rc
(fread fn)fwrite CSVFOLDER,y,'.csv'
y,'.csv'
)

NB. quandl_cdefs 'ibm' - build cdefs metadata file
quandl_cdefs=: 3 : 0
fcsv=. y,'.csv'
jd'csvprobe /replace ',fcsv
jd'csvcdefs /replace /h 1 ',fcsv
jd'csvscan ',fcsv
CDEFSFILE=: CSVFOLDER,'eod.cdefs'
CDEFSFILE frename CSVFOLDER,y,'.cdefs'
'eod.cdefs'
)

NB. quandl_load 'ibm'
quandl_load=: 3 : 0
jd'droptable ',y
jd'csvrd /cdefs F.csv F'rplc'F';y
)

quandl_plot=: 4 : 0
t=. 'title ',(toupper y),' ',x,,' ',.;{:jd'reads last Date,first Date from ',y
t plot |.>{:{.jd'read ',x,' from ',y
)
