NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass 'jddhash1'
coinsert 'jddbase'

opentyp=: 3 : 0
COLS=: Open__PARENT"0 >{:{. subscriptions
if. 1=#COLS do.
  COL=: {.COLS
  qequal__COL=: ('lookup',Cloc)~
  qin__COL=: 3 :'> qor&.>/ <@qequal"_1 y'
  select=: select__COL
else.
  select=: 3 :'(4 : ''select__x y'')&y(<@)"0 COLS'
end.
MAPCOL=: ; 3 :'ExportMap__y $0'&.> <"0 COLS
if. _1=nc<'option_nc_jd_' do. option_nc_jd_=: 0 end.
nubcount=: option_nc
writestate'' NB.! do it early - so it is there in case of errors
)

dynamicinit=: 3 : 0
assert. 1 = #subscriptions
assert. NAME__PARENT -: >{.{.subscriptions
len =: Tlen
opentyp ''
t =. -. +./ ( 3 : '<typ__y'"0 COLS)e.;:'varbyte enum'

if. HASHFAST *. t do.
 hashH''
 return.
end. 

jdcreatejmf (PATH,'hash');DATASIZE_jdtint_ * gethashlen''
jdmap ('hash',Cloc);PATH,'hash'
if. -.unique do.
  ('int';$0) makecolfile 'link'
end.
dynamicresetx''
)

dynamicresetx=: 3 : 0
'hashx'logtxt''
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

NB. hash with intermediate ui32
hashH=: 3 : 0
hlen=. gethashlen''
hashfn=. PATH,'hash'
jdcreatejmf hashfn;DATASIZE_jdtint_*hlen

if. unique do.
 linkfn=. ''
else.
 linkfn=. PATH,'link'
 jdcreatejmf linkfn;DATASIZE_jdtint_*Tlen
end. 

dp=. ;pointer_to_name_jd_ each MAPCOL

if. unique do.
 actp=. pointer_to_name__active__PARENT'dat'
else.
 actp=. 0
end.

maxcoll=. <.2^60 NB. avoid unhandled error and following looks suspicious: (+ 6000 >. >.@%&10) hlen

if. 0=nc<'HLIMIT__' do. 
 maxcoll=. >.hlen%2 NB. ??????
end. 
ncollP=. pointer_to ncoll =. -~2

lib=: LIBJD_jd_,' hashit > x *c *c x x x *x x x'
r=. lib cd hashfn;linkfn;hlen;actp;(#MAPCOL);(,dp);ncollP;<maxcoll
assert r=0 NB. overfilled
map_jmf_ ('hash',Cloc);hashfn
if. -.unique do.
 map_jmf_ ('link',Cloc);linkfn
end.
EMPTY
)

NB. never called!
dynamicreset=: 3 : 0
'never called!!!!!!!!!!!!!'assert 0
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
