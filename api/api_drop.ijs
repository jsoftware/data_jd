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
'dropstop' assert (0=ftypex) PATH__dbl,y,'/jddropstop'
if. -.(<y) e. NAMES__dbl do. JDOK return. end.
assertnoref ;y
t=. jdgl y

if. S_ptable__t do.
 p=. (<y,PTM),each ;{.getparts y
 Drop__dbl each p
 EDELETE assert ;(0=ftypex)"0 PATH__dbl&,each p 
 Drop__dbl y,PTM
 EDELETE assert (0=ftypex) PATH__dbl,y,PTM
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
 Drop__dbl y
 EDELETE assert (0=ftypex) PATH__dbl,y
end. 
JDOK
)

jd_dropcol=: 3 : 0
y=. bdnames y
ECOUNT assert 2=#y
'tab col'=. y
t=. getloc__dbl tab
'dropstop' assert (0=ftypex) PATH__t,col,'/jddropstop'
assertnodynamic y

if. isptable tab do.
 t=. jdgl tab,PTM
 pcol=. getpcol__t''
 'drop pcol not allowed'assert -.pcol -: ;{:y
end.

if. -.({:y)e.{."1 jdcolsx {.y do. JDOK return. end.
ns=. getparttables ;{.y
for_i. i.#ns do.
 a=. (i{ns),{:y
 if. i=1 do. continue. end. NB. ignore f~
 t=. jdgl {.a
 
 cco_remove__t ;{:a
 
 Drop__t ;{:a
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
 rn=. rn,i{d
 ra=. ra,fsize i{d
 rz=. rz,HS_jmf_+psroundup dsize
 jdunmap n;dsize
 jdmap n;i{d
end.
('file';'old';'new'),:(<>rn),(<,.ra),<,.rz
)
