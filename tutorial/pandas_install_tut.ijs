0 : 0
Jd can make use of python/pandas
but first python and modules pandas/pyarrow must be installed
and ~config/python3.cfg must be set as the file name for running it
)

load JDP,'tools/pandas/pandas.ijs'

0 : 0
if python3/pandas/pyarrow are already installed
you have already done this step and can continue

https://www.python.org/downloads/

linux distributions will install with something like the following:
> sudo apt update
> sudo apt install python3
> sudo apt install python3-pip
> pip3 install pandas
> pip3 install pyarrow

windows should install the full python3 package from the web site
 as the windows app store version is slim
> pip3 install pandas
> pip3 install pyarrow

mac should install from the web site or with homebrew
it will also need pandas and pyarrow
)

0 : 0
value in '~config/python3.cfg' is the python3 binary to run
for linux it might be 'python3'
for windows it is likely 'py'
there are many variations - it could be a name in path or a fullname
you need to set that value the first time and if it changes
)

python3_bin_jd_ NB. current value in ~config/python3.cfg

0 : 0
change the value of python3_bin_jd_ if it is not correct
for example:
   python3_set_bin_jd_ 'python3'
)   

'~temp/jd/python.out' python_run_jd_ '--version'

0 : 0
if previous line failed, the name you set did not work
and you need to try again until the python_run_jd_
sentence runs without error
)

'~temp/jd/python.out' python_run_jd_ '--version'

0 : 0
the loader uses python modules pandas and pyarrow
if the next line fails you need to install them
as mentioned earlier in the tutorial
)

'~temp/jd/python.out' python_run_jd_ ' -c "import pandas as pd; print(pd.__version__)"'

NB. see tutorials pandas_load and pandas_write
