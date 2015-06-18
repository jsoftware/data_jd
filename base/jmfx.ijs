NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. jd jmf operations
NB. single point for trace
NB. error checks beyond those provided by jmf
NB. the error checks should eventually be included in jmf

jdcreatejmf=: 3 : 0
'createjmf'trace y
createjmf_jmf_ y

if. -.fexist {.y do.
 'jd createjmf failed'trace {.y
 6!:3[5
 createjmf_jmf_ y
end. 

if. (fsize {.y)~:HS_jmf_+;1{y do.
 jddamage'create failed (previous jddeletefolder failed?): ',;{.y
end.
)

jdmap=: 3 : 0
0 jdmap y
:
cnts_map_jd_=: >:cnts_map_jd_
'map'trace y
('map name invalid: ',;{.y)assert _1=nc {.y
('map file does not exist: ',;1{y)assert fexist 1{y
try.
 x map_jmf_ y
catchd.
 echo 'jdmap failed unexpectedly - will retry'
 6!:3[5
 x map_jmf_ y
end.
)

jdunmap=: 3 : 0
'unmap'trace y
if. 1=L.y do.
 fn=. 1{(({."1 mappings_jmf_)i.{.y){mappings_jmf_
 unmap_jmf_ y NB. resize failure not detected
 if. (fsize fn)~:HS_jmf_+;1{y do.
  jddamage 'resize failed: ',;fn
 end. 
else.
 unmap_jmf_ y
end.
)

NB. following should be part of jmf.ijs
coclass'jmf'

3 : 0''
if. IFUNIX do.
  lib=. >(UNAME-:'Darwin'){'libc.so.6 ';'libc.dylib '
  api=. 1 : ('(''',lib,''',x) & cd')
  c_truncate=: ' truncate i *c x' api
end.
i.0 0
)

NB. set allocation size of mapped noun
setmsize=: 3 : 0
'name msize'=. y
sad=. symget <fullname name
had=. 1{memr sad,0 4,JINT
msize memw had,HADM,1,JINT
i.0 0
)

getmsize=: 3 : 0
sad=. symget <fullname y
had=. 1{memr sad,0 4,JINT
''$memr had,HADM,1,JINT
)

NB. newsize fn;size
newsize=: 3 : 0
'fn size'=. y
if. IFUNIX do.
 c_truncate fn;size
else.
 t=. fn;(GENERIC_READ+GENERIC_WRITE);0;NULLPTR;OPEN_EXISTING;0;0
 fh=. CreateFileR t
 SetFilePointerR fh;size;NULLPTR;FILE_BEGIN
 SetEndOfFile fh
 CloseHandleR fh
end.
i.0 0
)
