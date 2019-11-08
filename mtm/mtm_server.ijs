NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. mtm insert server routines

require'~Jddev/jd.ijs'

NB. RW task init - y is DB
winit=: 3 : 0
jdadmin 0
jdadmin y
'varbyte not allowed'assert -.(<'varbyte')e.deb each<"1>2{"1{:jd'info schema'
'ref not allowed'    assert 0 0=>$each {.{:jd'info ref'
jd'info summary'
)

NB. RO task init - y is DB
rinit=: 3 : 0
jdadmin 0
jdadmin y;MTRO_jmf_
jd'info summary'
)

NB. WR task may have inserted rows in tables
NB. remap if fsize has changed
NB. set new tlen in table locale and mapped file headers
NB. care taken to avoid fsize race between WR and RO tasks
mtmfix=: 3 : 0
if. ''-:y do. return. end. 
't r'=. {:y
t=. deb each<"1 t
r=. ,r

NB. remap cols that have changed filesize
a=. (fsize MAPFN_jmf_{"1 mappings_jmf_)=>MAPFSIZE_jmf_{"1 mappings_jmf_
remap_jmf_ each a#MAPNAME_jmf_{"1 mappings_jmf_

NB. adjust table locale tlen and headers for mapped files
for_n. conl 1  do.
 if. 0~:nc<'CLASS__n' do. continue. end. 
 if. -.'jdtable'-:;CLASS__n do. continue. end.
 i=. t i. <NAME__n
 'info_summary table not found'assert i<#t
 s=. i{r
 if. Tlen__n~:s do.
  p=. PATH__n
  b=. (<p)=(#p){.each 1{"1 mappings_jmf_
  b=. 6{"1 b#mappings_jmf_
  Tlen__n=: s
  for_n. b do. NB. set new */$dat and #dat
   n=. ;n
   s memw n,HADS_jmf_,1,JINT             NB. {.$dat
   c=. getHADR_jmf_ n
   if. 2=c do.
    (s*memr n,(8+HADS_jmf_),1,JINT) memw n,HADN_jmf_,1,JINT
   else.
    s memw n,HADN_jmf_,1,JINT
   end.
  end. 
 end. 
end. 
)
