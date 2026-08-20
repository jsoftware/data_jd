0 : 0
direct requests have low overhead (high requests per second)
 and will not be mixed with requests from other users

server requests have high overhead (network latency - low rps)
 and can be interleaved with requests from other users

jd'each';... significantly improves server performance
 n ops in each will run nearly n times faster than separate requests
 and with more control over the result

each is considered a write op and routes to the base table with replicate
define xrdeach if you need an each that routes to clones
)

jdadminnew'each'
jd'createtable t0'
jd 'createcol t0 a int'
jd'createtable t1'
jd 'createcol t1 b int'

jd'each';(<'info summary'),(<'info schema'),<'list version' NB. request with multiple ops
jd'each';(<'info summary'),(<'info xxx'),<'list version'    NB. request with an error

jd'each';(<'insert t0';'a';?1000),(<'insert t1';'b';?1000)
jd'each';(<'read from t0'),(<'read from t1')
jdadmin 0
