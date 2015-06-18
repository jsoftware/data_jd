coclass 'jdtsmallrange'
coinsert 'jddhash1'
coinsert 'jdtindex'

typ =: 'smallrange'
STATE=: STATE_jddbase_ ,;:'len unique MIN MAX'
MAP =: ;:'hash link'
unique =: 0

gethashlen=: 3 : 0
MAX-MIN
)

Insert=: 3 : 0
'ind dat'=.y
len insert ; boxopen&.> dat
len =: Tlen
writestate ''
)

TestInsert =: 3 : 0
y =. |: ; |:@:,.&.> ; boxopen&.> 1{::y
assert. (len+#y)  >:  */ -~/ ((MIN<.<./) ,: MAX>.1+>./) y
)

NB. x is offset, y is the values passed to insert.
insert=: 4 : 0
y =. |: ; |:@:,.&.> y
mm =. ((MIN<.<./) ,: MAX>.1+>./) y
if. mm -.@-: MIN,:MAX do.
  oldmin =. MIN
  'MIN MAX' =: <"_1 mm
  oldmin resize ''
end.

y =. (MAX-MIN) #. y1 =. y -"1 MIN
NB. 'link' appendmap (hash {~ <"_1 ~.y1) (I.@~:y)} x + ]`(1|.])`]}~@:/: y
NB. hash =: (x+i.#y) (<"_1 y1)} hash
hashP =. pointer_to_name 'hash'
out =. (#y)$2
outP =. pointer_to out
lib =. LIBJD,' smallrange_insert > n x *x x x x'
lib cd (#y);y;x;hashP;<outP
'link' appendmap out

EMPTY
)

NB. Resize hash column
resize=: 4 : 0
resizemap 'hash' ; DATASIZE_jdtint_ * */hl =. gethashlen''
hash =: hl {.!._1 hash
if. -.x-:MIN do. hash =: (x-MIN) |. hash end.
)

NB. y is an item.
NB. analogous to i:
index=: 3 : 0
y =. ; ,&.> y
if. +./ (>:&MAX +. <&MIN) y do. _1 return. end.
(<y-MIN) { hash
)

dynamicinit =: 3 : 0
assert. 1 = #subscriptions
assert. NAME__PARENT -: >{.{.subscriptions
len =: Tlen
opentyp ''
NB. TODO assert columns are integral
jdcreatejmf (PATH,'hash');DATASIZE_jdtint_*10
jdmap ('hash',Cloc);PATH,'hash'
('int';$0) makecolfile 'link'
dynamicreset''
)

dynamicreset =: 3 : 0
'dynamicreset hash'trace''
len =: Tlen
writestate''

'MIN MAX' =: <"_1 |: ; (<./ ,.&, 1+>./)@".&.> MAPCOL
t=. DATASIZE_jdtint_ * */gethashlen''
if. t>getmsize_jmf_ 'hash',Cloc do.
  resizemap 'hash';t
end.
hash=: _1 $~ gethashlen ''

t=. DATASIZE_jdtint_*Tlen
if. t>getmsize_jmf_ 'link',Cloc do.
  resizemap 'link';t
end.
link=: $0

0 insert ".&.> MAPCOL
writestate''
)

NB. =========================================================
ref_insert =: 3 : 0
'ins cols'=.y
ins =. |: ; |:@:,.&.> ; ins
((MAX-MIN) #. ins -"1 MIN) ({,) hash
)
