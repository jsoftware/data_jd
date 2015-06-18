NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass 'jddhash1'
coinsert 'jddbase'

opentyp =: 3 : 0
COLS =: Open__PARENT"0 >{:{. subscriptions
if. 1=#COLS do.
  COL=: {.COLS
  qequal__COL=: ('lookup',Cloc)~
  qin__COL=: 3 :'> qor&.>/ <@qequal"_1 y'
  select =: select__COL
else.
  select =: 3 :'(4 : ''select__x y'')&y(<@)"0 COLS'
end.
MAPCOL =: ; 3 :'ExportMap__y $0'&.> <"0 COLS
)

dynamicinit =: 3 : 0
assert. 1 = #subscriptions
assert. NAME__PARENT -: >{.{.subscriptions
len =: Tlen
opentyp ''
jdcreatejmf (PATH,'hash');DATASIZE_jdtint_ * gethashlen''
jdmap ('hash',Cloc);PATH,'hash'
if. -.unique do.
  ('int';$0) makecolfile 'link'
end.
dynamicreset''
)

dynamicreset =: 3 : 0
'dynamicreset hash'trace''
len =: Tlen
writestate'' NB.! avoid unique bug - clean up when readstate/writestate cleanedup

t=. 8*gethashlen''
if. t>getmsize_jmf_ 'hash',Cloc do.
 resizemap 'hash';t
end.
hash=: _1 $~ gethashlen ''

if. -.unique do.
 t=. 8*getmsize_jmf_ 'dat_','_',~;active__PARENT
 if. t>getmsize_jmf_ 'link',Cloc do.
  resizemap 'link';t
 end.
 link=: Tlen$_1
end. 

0 insert ".&.> MAPCOL
writestate''
)

NB. analogous to I.@:=
lookup=: 3 : 0
|. }: {&link^:(>&_1)^:a: index y
)

ref_update_ind =: 3 : 0
'off ref ind' =. y
indP =. pointer_to ind
refP =. pointer_to ref
linkP =. pointer_to_name`0:@.unique 'link'
lib =. LIBJD,' ref_update_ind > n x x x x x'
lib cd off;(#ind);indP;refP;<linkP
)
