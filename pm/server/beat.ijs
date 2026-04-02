NB. bmserver client
NB. return 'read from t' ops per seconds
beat=: 3 :0
load'jd'
jds1=. url jdcdefine
jds1'logon simple user0 user0'
a=. 6!:9''
i=. 0
while. i<y do.
 jds1'list version'
 6!:3[0.1
 i=. i+1
end. 
z=. 6!:9''
r=. y%(z-a)%6!:8''
(LF,~":r)fappend'beatit.txt'
jds1'free'
exit''
)

