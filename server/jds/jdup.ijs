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

NB. * upfile name - must be test_upfile or upfile
create=: 3 :0
'name must be upfile or test_upfile'assert (<y)e.'upfile';'test_upfile'
'mkdir failed'assert 1=mkdir_j_ jdscpath_jd_,'up'
UPFILE=: jdscpath_jd_,'up/',y
if. -.fexist UPFILE do. '' fwrite UPFILE end.
i.0 0
)

destroy=: codestroy

require'guid'
hash=: 1&(128!:6) 

NB. update dan in ductable
setdan=: 3 : 0
'up dan'=. y
i=. ({:"1 ductable)i.<up
'logon required'assert i<#ductable
NB.! what if bad user
d=. i{ductable
d=. dan;1}.d
ductable=: d i}ductable
,:'Jd OK';0
)

NB. ductable dan,user,cookie
logon=: 3 : 0
'dan user pswd'=: bdnames y
if. check user;pswd do.
 cookie=. ,'0123456789abcdef' {~ 16 16 #: a. i. ,guids 1
 ductable=: ductable,dan;user;cookie
 ({.a.),cookie
else.
 {.a. NB. failed
end.
)

NB. returns 1 to set cookie empty
logoff=: 3 : 0
cookie=. y
ductable=: ((2{"1 ductable)~:<cookie)#ductable NB. remove entries with same cookie
1{a.
)

NB. cookie - get user with cookie from ductable
get_dan_user=: 3 : 0
i=. ({:"1 ductable)i.<y
if. i=#ductable do. '';'' else. 2{.i{ductable end.
)

NB. u/p
NB. return 0 if not valid or 1 if valid
NB. must
NB.  not have blanks
NB.  have 1 /
NB.  u must have at least 1 char
NB.  p must have at least 1 char
NB.! testing p needs only 3 chars
validateup=: 3 : 0
if. (' 'e.y)+.1~:+/'/'=y do. 0 return. end.
'u p'=. <;._1 '/',y
if. (0=#u)+.0=#p do. 0 return. end.
1
)

NB. create empty u/p UPfile
init=: 3 : 0
'u/p table already exists'assert -.fexist UPFILE
'' fwrite UPFILE
)

getusers=: 3 : 0
{."1 show UPFILE
)

NB. user/pswd
NB. deletes user first if already added
adduser=: 3 : 0
'invalid u/p'assert validateup y 
'u p'=. <;._1 '/',y
if. (<u)e.getusers'' do. deluser u end.
salt=. ,'0123456789abcdef' {~ 16 16 #: a. i. ,guids 1
((fread UPFILE),LF,~u,':',salt,':',hash p,salt)fwrite UPFILE
i.0 0
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


