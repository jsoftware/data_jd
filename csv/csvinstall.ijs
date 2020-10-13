NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass'jdcsv'

csvjd=: 3 : 0
unmapall_jmf_''
'pathjd pathcsvfolder'=. y

t=. dfromn_jd_ each (a:~:CSVCOLS)#CSVCOLS

jdfiles=: jpath each (<pathjd),each '/',each t,each '/'
jddat=: jdfiles,each<'dat'
jdval=: jdfiles,each<'val'

NB. csvdat=: jpath each (<pathcsvfolder),each '/',each (<'c_'),each CSVCOLS
NB. csvval=: jpath each (<pathcsvfolder),each '/',each (<'v_'),each CSVCOLS
NB. assume ccfiles and cvfiles from immediately previous csvload/csvappend

csvdat=: (a:~:ccfiles)#ccfiles
csvval=: (a:~:ccfiles)#cvfiles

b=. ;fexist"0 csvdat
assert b-:;fexist"0 jddat['mismatch between csv and jd dat files'
jd=: b#jddat
csv=: b#csvdat
b=. ;fexist"0 csvval
assert b-:;fexist"0 jdval['mismatch between csv and jd val files'
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
 smoutput sptable(jdt=<'unsupported')#csvc,.csvt
 assert 0['unsupported type'
end.
v=. (jdt=<'byte')*b#2{"1 COLDEFS
s=. ":each v
s=. ' ',each a: ((v=0)#i.#v)}s
NB. t=. csvc,.jdt,.s
t=. ((jdaddq_jd_)each csvc),.jdt,.":each csvs
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

if. MANGLEDNAMES do. CSVCOLS=: b#originalnames end. 

CSVTYPS=: b#CSVTYPS
JDTYPS=: b#JDTYPS
COLDEFS=: b#COLDEFS
CSVTSHAPE=: b#CSVTSHAPE

NB. JDTYPS=: (<'byte') ((CSVTYPS=<'CI1')#i.#CSVTYPS)}JDTYPS NB. kludge map CI1 to byte
NB. JDTYPS=: (<'byte') ((CSVTYPS=<'CI2')#i.#CSVTYPS)}JDTYPS NB. kludge map CI2 to byte
NB. JDTYPS=: (<'byte') ((CSVTYPS=<'CI4')#i.#CSVTYPS)}JDTYPS NB. kludge map CI4 to byte

NB. CSVTSHAPE=: (<'byte') ((CSVTYPS=<'CI1')#i.#CSVTYPS)}JDTYPS NB. kludge map CI1 to byte
NB. CSVTSHAPE=: (<'byte') ((CSVTYPS=<'CI2')#i.#CSVTYPS)}JDTYPS NB. kludge map CI2 to byte
NB. CSVTSHAPE=: (<'byte') ((CSVTYPS=<'CI4')#i.#CSVTYPS)}JDTYPS NB. kludge map CI4 to byte

d=. getdb_jd_''
Create__d table;''

a=. csvjdcoldefs csv
cds=. 3{.each ' 'strsplit_jd_ each ((LF e. a){',',LF) strsplit_jd_ debq_jd_ }:a
t=. getloc__d table
for_d. cds do.
 d=. >d
 ICol__t  (jdremq_jd_ ;{.d);;' ',~each  1}.d
end.

jd_close_jd_''
csvjd  jd;csv
(3!:1 [1 2$'Tlen';ROWS) fwrite jd,'/jdstate' NB. writestate TLen essential
getdb_jd_'' NB. restore dbl after close

NB. int1, int2, int4 need shape fixed
NB. csv loader creates intx cols as n,x cols
NB. Jd needs intx cols to have shape'' and be the ravel
cols=. CSVCOLS#~JDTYPS e. ;:'int1 int2 int4'
if. #cols do.
 jdrepair_jd_'csv fix intx'
 for_n. cols do.
  c=. jdgl_jd_ table,' ',;n
  shape__c=: ''
  dat__c=: ,dat__c
 end.
 jdrepair_jd_''
end. 

jdi_read_jd_ 'from ',table,' where jdindex=1' NB. file resize to get JMFPAD
chksize_jd_''
)
