0 : 0
custom.ijs contains db custom ops (ops specific to the db)
custom ops are of the form jd_x...
custom ops can call any jd_... op 
custom ops are often patterned after similar jd_... ops

custom ops are important with a server
 run as a transaction wihout ops from other users interleaved
 run as a single network request (nearly as many times faster as the reduction in requests)
)

custom=: 0 : 0 NB. define xadd and xtransfer
jd_xadd=: {{
a=. _".y
'arg must be 2 numbers'assert (2=#a)*.-._ e. a
'da db'=: a
a=. jd'get f account'
'account already exists'assert -.da e. a
jd'insert f';'account';da;'balance';db
JDOK
}}

jd_xtransfer=: {{
a=. _".y
'arg must be 3 numbers'assert (3=#a)*.-._ e. a
'da db dc'=: a
a=. jd'get f account'
b=. jd'get f balance'
'dai dbi'=. a i. da,db
((":da),': is not valid account to debit')  assert dai<#a
((":db),': is not valid account to credit') assert dbi<#a
'insufficient funds'assert dc<:dai{b
jd'set f balance';( (dc-~dai{b) , dc+dbi{b ) (dai,dbi)} b
JDOK
}}
)

'new'jdadmin'test' NB. new db with no custom.ijs
custom fwrite '~temp/jd/test/custom.ijs'  NB. create custom.ijs
jdloadcustom_jd_'' NB. load changes
jd'createtable';'f';'account int,balance int'
jd'xadd 1001 300'
jd'xadd 1002 500'
jd'reads from f'
0 jd'xadd 1001 100'
jd'xtransfer 1001 1002 50'
jd'reads from f'
0 jd'xtransfer 1001 1002 500'
