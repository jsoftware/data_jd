NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

coclass'jd'

fsub=: 3 : 0
if. 1=$$y do.
 ,.<"0 y 
else.
 ,.<"1 y 
end.
)

NB. Insert__d has a number of problems - e.g. shape mismatch damages a table
NB. api insert has extra validations/retrictions and gives better error messages
NB. missing/unknown/duplicate cols
NB. bad count/shape/data
NB. date/time must be integer
NB. date/time not allowed trailing shape
jd_insert=: 3 : 0
d=. getdb''
ETAB=: ;{.y
t=. getloc__d {.y
nv=. >vsub 1}.y

dtn=. 'datatune_',ETAB,'__d'
if. 3=nc<dtn do.
 jdn=. NAMES__t
 jdn=. (-.(<'jd')=2{.each jdn)#jdn
 nv=. jdn,.('jdn';{."1 nv) dtn~ jdn;{:"1 nv
end. 
ns=. {."1 nv
vs=. {:"1 nv
w=. ((<'jd')~:2{.each NAMES__t)#NAMES__t NB. required col names
if. #a=. w-.ns                       do. throw 'jde: insert missing'[ECOL=: ;a      end.
if. #a=. ns-.w                       do. throw 'jde: insert unknown'[ECOL=: ;a end.
if. #a=.(1<+/ns=/ns)#ns              do. throw 'jde: insert duplicate'[ECOL=: ;a end.

for_i. i.#ns do.
 c=. getloc__t i{ns
 v=. >i{vs
 'ECOL ETYP ESHAPE'=: NAME__c;typ__c;":shape__c
  
 if. 'edate'-:5{.typ__c do.
  if. JCHAR=3!:0 v do.
   v=. efs v
   vs=. (<v) i}vs NB. required because insert fixtype does not handle efs
   nv=. ns,.vs
  end. 
  select. typ__c
  case. 'edate' do.
   EEPRECISION assert *./0=86400|<.v%1e9
  case. 'edatetime' do.
   EEPRECISION assert *./0=1e9|v
  case. 'edatetimem' do.
   EEPRECISION assert *./0=1e6|v
  end.
 end.  
 
 select. #shape__c
 case. 0 do.
  EESHAPE assert -.1<#$v
  cnt=. ,#v
 case. 1 do.
  EESHAPE assert -. (<typ__c)e.;:'datetime date time'
  if. typ__c-:'byte' do.
   EESHAPE assert -.(2~:#$v)+.shape__c<{:$v
  else. 
   EESHAPE -.(2~:#$v)+.shape__c~:{:$v
  end. 
  cnt=. {.$v
 case.   do.
  EESHAPE assert 0
 end.

 if. i=0 do.
  cnt1=. cnt
 else.
  EESHAPE assert cnt1=cnt
 end. 

 m=. 'jde: insert bad data'
 vt=. 3!:0 v
 select. typ__c
 case. 'boolean' do.
  EETYPE assert vt=JB01
 case. 'float'   do.
  EETYPE assert vt e. JFL,JINT,JB01
 case. ;:'byte enum' do.
  EETYPE assert vt=JCHAR
 case. 'varbyte' do.
  EETYPE assert (vt=JBOXED)+.*/JCHAR=;3!:0 each v
 case.           do.
  EETYPE assert vt e. JINT,JB01
 end.
end.

active=. (NAMES__t i. <'jdactive'){CHILDREN__t

for_n. CHILDREN__t do.
 if. 'unique'-:typ__n do.
  vn=.  >{:{.subscriptions__n
  names=. {."1 ,.nv
  data=.  {:"1 ,.nv
  
  fs=.  |:>,each fsub each data
  if. 0 e. ~:fs do.
   ('not unique - (',(}:;names,each','),') new data row ',(":0 i.~ ~:fs),' with new data')assert 0
  end. 
  
  NB. detect new data not unique 
  for_i. i.#fs do.
   if. 1={:$fs do.
     p=. >(i.0)$i{fs
   else.  
    p=. i{fs
   end.  

   slot=. index__n p
   
   
   if. slot~:_1 do.
    if. slot{dat__active do. 
     ('not unique - (',(}:;names,each','),') new data row ',(":i),' with table row jdindex ',":slot)assert 0
    end. 
   end. 
  end.
  
  end. 
end. 

Insert__d  ({.y),<nv
JDOK
)

jd_update=: 3 : 0
ETAB=: ;{.y
ECOUNT assert 2<:#y
d=. getdb''
Update__d ({.y),<(1{y),vsub 2}.y
JDOK
)

jd_modify=: 3 : 0
ETAB=: ;{.y
ECOUNT assert 2<:#y
d=. getdb''
Modify__d ({.y),<(1{y),vsub 2}.y
JDOK
)