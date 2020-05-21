NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
coclass 'jdtable'


NB. get col names with state flag
NB. cn_state 'derived' 
NB. cn_state 'derived_mapped'
cn_state=: 3 : 0
NAMES#~(3 : (y,'__y')) "0 CHILDREN NB. derived names
)

NB. x
NB.  _1 insert
NB.  _2 keyindex - update/delete/keyindex
NB.  #  update
NB.
NB. fixpairs can be called extra times on the same data - e.g. upsert->insert+update
NB.  FIXPAIRSFLAG avoids extra calls
NB.
NB. x is <0 no rules (insert/keyindex), # update rules (scalar extension)
NB. y is  name,value pairs
NB. return (possibly adjusted) names;values;rows
NB. values are converted to appropriate type
NB. loose scalar extension
NB.  scalars treated as 1 element lists
NB.  byteN - scalars and lists extend to be tables
NB.  byten - overtake OK, but undertake is an error
NB. x is _1 for insert and required rows for update
NB. all conform work is done here - may be duplicated later on
fixpairs=: 4 : 0
if. FIXPAIRSFLAG_jd_ *. -.x-:_2 do.
 ns=. (2*i.-:#y){y   NB. list of names
 vs=. (1+2*i.-:#y){y NB. list of values
 ns;vs;#>{.vs
 return.
end. 
FIXPAIRSFLAG_jd_=: 1

'name data pairs - odd number' assert (2<:#y)*.0=2|#y
ns=. ,each(2*i.-:#y){y NB. list of names
duplicate_assert ns
notjd_assert ns
unknown_assert ns-.NAMES
ns=. vs=. ts=. ''
for_i. i.-:#y do.
 j=. 2*i
 n=. <,;j{y
 FECOL_jd_=: >n
 EUNKNOWN assert n e. NAMES
 ns=. ns,n
 c=. 0{CHILDREN{~NAMES i. n
 ts=. ts,<shape__c
 d=. >(>:j){y
 if. -.''-:shape__c do. d=. >d end. NB. json needs this
 d=. fixtypex__c d
 if. -.''-:shape__c do.
  'fixpairs: bad shape'assert 'byte'-:typ__c
  if. 0=$$d do. d=. ,d end.
  if. 1=$$d do. d=. ,:d end.
  'bad shape (data trailing shape greater than col trailing shape)' assert ({:$d)<:shape__c 
  d=. shape__c{."1 d
 end.
 NB. if. 'edate'-:5{.typ__c do. EEPOCH assert -.IMIN e. d  end.
 d=. <d
 vs=. vs,d
 i=. >:i
end.
t=. ;#each vs
ETALLY assert 0=#t-.1,>./t
m=. x>.>./t
if. (1 e.t)*.1<m do. NB. scalar extension
 for_i. i.#vs do.
  d=. >i{vs 
  if. 1=#d do.
   vs=. (<m#d) i}vs
  end.
 end.
end.
t=. ;#each vs
rows=. {.t
'fixpairs: bad count'assert rows=t
ESHAPE assert (}.each$each vs)=ts

if. x=_1 do. NB. derived and dm support for insert/upsert
 dn=.  cn_state'derived'
 dmn=. cn_state'derived_mapped'
 
 
 EDERIVED assert 0=#FECOL_jd_=: ;{.ns#~ns e. dn,dmn
 EMISSING assert 0=#FECOL_jd_=: (NAMES#~-.bjdn NAMES)-.ns,dn,dmn
 
 
 if. #dmn do. d=. ,ns,.vs end.
 for_n. dmn do.
  c=. (NAMES i. n){CHILDREN
  ns=. ns,n
  vs=. vs,< fixtypex__c (dverb__c,'__c')~ d
 end.
end.


ns;vs;rows
)

NB. called by update to adjust derived_mapped cols
NB. y is rows to be updated
derived_mapped_update=: 3 : 0
dmn=. cn_state'derived_mapped'
for_n. dmn do.
 c=. (NAMES i. n){CHILDREN
 y modify__c fixtypex__c (dverb__c,'__c')~ y
end. 
)
