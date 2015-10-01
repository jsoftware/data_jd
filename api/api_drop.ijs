NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. release lock, jddeletefolder, admin unchanged
jd_dropdb=: 3 : 0
ECOUNT assert 0=#y
'f db'=. getfolder''
t=. dbpath db
'dropstop' assert -.fexist t,'/jddropstop'
'x' jdadminlk t NB. should be done after Drop - see similar in jdadmin
Drop__f db
jddeletefolder t
JDOK
)

jd_droptable=: 3 : 0
y=. bdnames y
reset=. 0
if. 2=#y do.
 if. (<'/reset')-:{.y do.
  reset=. 1
  y=. {:y
 end. 
end.
ECOUNT assert 1=#y
y=. ;y
d=. getdb''
'dropstop' assert -.fexist PATH__d,y,'/jddropstop'
if. -.(<y) e. NAMES__d do. JDOK return. end.
assertnoreference ;y
if. reset do.
 t=. jdgl y
 Tlen__t=: 0
 ns=. NAMES__t
 for_n. ns do.
  n=. ;n
  t=. jdgl y NB. could have changed
  c=. jdgl y,' ',n
  if. 'jd'-:2{.n do.
   select. ;n
   case. 'jdactive' do.
    dat__c=: (0,shape__c)$DATAFILL__c
   case. 'jdindex' do.
   case.           do.
    jd_dropdynamic typ__c,' ',NAME__t,' ',(>:(;n) i. '_')}.;n
   end.
  else.
   if. typ__c-:'varbyte' do.
    dat__c=: 0 2$2
    val__c=: ''
   else.
    dat__c=: (0,shape__c)$DATAFILL__c
   end.
  end.
 end. 
else. 
 Drop__d y
 EDELETE assert -.fexist PATH__d,y
end. 
JDOK
)

jd_dropcol=: 3 : 0
y=. bdnames y
ECOUNT assert 2=#y
d=. getdb''
t=. getloc__d ;{.y
'dropstop' assert -.fexist PATH__t,(;{:y),'/jddropstop'
if. ({:y)e.{."1 jdcols {.y do.
 assertnodynamic y
 DeleteCols__d y
 EDELETE assert -.fexist PATH__t,;{:y
end. 
JDOK
)

dropdynsub=: 3 : 0
d=. getdb''
typ=. ;{.y
y=. }.y
select. typ

fcase. 'ref' do.
 ECOUNT assert 4=#y

case.'reference' do.
 ECOUNT assert (4<:#y)*.0=2|#y
 t=. (2,(#y)%2)$y
 validtc__d {.t
 validtc__d {:t
 t=. ({."1 t),.<"1 (}."1 t)
 fn=. 'jd',typ,,;'_'&,&.> ; boxopen&.> }.,y
 f=. jdgl ;{.{.t
 fb=. ({."1 SUBSCR__f)=<fn
 EDNONE assert 1=+/fb
 gn=. '^.',(;{.y),'.jd',typ,,;'_'&,&.> ; boxopen&.> }.,y
 g=. jdgl ;{.{:t
 gb=. ({."1 SUBSCR__g)=<gn
 EDNONE assert 1=+/gb
 jddeletefolder PATH__f,fn
 SUBSCR__f=: (-.fb)#SUBSCR__f
 writestate__f''
 SUBSCR__g=: (-.gb)#SUBSCR__g
 writestate__g''
case.'hash';'unique' do.
 ECOUNT assert 2<:#y
 validtc__d y
 fn=. 'jd',typ,,;'_'&,&.> ; boxopen&.> }.,y
 f=. jdgl ;{.y
 fb=. ({."1 SUBSCR__f)=<fn
 EDNONE assert 1=+/fb
 a=. {:{:fb#SUBSCR__f
 'dropdynamic hash/unique is used by reference' assert 1=+/a={:"1 SUBSCR__f
 SUBSCR__f=: (-.fb)#SUBSCR__f
 writestate__f''
 p=. PATH__f,fn
 jd_close'' NB. reopened and must be closed to delete
 jddeletefolder p
case.do.
 'dropdynamic unknown type'assert 0
end.
jd_close''
JDOK
)

jd_dropdynamic=: 3 : 0
jd_close''
y=. bdnames y
if. #y do. dropdynsub y return. end.
p=. dbpath DB
d=. 1!:0 <jpath p,'/*'
d=. (<p,'/'),each {."1 ('d'=;4{each 4{"1 d)#d
d=. (fexist d,each <'/jdclass')#d
d=. ((<'table')=jdfread each d,each <'/jdclass')#d
for_n. d do.
 dd=. {."1[1!:0 <jpath'/*',~;n
 b=. (<'jdhash_')=7{.each dd
 b=. b+.(<'jdunique_')=9{.each dd
 b=. b+.(<'jdreference_')=12{.each dd
 b=. b+.(<'jdref_')=6{.each dd
 dd=. b#dd
 jddeletefolder each n,each,'/',each dd
 f=. '/jdstate',~;n
 s=. 3!:2 jdfread f
 i=. ({."1 s)i.<'SUBSCR'
 s=. (<0 3$a:) (<i,1)}s
 (3!:1 s) fwrite f
end.
JDOK
)

jd_dropfilesize=: 3 : 0
getdb''
p=. jpath dbpath DB
maps=. mappings_jmf_
maps=. maps /:1{"1 maps
d=. 1{"1 maps
b=. (;(<p)-:each (#p){.each d)
d=. b#d
h=. b#{."1 maps
rn=. ra=. rz=. ''
for_i. i.#h do.
 n=. >i{h
 type=. 3!:0 n~
 size=. (JTYPES i.type){JSIZES
 shape=. $n~
 dsize=. size**/shape
 msize=. getmsize_jmf_ n
 assert (fsize i{d)=HS_jmf_+msize
 assert msize>:dsize
 rn=. rn,i{d
 ra=. ra,fsize i{d
 rz=. rz,HS_jmf_+dsize
 if. msize>dsize do.
  setmsize_jmf_ n;dsize 
  jdunmap n
  newsize_jmf_ (;i{d);HS_jmf_+dsize
 else.
  jdunmap n
 end. 
end.
jd_close''
('file';'old';'new'),:(<>rn),(<,.ra),<,.rz
)
