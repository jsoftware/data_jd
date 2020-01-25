NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. mtm insert server routines

require'~Jddev/jd.ijs'

NB. RW task init - y is DB
winit=: 3 : 0
jdadmin 0
jdadmin y
d=. deb each<"1>2{"1{:jd'info schema'
'varbyte not allowed'assert -.(<'varbyte')e.d
'int2 not allowed'   assert -.(<'int2')e.d
'int4 not allowed'   assert -.(<'int4')e.d
'ref not allowed'    assert 0 0=>$each {.{:jd'info ref'
jd'info summary'
)

NB. RO task init - y is DB
rinit=: 3 : 0
jdadmin 0
jdadmin y;MTRO_jmf_
JDMTMRO_jd_=: 1 NB. mark as mtm ro task
jd'info summary' NB. critical that RO tasks has correct and stable locale info
)

NB. RD task runs this before read to handle insets
NB. WR task may have inserted rows in tables
NB. remap if fsize has changed
NB. set new tlen in table locale and mapped file headers
NB. care taken to avoid fsize race between WR and RO tasks
mtmfix_jd_=: 3 : 0
if. ''-:y do. return. end. 
't r'=. y

NB. remap cols that have changed filesize - does not touch header
a=. (fsize MAPFN_jmf_{"1 mappings_jmf_)~:>MAPFSIZE_jmf_{"1 mappings_jmf_
remap_jmf_ each a#MAPNAME_jmf_{"1 mappings_jmf_

NB. adjust table locale tlen and headers for mapped files
for_tab. conl 1  do.
 if. 0~:nc<'CLASS__tab' do. continue. end. 
 if. -.'jdtable'-:;CLASS__tab do. continue. end.
 i=. t i. <NAME__tab
 'info_summary table not found'assert i<#t
 s=. i{r
 if. Tlen__tab~:s do.
  NB. table has new rows - files have been remapped - adjust headers
  p=. PATH__tab
  b=. (<p)=(#p){.each 1{"1 mappings_jmf_
  b=. 6{"1 b#mappings_jmf_
  Tlen__tab=: s
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
  NB. table has new rows - mark derived cols dirty
  for_c. CHILDREN__tab do.
   setderiveddirty__c''
  end.
 end. 
end. 
)

NB. getloc calls to adjust RO header
NB. y is col locale
NB. MTM ro task has good Tlen from table locale that it should use
NB. mapping col file could have header with new rows from insert
NB.  need to adjust header
mtmfixcount_jd_=: 3 : 0
if. derived__y do. return. end.
p=. PATH__y,'dat' NB.! only does dat for now
i=. (1{"1 mappings_jmf_)i.<p
had=. >MAPHEADER_jmf_{i{mappings_jmf_
s=. Tlen__y
if. s=memr had,HADS_jmf_,1,JINT do. return. end. NB. it is OK
s memw had,HADS_jmf_,1,JINT             NB. {.$dat
c=. getHADR_jmf_ had
if. 2=c do.
 (s*memr had,(8+HADS_jmf_),1,JINT) memw had,HADN_jmf_,1,JINT
else.
 s memw had,HADN_jmf_,1,JINT
end.
)
