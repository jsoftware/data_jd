NB. multiple ops in single reqeust
load JDP,'server/server1.ijs'
s1_build'' NB. build simpkle db and server1

jdadmin'simple'
jd'each';(<'info summary'),(<'info schema'),<'list version' NB. request with multiple ops
jd'each';(<'info summary'),(<'info xxx'),<'list version'    NB. request with an error
jdadmin 0 NB. close simple db so it can be used by server

0 : 0
direct requests have low overhead (high requests per second)
 and will not be mixed with requests from other users

server requests have high overhead (network latency - low rps)
 and can be interleaved with requests from other users

jd'each';... significantly improves server performance
 n ops in each will run nearly n times faster than separate requests
 and with more control over the result
)
 
jdserver'server1';'start'
s1=: url jdclient
s1'logon simple user0 pswd0' NB. access dan simple with user and pswd
s1'each';(<'info summary'),(<'info schema'),<'list version' NB. request with multiple ops
s1'each';(<'info summary'),(<'info xxx'),<'list version'    NB. request with an error
s1'free'
