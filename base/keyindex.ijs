NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. should be called through jd'key ...' so FIXPAIRSFLAG is set
NB. type keyindex 'f';'p';2015 2016;'val';6 16
NB. type is 1 for last and 0 for in
NB. type keyindex table;pairs...
keyindex=: 3 : 0
1 keyindex y
:
tab=. ,;{.y
FETAB=: tab
a=. }.y
nsvs=. (2,~-:#a)$a
if. isptable tab do.
 x kiptable (<tab),<nsvs
else. 
 x keyindexsub (<tab),<nsvs
end. 
)

NB. tab keyindexsub ns,.vs - tab can be a ptable
keyindexsub=: 4 : 0
'tab nsvs'=. y
ns=. {."1 nsvs
vs=. {:"1 nsvs
try. t=. jdgl tab catch. _1$~#>{.vs return. end. NB. part doesn't exist
if. 1=#ns do.
 ksrc=. ;(0{ns i. ns){vs
 c=. jdgl tab;ns
 ksnk=. dat__c
else.
 ksrc=. stitchx__t (ns i.ns){vs
 ksnk=. stitch__t tab;<ns
end.
if. x do.
 r=. ,ksnk i. ksrc NB. first not last
 _1 ((r=#ksnk)#i.#r)}r
else.
 if. 1=$$ksrc do.
  (+./"1 ksnk =/ ksrc)#i.#ksnk
 else.
  (+./"1 ksnk -:"1/ ksrc)#i.#ksnk
 end. 
end.
)

NB. keyindex for ptable
NB. tab kiptable ns,.vs
kiptable=: 4 : 0
'tab nsvs'=: y
ns=. {."1 nsvs
vs=. {:"1 nsvs
t=. jdgl tab,PTM
pcol=. getpcol__t''
'key must have ptable pcol' assert (<pcol)e.ns
c=. CHILDREN__t {~ NAMES__t i. <pcol
i=. ({."1 nsvs)i.<pcol
parts=. ;{:i{nsvs NB. pcol vals are ints (int, edate, edatetime)
parts=. typ__c pcol_ffromv parts NB.edate to int
nub=. ~.parts

if. x do.
 r=. (#>{:{:nsvs)$_1
else.
 r=. ''
end. 
 
'ps lens'=. getparts (tab i. PTM){.tab
b=. ns~:<pcol
ns=. b#ns
vs=. b#vs
y=. ns,.vs NB. removed pcol from data 
if. 1=#nub do.
  a=. x keyindexsub  (<tab,PTM,dtb":;nub),<nsvs
  q=. ps i. <":nub NB. part can be numeric or literal
  r=. a++/q{.lens
  r=. _1 ((a=_1)#i.#a)}r
else.
 for_part. nub do.
  NB. part type
  if. 2=3!:0 part do.
   i=. <I.part-:"1 parts
  else.
   i=. <I.part=parts
  end.
  d=. i{each{:"1 nsvs
  d=. ({."1 nsvs),.d
  a=.  x keyindexsub (<tab,PTM,dtb":;part),<d
  q=. ps i. <":part NB. part can be numeric or literal
  b=. a++/q{.lens
  if. x do.
   b=. _1 ((a=_1)#i.#a)}b
   r=. b (;i)}r
  else.
   r=. r,b
  end. 
 end.
end. 
r
)
