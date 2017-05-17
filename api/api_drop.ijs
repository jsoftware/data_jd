NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. release lock, jddeletefolder, admin unchanged
jd_dropdb=: 3 : 0
ECOUNT assert 0=#y
'f db'=. getfolder''
t=. dbpath db
'dropstop' assert (0=ftypex) t,'/jddropstop'
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
'dropstop' assert (0=ftypex) PATH__d,y,'/jddropstop'
if. -.(<y) e. NAMES__d do. JDOK return. end.
assertnoref ;y
t=. jdgl y

if. S_ptable__t do.
 p=. (<y,PTM),each ;{.getparts y
 Drop__d each p
 EDELETE assert ;(0=ftypex)"0 PATH__d&,each p 
 Drop__d y,PTM
 EDELETE assert (0=ftypex) PATH__d,y,PTM
end.

if. reset do. NB. we know there are no ref cols
 ns=. NAMES__t
 for_n. ns do.
  n=. ;n
  t=. jdgl y NB. could have changed
  c=. jdgl y,' ',n
  if. typ__c-:'varbyte' do.
   dat__c=: 0 2$2
   val__c=: ''
  else.
   dat__c=: (0,shape__c)$DATAFILL__c
  end.
 end.
 setTlen__t 0 NB. done at end!
else. 
 Drop__d y
 EDELETE assert (0=ftypex) PATH__d,y
end. 
JDOK
)

jd_dropcol=: 3 : 0
y=. bdnames y
ECOUNT assert 2=#y
d=. getdb''
'tab col'=. y
t=. getloc__d tab
'dropstop' assert (0=ftypex) PATH__t,col,'/jddropstop'
assertnodynamic y

t=. jdgl_jd_ :: 0: tab,PTM
if. 0~:t do.
 pcol=. getpcol__t''
 'drop pcol not allowed'assert -.pcol -: ;{:y
end.

if. -.({:y)e.{."1 jdcolsx {.y do. JDOK return. end.
ns=. getparttables ;{.y
for_i. i.#ns do.
 a=. (i{ns),{:y
 if. i=1 do. continue. end. NB. ignore f~
 t=. jdgl {.a
 f=. PATH__t,'column_create_order.txt'
 if. fexist f do. (;' ',~each (;:fread f)-.{:y)fwrite f end.
 DeleteCols__d a
 EDELETE assert (0=ftypex) PATH__t,;{:a
 
 if. 'jdref_'-:6{.col do.
  tab=. ;{.a
  t=. ({."1 t),.<"1 (}."1 t)
  f=. jdgl tab
  fb=. ({."1 SUBSCR__f)=<col
  EDNONE assert 1=+/fb
  SUBSCR__f=: (-.fb)#SUBSCR__f
  writestate__f''

  gn=. '^.',tab,'.',col
  t=. <;._2 col,'_'
  colb=. (-:#t){t
  g=. jdgl colb
  gb=. ({."1 SUBSCR__g)=<gn
  EDNONE assert 1=+/gb
  SUBSCR__g=: (-.gb)#SUBSCR__g
  writestate__g''
 end.
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
