NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

0 : 0
convert jd3 db to jd4
   dryrun '~temp/jd/test' NB. dry run this db and report details
   
DO NOT conrun UNTIL dryrun runs clean!   

   conrun '~temp/jd/test' NB. convert this db in place and report details
   
conversion summary:
 jdactive col dropped and deleted rows compressed out
 jd... cols (ref/reference/hash/...) dropped
 cols with type time or enum dropped
 jd'ref ...' done for jdref and jdreference cols

dryrun failure leaves db untouched 
convert failure probably leaves db damaged - neither jd3 nor jd4 compatible

For access to a Jd3 db, use jdadminjd3 with caution:
   jdadminjd3_jd_ '~temp/jd/test'
   jd'info validatebad'
)

dryrun=: 0&convert_jd_
conrun=: 1&convert_jd_ 
getjd3=: getjd3_jd_

coclass'jd'

vecho=: echo

jdadminjd3=: 3 : 0
jdadmin 0
p=. adminp y
fv=. p,'/jdversion'
v=. fread fv
'not a jd3 db'assert _1=v
'mark as damaged until conversion complete'fwrite p,'/jddamage' NB. damaged and
'repair'fwrite p,'/jdrepair'                                    NB. under repair    
jdversion fwrite fv NB. jam as current version long enough to open
jdadmin y
ferase fv NB. back to jd3 until conversion is done
i.0 0
)

convert=: 3 : 0
1 convert y
:
'not a database' assert 'database'-:fread y,'/jdclass'
'not a jd3 db'   assert -.fexist y,'/jdversion'
n=. y
try.
 x convertsub n
catchd.
 echo 13!:12''
 echo n,' *********************** failed'
 jdforce_clean''
end.
i.0 0
)
 
NB. x is 1 to do it, otherwise it is a dry run reporting what it would do
convertsub=: 3 : 0
0 convert y
:
doit=. x=1
jdadminjd3 y
dbpath=. dbpath DB
if. doit do. repair'' end. 
db=. getdb_jd_''
refs=. ''
for_tn. NAMES__db do.
 tablename=. ;tn
 t=. getloc__db tn
 ns=. NAMES__t
 cs=. CHILDREN__t
 count=. Tlen__t
 a=. getloc__t'jdactive'
 active=. forcecopy dat__a
 if. count~:#active do.
  vecho ' will repair count - jdactive'
  active=. count{.active
 end. 
 
 dflag=. -.*./active
 vecho tablename,' TLen A - deleted B'rplc 'A';(":count);'B';":+/-.active
 for_i. i.#ns do.
  n=. ;i{ns
  loc=. i{cs
  f=. dbpath,'/',tablename,'/',n
  if. 'jdindex'-:n do. continue. end.

  if. 'jdactive'-:n do.
   if. doit do.
    jddeletefolder f [ close__loc''
   else.
    vecho ' will drop: ',n  
   end.
   continue.
  end. 

  NB. ref cols are deleted and then recreated at end
  if. ('jd')-:2{.n do.
    if. 'jdref'-:5{.n do. refs=. refs,<tablename,(n i. '_')}.n end.
    MAP__loc=: '' NB. decommitted cols have no MAP - need for close
    if. doit do.
     close__loc
     jddeletefolder f
    else.
     vecho ' will drop: ',n
    end. 
    continue.
  end.

  NB. some col types are no longer supported - drop them
  if. (<typ__loc) e. ;:'time enum' do.
   MAP__loc=: '' NB. decommitted cols have no MAP - need for close
   if. doit do.
     close__loc
     jddeletefolder f
   else.
    vecho' will drop: ',n,' ',typ__loc
   end.
   continue.
  end. 
  
  loc=. getloc__t n NB. getloc so mapping is done
  
  if. count~:#dat__loc do.
   vecho ' will repair count - ',n
  end.
  if. doit*.dflag do.
   if. count~:#dat__loc do. dat__loc=: count{.dat__loc end.
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
 jdversion fwrite dbpath,'/jdversion'
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
vecho 'finished ',(;doit{'dryrun';'conrun'),' - ',tablename
i.0 0
)

NB. get dbs in folder y
getjd3=: 3 : 0
r=. 1 1 dir y
r=. r#~;(<'database')=fread each r,each<'jdclass' NB. remove non database folders
r=. }:each r#~-.fexist r,each<'jdversion'                NB. remove jd4 dbs
)
