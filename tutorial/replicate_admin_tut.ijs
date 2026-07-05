load JDP,'test/util/rep.ijs' NB. rep server tools

create_rep_server'' NB. create rep server with rep base and 2 clones
rep'info summary'

'logon rep admin funny'rep''

NB. admin requests can be routed to port
'port 65220'rep'admin PORT'
'port 65221'rep'admin PORT'
'port 65222'rep'admin PORT'



