NB. multiple ops in single reqeust
NB. rdeach is the same as wreach except that rdeach runs in replicate clone servers 
load JDP,'test/util/simple.ijs'
simple_build'' NB. build simple db and server
jdadmin'simple'
jd'wreach';(<'info summary'),(<'info schema'),<'list version' NB. request with multiple ops
jd'wreach';(<'info summary'),(<'info xxx'),<'list version'    NB. request with an error
jdadmin 0 NB. close simple db so it can be used by server

0 : 0
direct requests have low overhead (high requests per second)
 and will not be mixed with requests from other users

server requests have high overhead (network latency - low rps)
 and can be interleaved with requests from other users

jd'wreach';... significantly improves server performance
 n ops in each will run nearly n times faster than separate requests
 and with more control over the result
)
 
simple_play''
simple'wreach';(<'info summary'),(<'info schema'),<'list version' NB. request with multiple ops
simple'wreach';(<'info summary'),(<'info xxx'),<'list version'    NB. request with an error
'free'simple''
