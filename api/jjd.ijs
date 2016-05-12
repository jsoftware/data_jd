NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. JHS jjd server for wget clients

0 : 0
JD server is JHS app jjd

JD server serves URL jjd on a 'known' port
for security the server normally only binds to localhost
client must have ssh tunnel to get to servers localhost

JHS gets an http reqest for jjd and calls jev_post_raw
jev_post_raw processes the request in the post data and sends a response

post data has following format (bytes):
 header * jdargs
 header is fin;fout;dbname;user;pswd;
 jdargs is jd arguments in fin format

 fin/fout is one of: TEXT/JBIN/JSON/HTML (type support incomplete)

***

Clients

1. J client - api/client.ijs
2. non J client - wget or equivalent - same as J client but without J
3. browser (ajax) -> apache -> cgi J task -> jwget from JD server  
)

coclass'jjd'
coinsert'jhs'

jev_post_raw=: 3 : 0
try.
 i=. NV i. '*'
 'fin fout dbx user pswd'=. <;._2 i{.NV
 DB_jd_=: dbx
 UP_jd_=: user NB. user field is user/pswd and pswd field is not used
 SERVER_jd_=: 'intask'
 d=. (>:i)}.NV
 select. fin
 case.'JBIN' do. d=. 3!:2 d
 case.'TEXT' do. d=. d NB. nothing to do 
 case. do. assert. 0['unknown input format'
 end.
 if. 1=#d do. d=.;d end.
 d=. (dbx;user;'intask') jdx_jd_ d
 select. fout
 case.'JBIN' do. 'application/octet-stream' gsrcf 3!:1 d
 case.'TEXT' do. 'text/plain' gsrcf totext_jd_ d
 case. do. 'unknown output format' assert 0
 end.
catch.
 'text/plain' gsrcf 13!:12''
end.
i.0 0
)

OKURL_jhs_=: a:-.~~.'jjd';OKURL
