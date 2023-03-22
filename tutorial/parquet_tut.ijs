0 : 0
with help from python/pandas you can load tables from file formats
parquet/feathers/orc/hdf5/... into Jd 
 
years ago csv was the standard database interchange format and
the Jd native csv loader is fast and robust
 
parquet and other file formats are increasingly common
these new formats tend to be col oriented and fit well with Jd
they are space efficient and much faster to load
 
parquet and the other formats are complex and Jd has chosen to
leverage work done in python/pandas rather than reinvent these wheels
 
this tutorial shows how to load a parquet file into a Jd table

the same process applies to any format supported by python/pandas
)

load JDP,'tools/pandas/load.ijs'

0 : 0
if the next line fails, you need to install python3
if it is installed, then you need to adjust python_bin_jd_
to be the path to the python binary or create a symlink

https://www.python.org/downloads/

some linux distributions will install with something like the following:
> sudo apt update
> sudo apt install python3
)
'~temp/jd/python.out' python_run_jd_ '--version'

0 : 0
the loader uses python pandas and pyarrow packages
if the next line fails you need to install pandas

some linux distributions will install with something like the following:
> sudo apt install python3-pip
> pip3 install pandas
> pip3 install pyarrow
) 
'~temp/jd/python.out' python_run_jd_ ' -c "import pandas as pd; print(pd.__version__)"'


NB. next advance does download (if required) and can takes minutes
getjdfile_jd_'yellow_tripdata.parquet'

NB. ~temp/jdfiles/yellow_tripdata.parquet
NB. is a database of NYC yellow cab tripdata for 2022-01-01

[src=. pandas_src_jd_'parquet';'~temp/jdfiles/yellow_tripdata.parquet'
NB. src is the python pandas dataframe verb to load the data

NB. next line loads the parquet file data into Jd table pandas_table in pandas_db
pandas_load_jd_  'pandas_db';src

NB. see the log - might help if the load failed
pandas_read_log_jd_''

NB. if the load finished, then you can play with the table
jd'info schema'
jd'read from pandas_table where jdindex<3'

0 : 0
a major problem with a table is that the data is typically not clean
it can have missing values or bad values (data entry finger slip)
)

jd'read max fare:max fare_amount , avg fare:avg fare_amount from pandas_table'
NB. it seems unlikely that the max is valid - and it will have affected the avg

jd'read max riders:max passenger_count , min riders: min passenger_count from pandas_table'
NB. max 9 makes sense, but min is the value (IMIN_jd) that Jd uses for missing int data

0 : 0
cleaning the table is necessary for it to be useful and is a hard problem
script JDP,tools/pandas/clean.ijs has a basic tool that is adequate
for this table and could be a starting point for other tables
the requirements can vary widely between tables
)

load JDP,'tools/pandas/clean.ijs'

clean'pandas_table';200;300;''

0 : 0
the report has a line for each table column
Na column reports the count of missing data
 passengerP_count has 71503 missing values
mid col has the median value (value from the middle of the sorted data) 
out- col has how many values were <<.avg%200
 fare_amount has 12733 values that are less than that threshold
 note that this is the same value as neg values in that column
out+ col has count of values ><.300*avg 
 trip_distance has max 306159 and out+ 68 that - likely data entry problems
 
study the table to get a feel for how data can be bad
)

NB. the next step updates1  the table by replacing Na,out-,out+ data with the mid value
clean'pandas_table';200;300;'change'
jd'read max fare:max fare_amount , avg fare:avg fare_amount from pandas_table'
jd'read max riders:max passenger_count , min riders: min passenger_count from pandas_table'

NB. you can work directly in python/pandas if that makes sense
0 : 0
...$ python3
>>> import pandas as pd
>>> df= pd.read_parquet("j9.4-user/temp/jdfiles/yellow_tripdata.parquet")
>>> df.passenger_count
0          2.0
1          1.0
2          1.0
3          1.0
4          1.0
          ... 
2463926    NaN
2463927    NaN
2463928    NaN
2463929    NaN
2463930    NaN
Name: passenger_count, Length: 2463931, dtype: float64
>>> 
)