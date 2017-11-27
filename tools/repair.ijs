NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jd'

0 : 0
Tlen set as <./Tlen,col counts
each col count set to Tlen
refs marked dirty if not already dirty
)

repair=: 3 : 0
p=. jdpath''
jdrepair'fixing it now' NB. insists on damaged
d=. getdb''
for_tn. NAMES__d do.
 tn=. ;tn
 t=. jdgl tn
 for_c. NAMES__t do.
  a=. jdclocs_jd_ tn;''
  count=. ''
  for_aa. a do.
   if. -.'jd'-:2{.NAME__aa do. count=. count,#dat__aa end.
  end.
 end.
 m=. <./count
 techo tn,' Tlen min-count max-count ',":Tlen__t,m,>./count
 if. Tlen__t>m do. setTlen__t <./count end.
 for_c. NAMES__t do.
  c=. getloc__t c
  cn=. NAME__c
  if. 'jdref_'-:3{.cn do. setdirty__c 1 continue. end.
  if. 'jd'-:2{.cn do. continue. end.
  if. Tlen__t~:#dat__c do.
   techo' repair count - ',cn
   dat__c=: Tlen__t{.dat__c
  end. 
 end. 
end.
jddamage_jd_'' NB. remove damage and repair mark
i.0 0
)