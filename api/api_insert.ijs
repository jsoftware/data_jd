NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB.!
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
ETAB=: >{.y
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
 m=. 'jde: insert bad shape'
 select. #shape__c
 case. 0 do.
  if. 1<#$v do. throw m end.
  cnt=. ,#v
 case. 1 do.
  if. (<typ__c)e.;:'datetime date time' do. throw m end.
  if. typ__c-:'byte' do.
   if. (2~:#$v)+.shape__c<{:$v do. throw m end.
  else. 
   if. (2~:#$v)+.shape__c~:{:$v do. throw m end.
  end. 
  cnt=. {.$v
 case.   do.
  throw m
 end.

 if. i=0 do.
  cnt1=. cnt
 else.
  if. cnt1~:cnt do. throw 'jde: insert bad count' end.
 end. 

 m=. 'jde: insert bad data'
 vt=. 3!:0 v
 select. typ__c
 case. 'boolean' do.
  if. vt~:JB01 do. throw m end.
 case. 'float'   do.
  if. -.vt e. JFL,JINT,JB01 do. throw m end.
 case. ;:'byte enum' do.
  if. vt~:JCHAR do. throw m end.
 case. 'varbyte' do.
  if. (vt~:JBOXED)+.-.*/JCHAR =;3!:0 each v do. throw m end.
 case.           do.
  if. -.vt e. JINT,JB01 do. throw m end.
 end.
 
 NB.! kill off
 if. unique__c do.
  a=. getloc__t 'jdactive'
  ('insert table * col * not unique'erf NAME__t;NAME__c) assert 0=+/(;i{vs)e.dat__a#dat__c
 end.

end.

active=. (NAMES__t i. <'jdactive'){CHILDREN__t

for_n. CHILDREN__t do.
 if. 'unique'-:typ__n do.
  vn=.  >{:{.subscriptions__n
  names=. {."1 ,.nv
  data=.  {:"1 ,.nv
  
  qfs__=: fs=.  |:>,each fsub each data
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
