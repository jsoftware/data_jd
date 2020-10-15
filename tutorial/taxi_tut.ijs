0 : 0
create table with data from downloaded csv file with taxi trip data

page about the data is here:
https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page

download csv file:
'https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2018-01.csv'

download (only done first time tutorial is run) can take a few minutes
)

require'web/gethttp'
require JDP,'tools/csv_load.ijs'

PATH=: '~temp/jd/csv/yellow_tripdata/'
NAME=: 'yellow_tripdata_2018-01.csv'

taxi_get=: 3 : 0
if. fexist PATH,NAME do. (PATH,NAME,' already downloaded') return. end. 
fn=: jpath '~temp/',NAME
('file';fn) gethttp 'https://s3.amazonaws.com/nyc-tlc/trip+data/',NAME
jdcreatefolder_jd_ PATH
(fread fn) fwrite PATH,NAME
dir PATH
)

NB. next step can take a few minutes if file is not already downloaded
taxi_get'' NB. download csv file if not already downloaded

NB. use csv_load utils to load csv
csvprepare 'yellow_tripdata';PATH,NAME

NB. next step can take a few minutes
csvload 'yellow_tripdata';1

jd'info summary'
jd'info schema yellow_tripdata'

jd'reads avg fare_amount by passenger_count from yellow_tripdata'
