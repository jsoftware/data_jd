NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. performance measurement utils

s1=: 0 : 0
jdadminx'test'
jd'gen test a X'
jd'close'
jd'gen test b X'
jd'close'
jd'gen test c X'
jd'close'
jd'gen test d X'
jd'close'
jd'gen test e X'
jd'close'
jd'ref a x b x'
jd'reads from a,a.b where x=5'
)

s2=: 0 : 0
jdadminx'test'
jd'gen test a X'
jd'gen test b X'
jd'gen test c X'
jd'gen test d X'
jd'gen test e X'
jd'ref a x b x'
jd'reads from a,a.b where x=5'
)

tmit=: 4 : 0
r=. ''
s=. <;._2 x
c=. #s
r=. i.(#s),0
for_i. y do.
 t=. s rplc each <'X';":i
 r=. r,.<.each timex each t
end.
r=. r,.s
LAST=: ((<"0 y),<'sentences'),r
)

NB. time to map and unmap

pmmap=: 3 : 0
c=: 100
echo (":c),' count'

jd'close'
unmapall_jmf_''

p=. '~temp/jd/pm/'
jddeletefolder_jd_ p
jdcreatefolder_jd_ p

a=. 6!:1''
for_i. i.c do.
 createjmf_jmf_ (jpath p,'a',(":i),'.jmf');1e6
end.
cf=. (6!:1'')-a
echo (":cf),' time to createjmf files'

a=. 6!:1''
for_i. i.c do.
 map_jmf_ ('a',":i);(jpath p,'a',(":i),'.jmf')
end.
mt=. (6!:1'')-a
echo (":mt),' time to map files'

a=. 6!:1''
unmapall_jmf_''
umt=. (6!:1'')-a
echo (":umt),' time to unmap'

jdadminx'test'
jd'createtable f ', }:;(<' int,'),~each 'a',each ":each <"0 i.c
jd'close'


a=. 6!:1''
getdb_jd_''
cm=. (6!:1'')-a
echo (":cm),' time to map jd cols'

a=. 6!:1''
jd'close'
ucm=. (6!:1'')-a
echo (":ucm),' time to close jd cols'
)

0 : 0
Windows (RamMap)
 map     -> no ram
 access  -> ACTIVE ram
 unmap   -> STANDBY ram

 remap   -> no ram
 access  -> ACTIVE ram (STANDBY to ACTIVE)
 modify  -> ACTIVE ram
 unmap   -> MODIFIED (ACTIVE to MODIFIED)
 
 MODIFIED slowly pages out and becomes STANDY

 ACTIVE and little else -> page thrash
 ACTIVE+STANDY          -> effective paging
 
 unmap makes STANDBY and thereby reduces chance of THRASH
 
 s1 tmit 30e6 - total <5min
 s2 tmit 30e6 - total <17 min
 
)
 
pmx=: 3 : 0
pmx=: jpath'~temp/jd/pmx/'
fmx=: pmx,'a'
jddeletefolder_jd_ pmx
jdcreatefolder_jd_ pmx
jd'close'
unmapall_jmf_''
createjmf_jmf_ fmx;2000+8*200e6
map_jmf_ 'a';fmx

)




