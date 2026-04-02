require'api/curl'
require'~addons/ide/jhs/extra/man.ijs'
require'convert/pjson'
require'~addons/arc/lz4/lz4.ijs'

coclass'jdcurl'
coinsert 'jcurl'

man_jd_jclient=: 0 : 0
access jd server running on localhost port 3000:
start J task 
   load 'gitjd' NB. load development Jd
NB. rather than load all of Jd, it is possible to load just the client   
   load JDP,'server/client/jclient.ijs' NB. just client

   s1=: 'https://localhost:3000'jdcdefine
   s1'logon simple u u'
   s1'info schema'
   s1'free' NB. logoff and destroy locale

   jdrt'j_client'
)

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
(libcurl,' curl_global_init *') cd ''
curl=: >{. (libcurl,' curl_easy_init * i') cd 3
chk curl_easy_setopt_str curl;CURLOPT_URL;var y
chk curl_easy_setopt_str curl;CURLOPT_COOKIEFILE;var ''
chk curl_easy_setopt curl;CURLOPT_HTTPHEADER;curl_slist_append 0;'Content-Type: application/octet-stream'
chk curl_easy_setopt curl;CURLOPT_SSL_VERIFYPEER;var 0
chk curl_easy_setopt curl;CURLOPT_SSL_VERIFYHOST;var 0
chk curl_easy_setopt curl; CURLOPT_WRITEFUNCTION;var f 4
chk curl_easy_setopt curl; CURLOPT_WRITEDATA;var 0
)

NB. logoff, curl cleanup, destory locale
destroy=: 3 : 0
req :: [ 'logoff'
if. 0=nc<'curl' do. curl_easy_cleanup <curl end.
codestroy''
i.0 0
)

NB. [signal] * 'info summary'
NB. * 'info summary'
NB. 0 * 'info xxx' NB. returns Jd error
NB. signal 1 (default) signals an error
NB. POSTFIELDS fails for short arguments '    list version' is ok 'list version' fails
NB. COPYFIELDS works
req=: 3 : 0
1 req y
:
if. 'free'-:dltb y do. destroy'' return. end.
d=. lz4_compressframe_jlz4_ 3!:1 y
chk curl_easy_setopt curl;CURLOPT_POSTFIELDSIZE_LARGE;var #d
chk curl_easy_setopt_str curl;CURLOPT_COPYPOSTFIELDS;var d
result=: ''
chk curl_easy_perform curl
if. '{'={.result do.
 r=. dec_pjson_ result
else.
 r=. (3 !: 2) @ lz4_uncompressframe_jlz4_ result
end. 
if. x*.'Jd error'-:;{.{.r do.
 t=. _2}.;r,each <': '
 13!:8&3 t
end.
r
)

NB. 'https://localhost:3000' *
NB. return verb for requests to that server
jdcdefine_z_=: 1 : 0
NB. validate m format
('req_','_',~;m conew'jdcurl')~
)
