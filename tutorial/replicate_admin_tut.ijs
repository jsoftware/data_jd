load JDP,'test/util/rep.ijs' NB. rep server tools

r1_run'' NB. create rep server with rep base and 2 clones
r1'info summary'

'logon rep admin funny'r1''

NB. admin requests can be routed to port
'port 65220'r1'admin PORT'
'port 65221'r1'admin PORT'
'port 65222'r1'admin PORT'



