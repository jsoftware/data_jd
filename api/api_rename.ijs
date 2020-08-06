NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. should be reworked to not use jd_close
jd_renametable=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
assertnoref ;{.a

ns=. getparttables ;{.a
for_i. i.#ns do.
 tab=. i{ns
 t=. jdgl tab
 old=. }:PATH__t
 part=. (old i: PTM)}.old
 new=. ((->:#NAME__t)}.PATH__t),(;{:a),part
 jd_close''
 new frename old
 getdb'' NB. required because of close
end.
JDOK
)

NB. should be reworked to not use jd_close
NB. cco is not adjusted - confusing - new is at end unless already there
jd_renamecol=: 3 : 0
a=. bdnames y
ECOUNT assert 3=#a
t=. jdgl {.a
'col not found'      assert   (1{a)e.NAMES__t
'col already exists' assert -.(2{a)e.NAMES__t
notjd_assert }.a
vcname ;2{a
assertnodynamic 2{.a
ns=. getparttables ;{.a
for_i. i.#ns do.
 if. i=1 do. continue. end. NB. ignore f~
 t=. jdgl (i{ns),1{a
 
 oldname=. <NAME__t
 newname=. {:a
 
 new=. (('/'i:~}:PATH__t){.PATH__t),'/',dfromn;{:a
 old=. }:PATH__t
 jd_close''
 'file rename failed' assert 1=new frename old
 getdb'' NB. required because of close
 
 NB. preserve cco - note each ptable has its own cco
 t=. jdgl i{ns
 cco=. <;._2 cco_read__t''
 i=. cco i. oldname
 if. i<#cco do.
  cco=. newname i}cco
 else.
  cco=. cco,newname
 end.
 cco_write__t ;cco,each LF
 
end.
JDOK
)
