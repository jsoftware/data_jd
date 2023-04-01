0 : 0
a major problem with using a table is if the data is not clean
missing values or bad values (data entry finger slip)
garbage in, garbage out
)

NB. study tutorial pandas_load first

load JDP,'tools/pandas/pandas.ijs'
getjdfile_jd_'yellow_tripdata.parquet'
[file=: jpath'~temp/jdfiles/yellow_tripdata.parquet'
pandas_load_jd_  'pandas_db';'pandas_table';'all';'read_parquet';file;''

jd'info summary pandas_table'
jd'reads from pandas_table where jdindex<3'

jd'read max fare:max fare_amount , avg fare:avg fare_amount from pandas_table'
NB. it seems unlikely that the max is valid - and it will have affected the avg

jd'read max riders:max passenger_count , min riders: min passenger_count from pandas_table'
NB. max 9 makes sense, but min is the value (IMIN_jd) that Jd uses for missing int data

0 : 0
cleaning the table is necessary for it to be useful and is a hard problem
script JDP,tools/pandas/clean.ijs has a basic tool that is adequate
for this table and could be a starting point for other tables
requirements can vary widely between tables
)

load JDP,'tools/pandas/clean.ijs'

0 : 0
report from next sentence has a line for each table column
Na column reports the count of missing data
 passenger_count has 71503 missing values
mid col has the median value (value from the middle of the sorted data) 
out- col has how many values were <<.avg%200
 fare_amount has 12733 values that are less than that threshold
 note that this is the same value as neg values in that column
out+ col has count of values ><.300*avg 
 trip_distance has max 306159 and out+ 68 - likely data entry problems
)

clean'pandas_table';200;300;''

NB. the next step updates the table by replacing Na,out-,out+ data with the mid value
NB. note that store_and_fwd_flag byte data Na values are not adjusted
clean'pandas_table';200;300;'change'
jd'read max fare:max fare_amount , avg fare:avg fare_amount from pandas_table'
jd'read max riders:max passenger_count , min riders: min passenger_count from pandas_table'
