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
types=. TYPES,;:'ref reference hash unique smallrange'
'tabs cols bad cx tlen map type count filesize jsize'=. <0 1$''
try.
 for_c. y do.
  for_m. MAP__c do.
   om=. >m
   mn=. om,'__c'
   tabs=. tabs,NAME__PARENT__c
   cols=. cols,NAME__c
   tlen=. tlen,Tlen__c
   map=. map,om
   type=. type,typ__c
   s=. (countdat__c ::#) mn~
   s=. ('ref'-:typ__c){s,0
   count=. count,s
   t=. 0~:Tlen__c-s NB. 1 if too many or too few rows 
   t=. t*-.*./(typ__c;om)e.(;:'varbyte val'),(;:'ref dat') NB. supposed to be different
   a=. fsize PATH__c,'/',om
   b=. HS_jmf_+getmsize_jmf_ om,Cloc__c
   filesize=. filesize,a
   jsize=. jsize,b
   cx=. cx,(t+.a~:b){' X'
   r=. (<tabs),(<cols),(<cx),(<type),(<map),(<tlen),(<count),(<filesize),.(<jsize)
  end. 
 end. 
catchd.
 assert 0
 NB. logijfdamage 'validateclocs failed';''
end.

if. -.x-:'' do. if. +./' '~:;2{r do. logijfdamage x;'' end. end. 
(;:'tab col x type map tlen count fsize jsize'),:r
)

jd_validate=: 3 : 0
'validate failed'validateclocs jdclocs'';''
JDOK
)
