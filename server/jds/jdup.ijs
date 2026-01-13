NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage Jd user table

NB. serious production use that might be attacked
NB. should consider replacing this with reviewed code

coclass'jdup'

man_jd_server_user=: 0 : 0
user/pswd file for jds server

jds server requires logon with user/pswd
which is validated against upfile

upfile is in jdserver folder and is used by all server subfolders
pswd are encrypted

valid logon updates the uctable_jdup_ with the user;cookie
requests with cookie get the user from uctable

   uj=: 'jdserver' conew 'jdup' NB. jd/upfile
   getusers__uj''
   adduser__uj 'abc';'abc'
   deluser__uj''
)

create=: 3 :0
path=. y,('/'~:{:y)#'/' NB. trainling /
b=. (>:'/'i:~}:path){.path
t=. '/'-.~(('/',}:b)i:'/')}.b
'path must end in jdserver'assert t-:'jdserver'
'mkdir failed'assert 1=mkdir_j_ path
UPFILE=: path,'upfile'
if. -.fexist UPFILE do. '' fwrite UPFILE end.
i.0 0
)

require'guid'
hash=: 1&(128!:6) 

NB. logon user0/user0 -checked against upfile
NB. if valid, added to uctable
NB. returns 0 if invalid and 0,cookie if valid  
logon=: 3 : 0
'u p'=. <;._1 '/',dltb 6}.y
decho u;p
if. check u;p do.   NB. valid logon - record user/cookie uctable
 cookie=. (":6!:0'')rplc' ';'_'
 uctable=: uctable,u;cookie
 ({.a.),cookie NB. ok
else.
 {.a. NB. failed
end.
)

NB. returns 1 to set cookie empty
logoff=: 3 : 0
cookie=. y
uctable=: ((1{"1 uctable)~:<cookie)#uctable NB. remove entries with same cookie
1{a.
)

NB. cookie - get user with cookie from uctable
getuser=: 3 : 0
i=. (1{"1 uctable)i.<y
if. i=#uctable do. '' else. ;{.i{uctable end.
)

NB. u/p
NB. return 0 if not valid or 1 if valid
NB. must
NB.  not have blanks
NB.  have 1 /
NB.  u must have 3 chars
NB.  p must have 10 chars
NB.! testing p needs only 3 chars
validateup=: 3 : 0
if. (' 'e.y)+.1~:+/'/'=y do. 0 return. end.
'u p'=. <;._1 '/',y
if. (3>#u)+.3>#p do. 0 return. end.
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
'user table does not exist'assert fexist UPFILE
'invalid u/p'assert validateup y 
'u p'=. <;._1 '/',y
if. (<u)e.getusers'' do. deluser u end.
salt=. ,'0123456789abcdef' {~ 16 16 #: a. i. ,guids 1
((fread UPFILE),LF,~u,':',salt,':',hash p,salt)fwrite UPFILE
i.0 0
)

NB. user
deluser=: 3 : 0
'user table does not exist'assert fexist UPFILE
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


