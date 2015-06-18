NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdthash'
coinsert 'jddhash1'

NB. A hash column stores a hash table for the referenced column(s).
NB. This forces lookups to use the hash.

typ =: 'hash'
STATE=: STATE_jddbase_ ,;:'len unique'
MAP =: ;:'hash link'
unique =: 0

NB. Define hash function
gethash =: [: to_unsigned_jd_ (LIBJD_jd_,' hash > x x') cd <@pointer_to

gethashlen=: 3 : 0
11>.4 p: +:#dat__active
NB. 4 p: +:getmsize_jmf_ 'dat_','_',~;active
NB. 4 p: +:getmsize_jmf_ 'dat_','_',~;active__PARENT
)

Insert=: 3 : 0
'ind dat'=.y
len insert ; boxopen&.> dat
len =: Tlen
writestate ''
)

NB. x is offset, y is the values passed to insert.
insert=: 4 : 0
inmem=. (-.IFWIN)*.(HASHPASSLEN>:#hash)*.10000<{.;#each y
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
end. 

if. unique do.
 actP=. getloc__PARENT'jdactive'
 actP=. pointer_to_name__actP'dat'
else.
 actP=. 0
end.

LIB =. LIBJD , ' hash_insert'
if. HASHCREATE32BIT *. 0=off do. LIB =. LIB,'_h' end.
getlib =. LIB,[,' > x x x x x ',],' x x x'"_
maxcoll =. (+ 6000 >. >.@%&10) #hash
ncollP =. pointer_to ncoll =. -~2
arg =. (off;hashP;linkP;<actP) , ,&(HASHPASSLEN;ncollP;<maxcoll)

if. *./ 0=t do. NB. fixed width column special code
  if. 1=#t do. NB. single fixed-width column special code
    r =. ('_fixed1' getlib 'x x') cd arg {.&.>col;<ins
  else.
    r =. ('_fixed' getlib 'x *x *x') cd arg l;col;<ins
  end.
else.
  r =. ('' getlib 'x *x *x *x *x') cd arg l;t;ind;col;<ins
end.
if. r do. assert 0 end. NB. TODO handle error codes

if. inmem do.
 hash=: hashx
end. 

EMPTY
)

hashit1=: 3 : 0
hlen=. 11>.4 p: +:y
hashfn=. jpath'~temp/hash.jmf'
linkfn=. jpath'~temp/link.jmf'
jdcreatejmf hashfn;DATASIZE_jdtint_*hlen
jdcreatejmf linkfn;DATASIZE_jdtint_*y
d__=: i.y
dp=. pointer_to_name_jd_ 'd__'
lib=: LIBJD_jd_,' hashit1 > x *c *c x x x'
r =. lib cd hashfn;linkfn;hlen;0;dp
map_jmf_ 'hash__';hashfn
map_jmf_ 'link__';linkfn
EMPTY
)

NB. Resize hash column
NB. Assumes link is properly allocated
NB. In fact, we can ignore link as insert will overwrite it.
resize=: 3 : 0
resizemap 'hash' ; 8*gethashlen''
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

NB. =========================================================
ref_insert =: 3 : 0
'ins cols'=.y
len =. # 0{:: 0{:: ins

outP =. pointer_to out=.len$2  NB. out must be integer-typed
hashP =. pointer_to_name 'hash'
l =. #cols
t =. 3|>: (;:'varbyte enum') i. 3 : '<typ__y'"0 cols
ind =. +/\ 0,}:t{1 2 2
col =. pointer_to_name@>  ; 3 :'ExportMap__y $0'&.> <"0 COLS
ins =. pointer_to@> ; ins

lib =. LIBJD,' ref_insert > n x x x *x *x *x *x'
lib cd outP;hashP;l;t;ind;col;<ins
out
)
