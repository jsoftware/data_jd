NB. server1 access from python3

NB. rebuild server1 from scratch
load'~addons/data/jd/server/server1.ijs'
s1_start''

NB. create folder jdpycode with python files to create and run jd py clients
pycmds=: 0 : 0
mkdir -p jdpycode
curl -k -o jdpycode/curl.sh     https://localhost:3000/curl.sh
curl -k -o jdpycode/pyclient.py https://localhost:3000/pyclient.py
curl -k -o ~/pytest.py          https://localhost:3000/pytest.py
)

shell each <;._2 pycmds

dir 'jdpycode'

0 : 0
curl.sh       - python3 calls for curl access to server
              - $1 ... replaced in copy put in client folder
              
pyclient.py - python3 code to create jd py client folder

~/pytest.py also downloaded for testing python3 jd client
)


0 : 0
in terminal window:
python3 -i pytest.py jdpycode jdclient py-server1 localhost 3000 
)
