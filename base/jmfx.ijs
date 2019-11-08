NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. jd jmf operations
NB. error checks beyond those provided by jmf
NB. the error checks should eventually be included in jmf
jdcreatejmf=: 3 : 0
createjmf_jmf_ y
if. -.fexist {.y              do. logijfdamage 'createjmf a';y end. 
if. (fsize {.y)~:HS_jmf_+;1{y do. logijfdamage 'createjmf b';y end.
)

NB. map ro if ro
jdmap=: 3 : 0
0 jdmap y
:
cnts_map_jd_=: >:cnts_map_jd_
'jn fn'=. 2{.y
y=. y,'';JDMT NB. MTRW or MTRO or MTCW
('map name invalid: ',jn)assert _1=nc <jn
('map file does not exist: ',fn)assert fexist fn
try.
 x map_jmf_ y
catchd.
 echo 'jdmap failed - will retry : ',fn,' : ',LF-.~,13!:12''
 try.
  6!:3[5
  x map_jmf_ y
 catchd. 
  echo 'jdmap failed - failed again : ',fn,' : ',LF-.~,13!:12''
  FEER_jd_=: 13!:12''
  logijfdamage 'map';y
 end. 
end.
)

jdunmap=: 3 : 0
if. 0=L.y do.
 r=. unmap_jmf_ y
 ('unmap failed: ',(":r),' ',y) assert 2~:r
 return.
end.
fn=. 1{(({."1 mappings_jmf_)i.{.y){mappings_jmf_
r=. unmap_jmf_ y
('unmap resize failed: ',(":r),' ',;{.y)assert 2~:r
NB. resize failure not detected
if. (fsize fn)~:HS_jmf_+;1{y do.
 logijfdamage 'unmap resize bad size';y
end. 
)

validaterefcounts=: 4 : 0
if. *./2=t=. ;refcount_jmf_ each 6{"1 mappings_jmf_ do. return. end.
x logtxt_jd_ showmap_jmf_'' NB. validaterefcounts
'validaterefcounts failed'assert 0
)

NB. following should be part of jmf.ijs
coclass'jmf'

3 : 0''
if. IFUNIX do.
  c_truncate=: ((unxlib 'c'),' truncate i *c x') & cd
end.
i.0 0
)

setcount=: 3 : 0
'name count'=. y
sad=. 15!:6 <fullname name
had=. 1{memr sad,0 4,JINT
count memw had,HADS,1,JINT
i.0 0
)

getcount=: 3 : 0
sad=. symget <fullname y
had=. 1{memr sad,0 4,JINT
''$memr had,HADS,1,JINT
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

3 : 0''
if. IFWIN do.
 NB. BOOL WINAPI FlushViewOfFile(_In_ LPCVOID lpBaseAddress,_In_ SIZE_T  dwNumberOfBytesToFlush);
 NB. BOOL WINAPI FlushFileBuffers(_In_ HANDLE hFile);
 NB. jmf.ijs has a bad definition for FlushViewOfFile so we use ....X
 FlushViewOfFileRX=: 'kernel32 FlushViewOfFile > i x x'&(15!:0)
 FlushFileBuffersR=: 'kernel32 FlushFileBuffers > i x'&(15!:0)
else.
 lib=. ' ',~ unxlib 'c'
 api=. 1 : ('(''',lib,''',x) & cd')
 c_fsync=: 'fsync i x'api NB. file descriptor - file handle
end.
i.0 0
)

flush=: 3 : 0
for_m. mappings_jmf_ do.
  'fh dad had'=. >3 5 6{m
  if. IFWIN do.
   FlushViewOfFileRX dad,HS+msize had
   FlushFileBuffersR fh
  else.
   c_fsync fh
 end.
end.
)
