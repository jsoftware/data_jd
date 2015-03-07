NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass'jdcsv'

NB. data f file
csvjdxsub=: 4 : 0
f=. jpath y
ferase f
jdcreatejmf_jd_ f;(#x)*(4=3!:0 x){1 8
jdmap_jd_ 'snk_jdcsv_';f
snk_jdcsv_=: x
jdunmap_jd_ 'snk_jdcsv_'
)

csvjdx=: 3 : 0
(ROWS#1) csvjdxsub y,'/jdactive/dat'   NB. active
)

csvjd=: 3 : 0
unmapall_jmf_''
'pathjd pathcsvfolder'=. y

t=. (a:~:CSVCOLS)#CSVCOLS

jdfiles=: jpath each (<pathjd),each '/',each t,each '/'
jddat=: jdfiles,each<'dat'
jdval=: jdfiles,each<'val'

NB. csvdat=: jpath each (<pathcsvfolder),each '/',each (<'c_'),each CSVCOLS
NB. csvval=: jpath each (<pathcsvfolder),each '/',each (<'v_'),each CSVCOLS
NB.! assume ccfiles and cvfiles from immediately previous csvload/csvappend

csvdat=: (a:~:ccfiles)#ccfiles
csvval=: (a:~:ccfiles)#cvfiles

b=. ;fexist csvdat
assert b-:;fexist jddat['mismatch between csv and jd dat files'
jd=: b#jddat
csv=: b#csvdat
b=. ;fexist csvval
assert b-:;fexist jdval['mismatch between csv and jd val files'
jd=: jd,b#jdval
csv=: csv,b#csvval
ferase each jd
jd frename each csv
i.0 0
)

csvjdcoldefs=: 3 : 0
b=. CSVTYPS~:<'CSTITCH'
csvt=: b#CSVTYPS
csvc=: b#CSVCOLS
csvs=: b#CSVTSHAPE
jdt=: b#JDTYPS
if. (<'unsupported')e. jdt do.
 smoutput showbox(jdt=<'unsupported')#csvc,.csvt
 assert 0['unsupported type'
end.
v=. (jdt=<'byte')*b#2{"1 COLDEFS
s=. ":each v
s=. ' ',each a: ((v=0)#i.#v)}s
NB. t=. csvc,.jdt,.s
t=. csvc,.jdt,.":each csvs
;(t,each' '),.<LF
)

jdfromcsv=: 3 : 0
'jd csv'=. y
t=. <;.2 jd,'/'
table=. }:>_1{t
db=. }:>_2{t
path=. }:;_2}.t
'CSVCOLS CSVTYPS JDTYPS CSVTSHAPE COLDEFS ROWS'=: 3!:2 jdfread_jd_ csv,'/info'

b=. CSVTYPS~:<'CNOT'
CSVCOLS=: b#CSVCOLS
CSVTYPS=: b#CSVTYPS
JDTYPS=: b#JDTYPS
COLDEFS=: b#COLDEFS
CSVTSHAPE=: b#CSVTSHAPE

JDTYPS=: (<'byte') ((CSVTYPS=<'CI1')#i.#CSVTYPS)}JDTYPS NB. kludge map CI8 to byte

d=. getdb_jd_''
Create__d table;<csvjdcoldefs csv
NB. Close__f db
jd_close_jd_''

csvjd  jd;csv
csvjdx jd
)
