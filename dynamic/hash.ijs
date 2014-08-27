NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdthash'
coinsert 'jddbase'

NB. A hash column stores a hash table for the referenced column(s).
NB. This forces lookups to use the hash.

typ =: 'hash'
STATE=: STATE_jddbase_ , <'len'
MAP =: ;:'hash link'
unique =: 0

NB. Define hash function
gethash =: [: to_unsigned_jd_ (LIBJD_jd_,' hash > x x') cd <@pointer_to

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

gethashlen =: 3 : '4 p: +:2>.Tlen' NB. A prime before +:Tlen
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

NB.!
try.
 hash=: _1 $~ gethashlen ''
catch.
 resizemap 'hash' ; DATASIZE_jdtint_ * 11 >. gethashlen''
 hash=: _1 $~ gethashlen ''
end.

if. -.unique do.

 NB.!
 try.
  link=: Tlen$_1
 catch.
  resizemap 'link';Padvar*DATASIZE_jdtint_ * 4>.Tlen
  link=: Tlen$_1
 end.
 
end.

0 insert ".&.> MAPCOL
writestate''
)

Insert=: 3 : 0
'ind dat'=.y
len insert ; boxopen&.> dat
len =: Tlen
writestate ''
)

NB. hash/link thrash problems
NB. original version created hash and link directly in mapped noun
NB. linux - random updates to mapped files created lots of dirty pages
NB. which would be written out only to be made dirty again
NB. this created page thrash
NB. solution with dirty_ration dirty_writeback_centisecs etc worked well
NB. but had serious problems with how to manage in a shared environment
NB. solution - copy mapped hash/link to unmapped, update, then copy back
NB. linux treats swap differently and thrash is avoided

NB. trash is a problem on linux if there are lots of inserts
NB. doing it in-memory for a few inserts causes lots of unnecessary writes
NB. see use of inmem

NB. windows doesn't need this and it works directly with the mapped nouns

NB. x is offset, y is the values passed to insert.
insert=: 4 : 0
inmem=. (-.IFWIN)*.10000<{.;#each y
if. -.unique do.
  NB. Needs to be two lines or jmf throws 'file already mapped'
  len=.Tlen -# link
  'link' appendmap _1$~len
end.
if. (#hash)<1.5*Tlen do. resize '' return. end.

off =. x
hashP =. pointer_to_name 'hash'
linkP =. pointer_to_name`0:@.unique 'link'
l =. #COLS
t =. 3|>: (;:'varbyte enum') i. 3 : '<typ__y'"0 COLS
ind =. +/\ 0,}:t{1 2 2
col =. pointer_to_name@> MAPCOL
ins =. pointer_to@> y

if. inmem do.
 hashx=. a:{hash
 hashP=. pointer_to_name 'hashx'
 if. -.unique do.
  linkx=. a:{link
  linkP=. pointer_to_name 'linkx'
 end.
end. 

if. unique do.
 actP=. getloc__PARENT'jdactive'
 actP=. pointer_to_name__actP'dat'
else.
 actP=. 0
end.

if. *./ 0=t do. NB. fixed width column special code
  if. 1=#t do. NB. single fixed-width column special code
    lib =. LIBJD,' hash_insert_fixed1 > x x x x x x x'
    r =. lib cd off;hashP;linkP;actP; {.&.>col;<ins
  else.
    lib =. LIBJD,' hash_insert_fixed > x x x x x x *x *x'
    r =. lib cd off;hashP;linkP;actP;l;col;<ins
  end.
else.
  lib =. LIBJD,' hash_insert > x x x x x *x *x *x *x'
  r =. lib cd off;hashP;linkP;l;t;ind;col;<ins
end.
if. -.r do. assert 0 end. NB. createunigue failed - caught later 

if. inmem do.
 hash=: hashx
 if. -.unique do. link=: linkx end.
end. 

EMPTY
)

NB. Resize hash column
NB. Assumes link is properly allocated
NB. In fact, we can ignore link as insert will overwrite it.
resize=: 3 : 0
NB. 11 >. prevents a mysterious bug that happens if the hash map is resized
NB. to size ten or less
resizemap 'hash' ; DATASIZE_jdtint_ * 11 >. gethashlen''

hash =: _1 $~ gethashlen ''
0 insert ".&.> MAPCOL
)

RevertXXX=: 3 : 0
if. y>:#link do. return. end.
off=.0
for_h. hash do.
  h =. {&link^:(>:&y) ht=.h
  off =. (_1<ht) * off + _1=h
  if. off *. _1<h do.
    off =. h_index  -  (#hash) | combinedhash select h
  end.
  if. off *. _1<h do. hash =: (h,_1) (i,h_index)} hash
  elseif. h~:ht do. hash =: h h_index} hash
  end.
end.
link =: y{.link
)


combinedhash =: [: (22 b. 3 MAX_INT_jd_&|@* ])/@:|. gethash@>@:boxopen
NB. y is an item.
NB. analogous to i:
index=: 3 : 0
nh =. #hash
if. 0=nh do. _1 return. end.
i =. nh | combinedhash y
while. (_1<ii=.i{hash) do.
  if. y -: select ii do. ii return. end.
  i=.0:^:(nh&=) >:i
end.
_1
)
NB. analogous to I.@:=
lookup=: 3 : 0
  |. }: {&link^:(>&_1)^:a: index y
)
