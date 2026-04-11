0 : 0
Jd python3 client requires python3
jd pandas (jdrt'pandas") also requires python3
)
pystatus_jd_'' NB. check python3 install - pandas and pyarrow not required for Jd client
NB. lz4 install required - next must indicate lz4 is available
pysub_jd_ '-m pip install lz4'
NB. pycurl required for use of libcurl - next must indicae pycurl is available
pysub_jd_ '-m pip install pycurl'

NB. rebuild server1 from scratch
load JDP,'server/server1.ijs'
s1_build''
jdserver'server1';'start'

mkdir_j_ 'jdpycode' NB. folder to hold python3 files

NB. download python3 files from server
pycmds=: 0 : 0
curl --no-progress-meter -k -o jdpycode/curl        https://localhost:3000/curl
curl --no-progress-meter -k -o jdpycode/pyclient.py https://localhost:3000/pyclient.py
curl --no-progress-meter -k -o pytest.py            https://localhost:3000/pytest.py
)

shell each <;._2 pycmds

dir 'jdpycode'

0 : 0
curl        - python3 calls curl to access to server
pyclient.py - python3 code to create jd py client folder
~/pytest.py also downloaded for testing python3 jd client
)

NB. python3 works with json
[r=. pysub_jd_'pytest.py jdpycode jdclient py-server1 localhost 3000'
'python3 client test failed'assert (8=#t)*.8=+/'{'=;{.each t=. <;._2 r

0 : 0
you can experiment with the python3 code in a terminal window
start terminal:
copy and paste the following python3_bin... and jd.req... lines into termnal
)

python3_bin_jd_,' -i pytest.py jdpycode jdclient py-server1 localhost 3000'
'jd.req(jdp1,''logon simple user0 user0'')'
