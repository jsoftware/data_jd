0 : 0
use python/pandas to:
 load parquet/feathers/orc/csv/... files into Jd tables
 and write Jd table to those formats

years ago csv was the standard database interchange format and
the Jd native csv facility is fast and robust
 
parquet and other file formats are increasingly common
these new formats tend to be col oriented and fit well with Jd
they are space efficient and much faster to load and write
 
parquet and the other formats are complex and Jd has chosen to
leverage work done in python/pandas rather than reinvent these wheels
 
this tutorial shows how to load a parquet file into a Jd table and
tutorial pandas_write shows how to write a Jd table to a parquet file

the same process applies to any format supported by python/pandas
)

0 : 0
Jd tables and pandas dataframes are pleasantly compatible

currently the following datetypes are handled
 Jd int   <> pandas int64
 Jd float <> pandas float64
 Jd byte  <> pandas array of strings
 these could be extended with more work
 
Jd bytes vs pandas strings
 works well, but there may be rough areas
 
Jd datetime epoch is 2000 - pandas is 1970
 this requires adjustment by efs_jd_'1970
 but do not adjust NaT/IMIN values!
 
missing (or bad) values are treated differently
 Jd missing:
  byte     - blanks
  int      - IMIN
  float    - __
  datetime - __
  any missing numeric has the min value for the type
 
 pandas missing:
  string   - None - marked as missing
  int64    - _. (column is converted to float64)
  float64  - _. Na
  datetime - _. NaT 
  
 loading from pandas
  string None -> ({.a.),blank padding
  float64 (ignoring NA) that is int is converted and (Na replaced by IMIN)
  float64 Na  -> __
  
 writing to pandas
  does not adjust - but could be an option in the future
)

NB. see tutorial pandas_install first to be sure python/pandas is installed

load JDP,'tools/pandas/pandas.ijs'

NB. next advance does download (if required) and can take minutes
getjdfile_jd_'yellow_tripdata.parquet'

[file=: jpath'~temp/jdfiles/yellow_tripdata.parquet'
NB. file is parquet format of NYC yellow cab tripdata for 2022-01-01

NB. pandas_load_jd arg
NB. database ; table ; count ; op ; file ; parms
NB. database - jdadmin arg
NB. table    - Jd table to create from file
NB. count    - rows to load - 'all' for all or n for first n or _n last n
NB. op       - pandas op
NB. file     - file to load
NB. parms    - additional parameters to pandas op

[pandas_load_ops_jd_ 

NB. next line loads first 2 rows of the parquet file data into Jd
pandas_load_jd_  'pandas_db';'pandas_table';2;'read_parquet';file;''
jd'reads from pandas_table'

NB. see the log - might help if the load failed
pandas_read_log_jd_'pandas_table'

NB. next line loads last 2 rows of the parquet file data into Jd
pandas_load_jd_  'pandas_db';'pandas_table';_2;'read_parquet';file;''
jd'reads from pandas_table'

NB. next line loads first 5 rows of the specified columns
pandas_load_jd_  'pandas_db';'pandas_table';5;'read_parquet';file;',columns=["VendorID","trip_distance"]'
jd'reads from pandas_table'

NB. next line loads all rows of the parquet file data into Jd
pandas_load_jd_  'pandas_db';'pandas_table';'all';'read_parquet';file;''
jd'info summary pandas_table'

NB. see the log - and note the data adjustments
pandas_read_log_jd_'pandas_table'

jd'info schema pandas_table'
jd'read from pandas_table where jdindex<3'

jd'read max fare:max fare_amount , avg fare:avg fare_amount from pandas_table'
NB. it seems unlikely that the max is valid - and it will have affected the avg

NB. the table needs to be cleaned before it is ready for general use
NB. see tutorial pandas_clean
