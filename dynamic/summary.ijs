NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdtsummaryset'
coinsert 'jddbase'

visible=: 0

typ=: 'summaryset'
MAP=: 0$a:
STATE=: STATE_jddbase_,;:'query UPDATED AUTOUPDATE ADOPTEDNAMES'
query=: ''
typs=: ''
UPDATED=: 0
AUTOUPDATE=: 1

opentyp=: ]

NB. shape is query locale;query
makecolfiles =: 3 : 0
 qloc=. boxopen > {. shape
 'query typs'=: 2{. }. shape

 subscribe"1 ({."1 (~.@[,.<@~./.) {:"1) ACCESSED__qloc
 
 if. SUMMARYTABLE__PARENT *. '' -: SUMMARYMASTER__PARENT do. NB. If the parent is a summary table with no master summary column
  SUMMARYMASTER__PARENT =: NAME NB. this is the master summary column for the table
 end.

 if. 0=#typs do. 
  typs=: ('boolean';'byte';'int';'float';'varbyte') {~ 1 2 4 8 32 i. 3!:0&> read__qloc
  typs=: dtb&.> typs ([,' ',])&.> ":@}.@$&.> read__qloc
 end.
 nms=. cnms__qloc
 
 if. -. SUMMARYTABLE__PARENT *. NAME -: SUMMARYMASTER__PARENT do. NB. If this is not the master summary column
  assert. ((];NAME__PARENT,'.',])'jdindex') e.~ {. nms NB. make sure the first column is the index
  typs=: }. typs NB. drop it from typs
  nms =. }. nms  NB. drop it from nms
 end.

 ADOPTED=: InsertCol__PARENT@> nms ([,' ',])&.> typs	NB. they act as children but aren't; they're adopted
 ADOPTEDNAMES=: (3 :'<NAME__y')"0 ADOPTED				NB. names of the adopted columns
 (3 :'static__y=: 0')"0  ADOPTED						NB. adopted come from static types but aren't static
 NAME (4 :'ADOPTEDBY__y=: x')"_ 0  ADOPTED				NB. adopted must know their adopter
 (3 :'STATE__y=: ~.STATE__y,''static'';''ADOPTEDBY''')"0  ADOPTED	NB. adopted must remember their adopter
 (3 :'writestate__y ''''')"0  ADOPTED

 dynamicreset qloc
 writestate ''
)

select=: 3 : 'throw ''Cannot select summaryset column: '',NAME'

Insert=: 3 : 0
 UPDATED=: 0
 if. AUTOUPDATE do. dynamicreset'' end.
)

dynamicreset=: 3 : 0
 GRANDPARENT=: PARENT__PARENT
 if. y-:'' do. y=. newqueryloc__GRANDPARENT query end. NB. y is query locale or '' to create one
 assert. 1=#len=. ,/~. #@> read__y
 if. SUMMARYTABLE__PARENT *. NAME -: SUMMARYMASTER__PARENT do. NB. If this is the master summary column
  Tlen__PARENT =: len NB. make Tlen the right length
  MAP__active__PARENT replacemap__active__PARENT&> 1$<len#1 NB. make active the right length
  writestate__PARENT''
  idx=. i.len
  headisindex=. 0
 else. 
  idx=. >{.read__y
  headisindex=. 1
 end.
 for_j. }.^:headisindex i.#cnms__y do.
  loc=. getloc__PARENT   j{cnms__y
  idx modifyfilled__loc >j{read__y
 end.
 coerase y
 UPDATED=: 1
 writestate''
)
