// node jdserver config

exports.port= 3000; // port to serve

// services provided: name,host,port,dan
exports.svc= 
'[\
 ["s1"       ,"s2"       ,"s3"       ,"s4"],\
 ["localhost","localhost","localhost","localhost"],\
 [65220      ,65220      ,65221      ,65221],\
 ["jds_db_a"        ,"jds_db_b"        ,"jds_db_c"        ,"jds_db_d"]\
]'

// valid user/pswd list
exports.up= ["u/p","test/dummy"];
