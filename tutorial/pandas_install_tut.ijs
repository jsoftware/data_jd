load JDP,'tools/pandas/pandas.ijs'

0 : 0
if next step runs without error, your install is OK and
you can skip this tutorial and run the pandas_load tutorial

if it runs with an error, continue the lab for more info
)

pystatus_jd_''  NB. you have work to do if there is an error

0 : 0
you need the python3 binary and modules pandas and pyarrow

value in '~config/python3.cfg' is the python3 binary to run
default value of python3 is set for unix
default value of py is set for windows
if the default value is not right, you will have set it manually

linux distributions can usually install with apt (or yum)
with something like the following:
> sudo apt update
> sudo apt install python3
> sudo apt install python3-pip

mac should install from the web site or with homebrew

windows app store version is slim and you need a full install
windows should install the full python3 package from:
https://www.python.org/downloads/

once you have python3 binary you can install other modules with pip
 $ python3 -m pip install pandas
 $ python3 -m pip install pyarrow
)
