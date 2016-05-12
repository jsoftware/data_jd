NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

coclass'jd'

valsize=: 4 : 0
mr=. mappings_jmf_{~({."1 mappings_jmf_)i.<x,'_',(;y),'_'
ms=. msize_jmf_ >6{mr
fs=. fsize 1{mr
assert fs=ms+HS_jmf_
)


NB. y is table to validate
NB. x is error text to signal if validation detects problem
validatetable=: 4 : 0
e=. 'validate failed ',x,' ',OP
if. FORCEVALIDATEAFTER_jd_*.x-:'after' do. logijfdamage e;''[FORCEVALIDATEAFTER_jd_=: 0 end.
e validateclocs jdclocs y;''
)

NB. y is list of column locales to validate
NB. x is '' for info (return result and do not damage)
NB. x 'err' - if validate detects error, db marked damaged and error signaled
validateclocs=: 4 : 0
t=. 0 11$''
types=. TYPES,;:'ref reference hash unique smallrange'
try.
 for_c. y do.
  for_m. MAP__c do.
   om=. >m
   mn=. om,'__c'
   r=. ''
  
   r=. r,<NAME__PARENT__c
   r=. r,<NAME__c
   r=. r,m
   r=. r,<typ__c
   r=. r,<":(om-:'val'){2,~(types i. <typ__c){TYPESj,4 4 4 4 4 _
   r=. r,<":3!:0 mn~
   
   select. om
   case. 'link' do. s=. Tlen__c
   case. 'hash' do. s=. #mn~ NB. force to what it is
   case. 'datr' do. s=. #mn~ NB. force to what it is
   case. 'datl' do. s=. Tlen__c  
   case. 'val'  do. s=. #mn~ NB. force to what it is
   case.        do. s=. Tlen__c,shape__c
   end.
   if. (typ__c-:'varbyte')*.om-:'dat'     do. s=. Tlen__c,2 end.
   if. (typ__c-:'smallrange')*.om-:'hash' do. s=. $mn~      end. NB. force to what it is
   if. typ__c-:'ref' do. if. dirty__c     do. s=. #mn~      end. end. NB. force to what it is
   r=. r,<":,s
   r=. r,<":$mn~
   r=. r,<":fsize PATH__c,'/',om
   
   r=. r,<":HS_jmf_+getmsize_jmf_ om,Cloc__c
   r=. r,<":(~:/4 5{r)+.(~:/6 7{r)+.~:/8 9{r
   t=. t,r
  end. 
 end. 
 t 
catchd.
 logijfdamage 'validateclocs failed';''
end.
t=.(<>0{"1 t),(<>1{"1 t),(<>2{"1 t),(<>3{"1 t),(<>4{"1 t),(<>5{"1 t),(<>6{"1 t),(<>7{"1 t),(<>8{"1 t),(<>9{"1 t),.(<>10{"1 t)
if. -.x-:'' do. if. +./'1'=,;{:t do. logijfdamage x;'' end. end. 
(;:'table column map jdtype jdtypex jtype jdshape jshape fsize jsize bad'),:t
)

jd_validate=: 3 : 0
'validate failed'validateclocs jdclocs'';''
JDOK
)
