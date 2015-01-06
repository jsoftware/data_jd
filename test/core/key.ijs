NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that foreign keys work with all datatypes.

f =: Open_jd_ jpath '~temp/jd'
d =: (Create__f [ Drop__f) 'btest'

NAMES =: ;:'bo in fl by en vb da dt ti'

fmt =: 'id ',],',data ',]
C=:empty@:Create__d
C 'bo';(fmt 'boolean');<0 1;1 0
C 'in';(fmt 'int');<(i.8);(8?.@$1e5)
C 'fl';(fmt 'float');<(0.5+i.6);(1e5*6?.@$0)
C 'by';(fmt 'byte');<(a.{~97+i.12);(a.{~12?.@$128)
C 'en';(fmt 'enum');<(a.{~97+i.12);(a.{~12?.@$128)
C 'vb';(fmt 'varbyte');<(":&.>i.16);<((#i.@#) </. a.{~128?.@$~+/) (16?.@$10)
C 'da';(fmt 'date');<(20120601+i.10);(10 3?.@$12)
C 'dt';(fmt 'datetime');<(20120627010000+1e5*i.4);(1e13+4?.@$9e13)
C 'ti';(fmt 'time');<(010000+100*i.18);({.@":"0 ] 18 6?.@$10)

refCols =: ; (LF,~],' ',])&.> TYPES_CORE
indices =: 64 ?.@$"0 ]2 8 6 12 12 16 10 4 18
keys =: (1{::[:{. Read__d@:('id from '&,))&.> NAMES
refKeys =: (<"_1 indices) {&.> keys
ref =: Create__d 'ref';refCols;<refKeys

vals =: (1{::[:{. Read__d@:('data from '&,))&.> NAMES
refVals =: (<"_1 indices) {&.> vals

assertfailure;._2 ](0 :0)
('in';<,<'id') MakeRef__ref ;:'float'
)

3 : 0''
for_n. NAMES do.
  (n,<,<'id') MakeRef__ref ,n_index{TYPES_CORE
end.
EMPTY
)

query =: (}:; ,&'.data,'&.> NAMES) ,' from ref', (; ',ref.'&,&.> NAMES)
'columns data' =: ({."1 ,&< {:"1) Read__d query
columns -: ,&'.data'&.> NAMES
1 4 8 2 2 32 4 4 4 -: 3!:0@> data
refVals -: data

vals =: (1{::[:{. Read__d@:('data from '&,))&.> NAMES
((<"_1 indices) {&.> vals) -: data


NB. test insertion (to referencing table)
NB. =========================================================

empty Insert__d 'ref';< TYPES_CORE,.|.&.> refKeys
indices=: indices ,. |."1 indices
vals =: (1{::[:{. Read__d@:('data from '&,))&.> NAMES
refVals =: (<"_1 indices) {&.> vals

'columns data' =: ({."1 ,&< {:"1) Read__d query
refVals -: data


NB. test insertion (to referenced table)
NB. =========================================================
new=. 0;8;6.5;'m';'m';(<'16');20120611;20120627410000;11800
-.}.new e.&> refKeys
empty Insert__d 'ref';< TYPES_CORE,. ,:&.> new
empty Insert__d"1 }. NAMES ,. ('id';'data') <@,."_ _1 ,:&.> new

'columns data' =: ({."1 ,&< {:"1) Read__d query
(refVals,&.>new) -:&}. data


NB. test restore from filesystem
NB. =========================================================

d =: Open__f 'btest' [ BadClose__f d
d =: Open__f 'btest' [ Close__f d
