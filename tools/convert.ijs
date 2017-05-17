NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

0 : 0
convert jd3 db to jd4
   dryrun '~temp/jd/test' NB. dry run this db and report details
   dryrun '~temp/jd'      NB. dry run all jd3 dbs in folder
   
DO NOT conrun UNTIL dryrun HAS IS CLEAN!   

   conrun '~temp/jd/test' NB. convert this db in place and report details
   conrun '~temp/jd     ' NB. convert all jd3 dbs in folder
   
   getjd3 '~temp/jd'     NB. jd3 dbs in folder
   
conversion summary:
 jdactive col dropped and deleted rows compressed out
 jd... cols (ref/reference/hash/...) dropped
 cols with type time or enum dropped
 jd'ref ...' done for jdref and jdreference cols

dryrun failure leaves db untouched 
convert failure probably leaves db damaged - neither jd3 nor jd4 compatible
)

dryrun=: 0&convert_jd_
conrun=: 1&convert_jd_ 
getjd3=: getjd3_jd_

coclass'jd'

convert=: 3 : 0
1 convert y
:
if. 'database'-:fread y,'/jdclass' do.
 'not a jd3 db'assert -.fexist y,'/jdversion'
 y=. boxopen y
 vecho=: echo
else.
 y=. getjd3 y
 if. 0=#y do. echo'nothing to do' return. end.
 vecho=: [
end.
for_n. y do.
 n=. ;n
 try.
  echo n
  x convertsub n
 catchd.
  echo 13!:12''
  echo n,' *********************** failed'
  jdforce_clean''
 end.
end.
i.0 0
)
 
NB. x is 1 to do it, otherwise it is a dry run reporting what it would do
convertsub=: 3 : 0
0 convert y
:
doit=. x=1
jdadmin 0
p=. adminp y
dan=. (>:p i: '/')}.p
fv=. p,'/jdversion'
v=. fread fv
'not a jd3 db'assert _1=v
jdversion fwrite fv NB. jam as current version long enough to open
jdadmin y
ferase fv NB. back to jd3 until conversion is done
db=. getdb_jd_''
refs=. ''
path=. dbpath dan
for_tn. NAMES__db do.
 tablename=. ;tn
 t=. getloc__db tn
 ns=. NAMES__t
 cs=. CHILDREN__t
 vecho tablename,' -',;' ',each ns
 a=. getloc__t'jdactive'
 active=. forcecopy dat__a
 dflag=. -.*./active
 if. dflag do. vecho ' rows to delete',~' ',":+/-.active end.
 
 for_i. i.#ns do.
  n=. ;i{ns
  loc=. i{cs
  f=. path,'/',tablename,'/',n
  if. 'jdindex'-:n do. continue. end.

  if. 'jdactive'-:n do.
   vecho ' drop: ',n  
   if. doit do. jddeletefolder f [ close__loc'' end.
   continue.
  end. 

  NB. not that ref cols are deleted and then recreated at end
  if. ('jd')-:2{.n do.
    if. 'jdref'-:5{.n do. refs=. refs,<tablename,(n i. '_')}.n end.
    MAP__loc=: '' NB. decommitted cols have no MAP - need for close
    vecho ' drop: ',n
    if. doit do.
     close__loc
     jddeletefolder f
    end.
    continue.
  end.
  
  NB. some col types are no longer supported - drop them
  if. (<typ__loc) e. ;:'time enum' do.
   MAP__loc=: '' NB. decommitted cols have no MAP - need for close
   vecho' drop: ',n,' ',typ__loc
   if. doit do.
     close__loc
     jddeletefolder f
   end.
   continue.
  end. 
  
  vecho' ',n
  if. doit*.dflag do.
   loc=. getloc__t n NB. getloc so mapping is done
   dat__loc=: active#dat__loc
  end.
 
 end.
 
 if. doit do.
  NB. table state must have empty SUBSCR and correct Tlen
  SUBSCR__t=: SUBSCR=: 0 3$a:
  Tlen__t=: +/active
  writestate__t''
 end.
 
end.
jdadmin 0

vecho LF
if. doit do.
 jdversion fwrite fv
 jdadmin y
 for_r. refs do.
  r=. ;r
  r=. ;' ',each <;._1'_',r
  d=. ''
  try. jd 'ref',r  catch. d=. ' * failed' end.
  vecho ' ref',r,d
 end.
else.
 for_r. refs do.
  r=. ;r
  r=. ;' ',each <;._1'_',r
  vecho ' ref',r
 end.
end.
jdadmin 0
i.0 0
)

NB. get dbs in folder y
getjd3=: 3 : 0
r=. 1 1 dir y
r=. r#~;(<'database')=fread each r,each<'jdclass' NB. remove non database folders
r=. }:each r#~-.fexist r,each<'jdversion'                NB. remove jd4 dbs
)
