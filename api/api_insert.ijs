NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

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
FETAB=: ;{.y
t=. getloc__d {.y
nv=. vsub 1}.y

dtn=. 'datatune_',FETAB,'__d'
if. 3=nc<dtn do.
 jdn=. NAMES__t
 jdn=. (-.(<'jd')=2{.each jdn)#jdn
 nv=. jdn,.('jdn';{."1 nv) dtn~ jdn;{:"1 nv
end. 
ns=. {."1 nv
vs=. {:"1 nv
all=. ((<'jd')~:2{.each NAMES__t)#NAMES__t NB. all col names
unknown_assert ns-.all
missing_assert all-.ns
duplicate_assert ns

cnt=. _1 NB. all have the same count - get count from first one
for_i. i.#ns do.
 c=. getloc__t i{ns
 cnt=. (0,cnt) validate_data__c >i{vs
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
FETAB=: ;{.y
ECOUNT assert 2<:#y
d=. getdb''
Update__d ({.y),<(1{y),<vsub 2}.y
JDOK
)

jd_modify=: 3 : 0
FETAB=: ;{.y
ECOUNT assert 2<:#y
d=. getdb''
t=. getloc__d {.y

w=. ;1{y
if. 2=3!:0 w do.
 w=. getwhere__t w
else.
 if. 4~:3!:0 w do. NB. see fixtype_num_jdtint_
  if. 1=3!:0 w do. w=. 0+w else. EINDEX assert 0 end.
 end.
 w=. ,w
 EINDEX assert *./(0<:w),Tlen__t>w
end.
nv=.  vsub 2}.y
ns=. {."1 nv
vs=. {:"1 nv
all=. ((<'jd')~:2{.each NAMES__t)#NAMES__t NB. all col names
unknown_assert ns-.all
duplicate_assert ns

for_i. i.#ns do. NB. validate
 c=. getloc__t {.i{ns
 assertnodynamic NAME__PARENT__c;NAME__c
 (1,#w) validate_data__c >i{vs 
end.

for_i. i.#ns do.
 c=. getloc__t {.i{ns
 w modify__c >i{vs
end. 

EMPTY
JDOK
)
