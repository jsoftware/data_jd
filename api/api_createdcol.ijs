NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

coclass'jd'

0 : 0
create derived col
normal name
 is not allowed/required in insert/update/upsert
derive function to calculate the col is in the col folder
derive is called in mapcol under try catch
result of derive col sets dat to a legal value
csv dump/restore carries derive defn???
validate doesn't look at derive col
dirty - set by data change
ptable
can it be done in select (like jdindex, instead of in mapcol)?
perhaps there should be a select version and a mapcol version

perhaps derived cols should just be normal mapped cols
 that are marked dirty whenever data changes
 and are derived whenever mapped
 
derived cols could be normal mapped cols
 or
they could be derived only

if mapped, that implies writing/reading from disk

if only calculated, potentially faster, less dirty pages, etc.
 
decision - go with not mapped! 

csv - option to dump derived col data or to dump the verb

delete???? does delete setdirty ???

jdloadcustom ???

update by key does not work!

validate data and catch errors before dat=:

info derived

mark dirty is agressive - e.g. in perhaps most case sort would be ok
 but instead sort does not sort derived and marks them dirty
 sort/dropcol/delete all mark derived dirty
)

0 : 0
derived=: 3 : '(Tlen,shape)$DATAFILL
)

jd_createdcol=: 3 : 0
q=. bdnames y
assertnotptable {.q
jd_createcol y
c=. jdgl 2{.q
('derive=: 3 : ''(Tlen,shape)$DATAFILL''')fwrite PATH__c,'derive.ijs'
load__c PATH__c,'derive.ijs'
derived__c=: 1
writestate__c'' 
jdunmap 'dat',Cloc__c
ferase PATH__c,'dat'
erase 'dat'
JDOK
)
