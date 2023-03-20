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
