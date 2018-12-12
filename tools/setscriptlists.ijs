NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. sets tests as list of test and tuts as list of tuts
setscriptlists=: 3 : 0
NB. tests
p=. JDP
t=. 1 dir p,'test/*_test.ijs'
tests=: /:~(#p)}.each t

NB. tuts
d=. {."1 dirtree JDP,'tutorial'

NB. verify base names are unique
t=. (>:;d i:each'/')}.each d
t=. _8}.each t
t=. (1~:+/t =/ t)#d
if. 0~:#t do.
 echo >t
 'duplicate tutorial base names'assert 0
end.  

NB. fix order - guys that don't sort where we want them
zd=. d rplc each <'epochdt_tut.ijs';'zepochdt_tut.ijs'
zd=. zd rplc each <'admin_tut.ijs'; 'zzadmin_tut.ijs'
zd=. zd rplc each <'intro_csv_tut.ijs'; 'aintro_csv_tut.ijs'

d=. d/:_8}.each zd
tuts=: (#JDP,'tutorial/')}.each d
)
