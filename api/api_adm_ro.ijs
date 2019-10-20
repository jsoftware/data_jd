NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. admin existing db for RO - only single db allowed
jdadminro=: 3 : 0
 y=. adminp y
 'not a folder'assert 2=ftype y
 'not a database'assert 'database'-:jdfread y,'/jdclass'
 v=. fread y,'/jdversion'
 v=. (-.v-:_1){3,<.0".":v
 'db version not compatible with this Jd version'assert v=<.".jdversion

 t=. jdadminlk''
 i=. t i.'[r]';jpath y
 if. i<#t do. NB. admin already done - just do access to first dan for the db
  i=. (jpath each {:"1 DBPATHS)i.<jpath y
  jdaccess (;{.i{DBPATHS_jd_),' ',(;{:i{DBUPS_jd_),' intask'
  i.0 0
  return.
 end. 

 'RO db can be made active only if no other active dbs'assert 0=#DBPATHS
 'r'jdadminlk y

 NB. remove old admin for this folder
 dan=. (;(<jpath y)=jpath each {:"1 DBPATHS)#{."1 DBPATHS
 DBPATHS=: (-.({."1 DBPATHS)e.dan)#DBPATHS
 DBUPS=: (-.({."1 DBUPS)e.dan)#DBUPS
 DBOPS=: (-.({."1 DBOPS)e.dan)#DBOPS
 
 bak=. (<DBPATHS),(<DBUPS),<DBOPS
 c=. #DBPATHS
 adminfp=: y
 fp=. y,'/admin.ijs'
 if. -.fexist fp do.
  (defaultadmin rplc 'D';d)fwrite fp NB. create default admin.ijs
 end.
 try.
   load y,'/admin.ijs'
 catch.
   'DBPATHS DBUPS DBOPS'=: bak
   'x'jdadminlk y
   'load admin.ijs failed'assert 0
 end.
 NB. default access is for the 1st of the new dans
 jdaccess (;{.c{DBPATHS_jd_),' ',(;{:c{DBUPS_jd_),' intask'
 getdb'' NB. set dbl
 RO=: 1
 jd_info'validate' NB. all locales open
 ROfsize=: fsize 1{"1 mappings_jmf_ NB. fsize for all mapped files
 ROtloc=: ''
 tabs=. deb each,<"1>{:jd'info table'
 for_t. tabs do.
  ROtloc=: ROtloc,jdgl_jd_ t
 end.
 i.0 0
)


NB. RO db header adjustments for new table tlens
xxxjdadmintlen=: 3 : 0
rows=. 0".y
for_i. i.#ROtloc do.
 t=. i{ROtloc
 r=. ;i{rows
 echo 'check: ',NAME__t,' ',":r
 m=. mappings_jmf_
 if. r~:Tlen__t do.
  p=. PATH__t
  b=. (<p)=(#p){.each 1{"1 m
  b=. 6{"1 b#m
  Tlen__t=: r
  for_n. b do. NB. set new */$dat and #dat
   n=. ;n
   r memw n,56,1,JINT             NB. {.$dat
   c=. getHADR_jmf_ n
   if. 2=c do.
    (r*memr n,64,1,JINT) memw n,40,1,JINT
   else.
    r memw n,40,1,JINT
   end. 
  end.
 end. 
end.
i.0 0
)


NB. WR task has inserted rows in tables
NB. remap if fsize has changed
NB. set new tlen in table locale and mapped file headers
NB. care taken to avoid fsize race between WR and RO tasks
jdadmintlen=: 3 : 0
rows=. 0".y

for_i. i.#ROfsize do.
 'name fn'=. 2{.i{mappings_jmf_
 s=. fsize fn
 if. s~:i{ROfsize do.
  echo 'remap: ',name
  remap_jmf_ name
  NB. don't set HADM - it is not used (RO) and there is a race in setting it properly
  ROfsize=: s i}ROfsize
 end. 
end.

NB. adjust tlen
for_i. i.#ROtloc do.
 t=. i{ROtloc
 r=. ;i{rows
 echo 'check: ',NAME__t,' ',":r
 m=. mappings_jmf_
 if. r~:Tlen__t do.
  echo 'adjust: ',NAME__t
  p=. PATH__t
  b=. (<p)=(#p){.each 1{"1 m
  b=. 6{"1 b#m
  Tlen__t=: r
  for_n. b do. NB. set new */$dat and #dat
   n=. ;n
   r memw n,HADS_jmf_,1,JINT             NB. {.$dat
   c=. getHADR_jmf_ n
   if. 2=c do.
    (r*memr n,(8+HADS_jmf_),1,JINT) memw n,HADN_jmf_,1,JINT
   else.
    r memw n,HADN_jmf_,1,JINT
   end. 
  end.
 end. 
end.
i.0 0
)