require'api/curl'
require'~addons/ide/jhs/extra/man.ijs'
require'convert/pjson'
require'~addons/arc/lz4/lz4.ijs'

coclass'jdcurl'
coinsert 'jcurl'

JDOK=: ,:'Jd OK';2-2

var=: 3 : 'setopt_variadic, <y'

chk=: 3 : 0
if. 0=>{.y do. return. end.
(memr 0 _1,~ curl_easy_strerror {.y) assert 0
)

version=: 3 : 0
memr (curl_version''),0,_1,JCHAR
)

cdcallback=: 3 : 0
y=. 15!:17''
if. 4=#y do. writedata y end.
)

writedata=: 3 : 0
'data size nmemb userp'=. y
rsize=. size*nmemb
('result')=: 'result'~, memr data,0,rsize,2
rsize
)

f=: [: 15!:13 (IFWIN#'+') , ' x' $~ +:@>:

NB. 'https://localhst:3000' conew 'jdcurl'
create=: 3 : 0
jdclass=: 'client'
url=: y
curl_global_init_jcurl_ CURL_GLOBAL_ALL_jcurl_
curl=: >{. (libcurl,' curl_easy_init * i') cd 3
chk curl_easy_setopt_str curl;CURLOPT_URL;var y
chk curl_easy_setopt_str curl;CURLOPT_COOKIEFILE;var ''
chk curl_easy_setopt curl;CURLOPT_HTTPHEADER;var curl_slist_append 0;'Content-Type: application/octet-stream'
chk curl_easy_setopt curl;CURLOPT_SSL_VERIFYPEER;var 0
chk curl_easy_setopt curl;CURLOPT_SSL_VERIFYHOST;var 0
chk curl_easy_setopt curl; CURLOPT_WRITEFUNCTION;var f 4
chk curl_easy_setopt curl; CURLOPT_WRITEDATA;var 0
chk curl_easy_setopt curl; CURLOPT_TCP_KEEPALIVE; var 1
)

NB. logoff, curl cleanup, destory locale
destroy=: 3 : 0
'logoff' req :: [ ''
if. 0=nc<'curl' do. curl_easy_cleanup <curl end.
codestroy''
i.0 0
)

NB. lz4_compressframe_jlz4_=: [
NB. lz4_uncompressframe_jlz4_=: [

NB. [node] * jd
NB. jd is same arg as to non-server request
NB. * 'info summary'
NB. node cmds separated by ;
NB. logon dan user pswd
NB. logoff  - removes user from user table at end
NB. free    - logoff and clear curl and destroy locale at end
NB. eok     - Jd error result does not signal
NB. op jdop - added automatically to route request to port
NB. 'logon simple user0 pswd0;eok'simple'info xxx'
req=: 3 : 0
'' req y
:
n=. deb each <;._2 x,';'
signal=. -.n e.~<'eok'
free=. n e.~<'free'
n=. ;n,each';'
op=. dltb;{.boxopen y
n=. n,'op ',(op i.' '){.op
j=. lz4_compressframe_jlz4_ 3!:1 y
d=. j,LF,n

chk curl_easy_setopt curl;CURLOPT_POSTFIELDSIZE;var #d
chk curl_easy_setopt curl;CURLOPT_POSTFIELDS;var symdad<'d'

result=: ''
r=. curl_easy_perform curl
if.  0~:>{.r do. result=: '{"Jd error":"libcurl: ',(memr 0 _1,~ curl_easy_strerror {.r),'"}' end.

if. '{'={.result do.
 r=. dec_pjson_ result
else.
 r=. (3 !: 2) @ lz4_uncompressframe_jlz4_ result
end. 

if. free do. NB. logoff has been done
 curl_easy_cleanup <curl
 codestroy''
end.

if. signal*.'Jd error'-:;{.{.r do.
 t=. _2}.;r,each <': '
 13!:8&3 t
end.
r
)

NB.   s1=: 'https://localhost:3000' jdclient NB. s1 verb to access server
NB.   [n] s1 a
NB. a is same arg as for a non-server request
NB.    s1'info summary'
NB. n is list of ; delmited node commands
NB.    'eok;free's1'info bad'
NB. node cmds:
NB.  logon dan user pswd
NB.  logoff  - removes user from user table at end
NB.  free    - logoff and clear curl and destroy locale at end
NB.  eok     - Jd error result does not signal
NB.  op jdop - added automatically to route request to port
jdclient_z_=: 1 : 0
NB. validate m format
m=. ;(''-:m){m;'https://localhost:3000'
('req_','_',~;m conew'jdcurl')~
)
