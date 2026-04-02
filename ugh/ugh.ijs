NB. multiple loads from script crashes - run each line is OK

NB. !!! run load'ugh.ijs' in jconsole 3 times crashes !!!

load'git/addons/data/jd/jd.ijs'
load'ugh/jclient.ijs'
s1=: 'adf'jdcdefine
s1 :: [ 'adsf'
coerase conl 1
s1'ads' NB.crash

NB. old comments
NB. git jclient crashes in jconsole but not in jhs
NB. ugh jclient crashes in jhs but not in jconsole
NB. how can there be a difference between 
NB. memory damage?!
NB. load'git/addons/data/jd/server/client/jclient.ijs'

