NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

0 : 0
JE does overfetch by 7 bytes - crash if unallocated
JE also uses 71 bytes after for performance reasons
JE fills jmf file msize to the last byte

createjmf could provide PAD after msize that was in the file
but this has BIG deployment problems because of back level Jd installs
see bup code for jmf addon that does this, but was stashed

solution is to have Jd ensure jmf filesize always ends PAD bytes before page bounary
this means overfetch and performance access will access bytes after filesize
 that are still valid as they are in the allocated page

this Jd fix does not fix problem for other jmf users or for non-jmf use
so the crash exposure is still there for jmf and non-jmf files that have less than
7 bytes before a page boundary

the JMFPAD use here should probably eventually be incorporated into jmf addons
)

coclass'jd'

JMFPAD=: 96     NB. round up from 71 because 96 is a nicer than 71
PAGESIZE=: 4096 NB. crash exposure if this assumption is wrong

NB. roundup msize to that filesize will be at pageboundary-pad
psroundup=: 3 : 0
c=. (PAGESIZE*>.(HS_jmf_+y+JMFPAD)%PAGESIZE)-HS_jmf_+JMFPAD
assert c>:y
assert 0=PAGESIZE|HS_jmf_+JMFPAD+c
c
)

psroundupfs=: 3 : 0
HS_jmf_+psroundup y-HS_jmf_
)

NB. enforce JMFPAD safe filesize and extra error checks
NB. msize increased so all available bytes are used
jdcreatejmf=: 3 : 0
'a b'=. y
c=. psroundup b
createjmf_jmf_ a;c
if. -.fexist {.y              do. logijfdamage 'createjmf a';y end. 
NB. if. (fsize {.y)~:HS_jmf_+;1{y do. logijfdamage 'createjmf b';y end.
)

NB. psroundup if necessary
NB. jmf files are remapped with new size if necessary to ensure JMFPAD
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
if. 0=x do.
 NB. jmf resize if HS+msize not at pageboundary-pad
 fs=. fsize fn
 a=. HS_jmf_+psroundup fs-HS_jmf_ NB. preferred file size
 if. a~:fs do.
  jdunmap jn;a
  jdmap jn;fn;'';JDMT
 end. 
end. 
)

NB. resize does psroundup if necessary
jdunmap=: 3 : 0
if. 0=L.y do.
 r=. unmap_jmf_ y
 ('unmap failed: ',(":r),' ',y) assert 2~:r
 return.
end.
fn=. 1{(({."1 mappings_jmf_)i.{.y){mappings_jmf_
'a b'=. y
c=. psroundup b
y=. a;c
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

NB. get msize from name
getmsize=: 3 : 0
had=. memhad fullname y
''$memr had,HADM,1,JINT
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
 api=. 1 : ('(''',lib,''',m) & cd')
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
