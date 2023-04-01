0 : 0
Jd can make use of python/pandas
but first python and pandas must be installed
)

load JDP,'tools/pandas/pandas.ijs'

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

NB. see tutorials pandas_load and pandas_write

0 : 0
NB. you can work directly in python/pandas if that makes sense
...$ python3
>>> import pandas as pd
>>> df= pd.read_parquet("yellow_tripdata.parquet from pandas_load tutorial")
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