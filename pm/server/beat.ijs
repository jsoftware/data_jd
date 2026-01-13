NB. bmserver client
load'~addons/data/jd/server/client/jds_client.ijs'
CL=: 'localhost:3000' conew 'jdsclient'

beat=: 3 :0
req__CL 'logon ',user
while. y do.
 a=. req__CL 'reads from t where a0<10 || a1<10 || a2<10'
 y=. <:y
end.
req__CL'logoff'
exit''
)


