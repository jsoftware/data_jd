NB. server1 access from python3

NB. rebuild server1 from scratch
load'~addons/data/jd/server/server1.ijs'
s1_start''

mkdir_j_ 'jdpycode' NB. folder to hold python files

NB. download python files from server
pycmds=: 0 : 0
curl -k -o jdpycode/curl        https://localhost:3000/curl
curl -k -o jdpycode/pyclient.py https://localhost:3000/pyclient.py
curl -k -o pytest.py            https://localhost:3000/pytest.py
)

shell each <;._2 pycmds

dir 'jdpycode'

0 : 0
curl        - python3 calls for curl access to server
              - $1 ... replaced in copy put in client folder
              
pyclient.py - python3 code to create jd py client folder

~/pytest.py also downloaded for testing python3 jd client
)

[r=. shell'python3 pytest.py jdpycode jdclient py-server1 localhost 3000'
'python client test failed'assert (6=#t)*.6=+/'{'=;{.each t=. <;._2 r

0 : 0
you can experiment with the python code in a terminal window:
python3 -i pytest.py jdpycode jdclient py-server1 localhost 3000 
)
