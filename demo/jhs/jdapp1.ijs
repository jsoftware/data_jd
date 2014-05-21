NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. JHS jdapp1 server - demonstrate Jd browser server

coclass'jdapp1'
coinsert'jhs'

HBS=:  0 : 0
       jhh1'JD database queries'
       desc
'db'   jhtext'sandp';15      
'jd'   jhb'jd'    
'arg'  jhtext'reads from spj';50
'<hr>'
'out'  jhdiv ''
)

create=: 3 : 0
'jdapp1'jhr''
)

ev_jd_click=: 3 : 0
'db arg'=. getvs'db arg'
jhrajax tohtml_jd_ (db;'u/p';'intask') jdx_jd_ arg
)

jev_get=: create NB. browser get request

CSS=: 0 : 0
td{border:1px solid red}
)

JS=: 0 : 0
function ev_jd_click() {jdoajax(["db","arg"],"");}
function ev_db_enter() {jscdo("jd");}
function ev_arg_enter(){jscdo("jd");}

function ajax(ts)
{
 jbyid("out").innerHTML=ts[0];
}
)

desc=: 0 : 0
Run jd commands on a database.<br><br> 
)

OKURL_jhs_=: a:-.~~.'jdapp1';OKURL
