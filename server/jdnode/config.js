// node jdserver config

exports.port= 3000; // port to server

exports.keypath= "/home/eric/git/addons/data/jd/server/jdnode/" // path to cert.pem and key.pem

// services provided: name,host,port,dan
exports.svc= 
'[\
 ["s1"       ,"s2"       ,"s3"       ,"s4"],\
 ["localhost","localhost","localhost","localhost"],\
 [65220      ,65220      ,65221      ,65221],\
 ["a"        ,"b"        ,"c"        ,"d"]\
]'

// valid user/pswd list
exports.up= ["u/p","test/dummy"];
