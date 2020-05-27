NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. blank delimited names up to *
bdn=: 3 : 0
'must not be boxed' assert 0=L.y
i=. y i.'*'
'* not found'assert i<#y
t=. i{.y
(<(bdnames i{.y)),<(>:i)}.y
)

jd_blobwrite=: 3 : 0
'must be boxed'assert 1=L.y
ECOUNT assert (#y)e.2 3 4
data=. >{:y
h=. }:y
name=. ;{:h
vcname name
d=. }:h
p=. (dbpath DB),'/',;d,each'/'
'not a jd folder' assert fexist p,'jdstate'
p=. p,'jdblob'
jdcreatefolder p
'blob write failed' assert _1-.@-:data fwrite p,'/',name,'.blob'
JDOK
)

jd_blobread=: 3 : 0
d=. bdnames y
'bad arg count'assert (#d)e.1 2 3
name=. ;{:d
d=. }:d
p=. (dbpath DB),'/',;d,each'/'
p=. 'jdblob',~(dbpath DB),'/',;d,each'/'
r=. fread p,'/',name,'.blob'
'blob read failed'assert _1-.@-:r
NB. ((;d,each'/'),name);r
'blob';r
)

jd_bloberase=: 3 : 0
d=. bdnames y
'bad arg count'assert (#d)e.1 2 3
name=. ;{:d
d=. }:d
p=. 'jdblob',~(dbpath DB),'/',;d,each'/'
r=. ferase p,'/',name,'.blob'
'blob erase failed'assert _1-.@-:r
JDOK
)
