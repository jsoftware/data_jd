NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage Jd user table

NB. serious production use that might be attacked
NB. should consider replacing this with reviewed code

coclass'jdup'
coinsert'jd'

man_jd_server_user_pswd=: 0 : 0
user/pswd file for Jd server

Jd server requires logon with dan user pswd.

The user and pswd is validated against the server upfile.

The upfile is in jdscpath up folder. A server-folder upfilepath specfies the server upfile.

The upfile pswds are encrypted.

Valid logon updates the ductable_jdup_ with dan;user;cookie.

Subsequent requests with a cookie get the and and user from the ductable.

See server1.ijs for an exmple of building an upfile.
)

destroy=: codestroy

require'guid'
hash=: 1&(128!:6) 

NB. ductable dan,user,cookie
logon=: 3 : 0
'dan user pswd'=: bdnames y
if. check user;pswd do.
 cookie=. ,'0123456789abcdef' {~ 16 16 #: a. i. ,guids 1
 ductable=: ductable,dan;user;cookie
 jdslog 'on';dan;user;cookie
 ({.a.),cookie
else.
 jdslog 'onx';'';'' NB. do not log info
 {.a. NB. failed
end.
)

NB. returns 1 to set cookie empty
logoff=: 3 : 0
cookie=. y
ductable=: ((2{"1 ductable)~:<cookie)#ductable NB. remove entries with same cookie
jdslog 'off';'';'';cookie
1{a.
)

setuser=: 3 : 0
y=. boxopen y
'wrong number of args'assert 1 2 3 e.~#y
'name user pswd'=. dltb each 3{.y,'';''
'name must be upfile or test_upfile'assert (<name)e.'upfile';'test_upfile'
'mkdir failed'assert 1=mkdir_j_ jdscpath_jd_,'up'
UPFILE=: jdscpath_jd_,'up/',name
if. -.fexist UPFILE do. '' fwrite UPFILE end.
if. 0=#user do.
 d=. <;.2 fread UPFILE
 (d i.each ':'){.each d
 return.
end.
'user can not contain blank'assert -.' 'e.user
'invalid user' assert 8>:#user
if. name-:'UPFILE' do.
 'upfile pswd must have 8 chars'assert 8<:#pswd
else.
 'test_upfile pswd can not have more than 6 chars'assert 6>:#pswd
end.
if. (<user)e.getusers'' do. deluser user end. NB. remove an old entry
if. 0~:#pswd do.
 salt=. ,'0123456789abcdef' {~ 16 16 #: a. i. ,guids 1
 ((fread UPFILE),LF,~user,':',salt,':',hash pswd,salt)fwrite UPFILE
end. 
i.0 0
)

NB. cookie - get user with cookie from ductable
get_dan_user=: 3 : 0
i=. ({:"1 ductable)i.<y
if. i=#ductable do. '';'' else. 2{.i{ductable end.
)

NB. create empty u/p UPfile
init=: 3 : 0
'u/p table already exists'assert -.fexist UPFILE
'' fwrite UPFILE
)

getusers=: 3 : 0
{."1 show UPFILE
)

NB. user
deluser=: 3 : 0
a=.getusers''
i=. a i.<y
'not a user'assert i~:#a
d=. <;.2 fread UPFILE
(;(i~:i.#a)#d)fwrite UPFILE
i.0 0
)

NB. u;p
NB. return 0 if not valid u/p
NB. return 1 if valid u/p
check=: 3 : 0
if. -.fexist UPFILE do. 0 return. end.
'u p'=. y
if. -.(<u)e.getusers'' do. 0 return. end.
'salt h'=. 1 2{((getusers'')i.<u){show''
if. h-:hash p,salt do. 1 return. end.
0
)

show=: 3 :0
><;._1   each ':',each <;._2 fread UPFILE
)

