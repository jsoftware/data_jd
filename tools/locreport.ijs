coclass'jd'

NB. report on all locales

locrep=: 4 : 0
if. 0=nc__x <y do. r=. ;(y,'__x')~ else. r=. '' end.
if. 20<#r do. r=. (5{.r),'...',_10{.r end.
)

jdlocreport=: 3 : 0
n=. /:~conl 1
maps=. {."1 mappings_jmf_
r=. 0 3$0
nms=. ;:'CLASS NAME__PARENT NAME typ'
t=. 4 : 'if. 0=nc__x <y do. ;(y,''__x'')~ else. '''' end.'
for_c. n do.
 r=. r,c,((<c) locrep each nms),<' x'{~(<'dat_',(;c),'_')e.maps
end.
)

