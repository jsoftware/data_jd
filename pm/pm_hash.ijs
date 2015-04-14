NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

0 : 0
Jd hash differs from J hash
J has special hash for ints and extra special for small range ints
Jd does not have these special cases

comparing Jd createhash vs J (a i. b) is interesting
data that avoids J small range ints should be used
data=: y ?@$ <:2^63 NB. avoid J small range hash

overwheling problem is distribution of hash values to hash/link
causing disk access and thrash
)

0 : 0
   hashv 50e6 NB. gives hash info
   
time to calculate hash values is relatively small
could be faster but wouldn't make any difference
might be more important with multi-pass distribution

hash collision is potential performance killer
hashv gives actual and expected (google) collisions
Jd hash seems pretty good

distributing hash values to hash/link is the bottleneck
hits many different pages and any disk access becomes thrash

linux default has aggressive dirty page write for mapped file
this is a killer for hash/link
page file memory is less aggressive and performs much better
see kludge in hash.ijs insert to use page file for linux hash/link

windows does not have the same dirty page performance difference
between mapped file and page file
)


0 : 0
   plot tsts 6 NB. thrash on 6gb windows

shows how createhash gets into thrash on 6gb windows
createhash 80e6 ok but 100e6 and 120e6 thrash

)   

NB. tst 30r6
tst=:3 : 0
jdadminx'test'
data=. i.y
jd'createtable f'
jd'createcol f a int _';data
pmclear_jd_''
jd'createhash f a'
pmtotal_jd_''
)

tsts=: 3 : 0
r=. ''
for_i. >:i.y do.
 echo i*20e6
 tst i*20e6
 r=. r,pmtotal_jd_''
end.
)

tstreadcreate=: 3 : 0
jdadminx'testa'
data=. i.80e6
jd'createtable fa'
jd'createcol fa a int _';data
jd'createhash fa a'
jdadminx'testb'
jd'createtable fb'
jd'createcol fb a int _';data
jdadmin 0
)

tstread=: 3 : 0
jdadmin 0
jdadmin'testa'
jdgl_jd_'fa jdhash_a' NB. open hash col to set lookup!!!!
pmclear_jd_''
jd'reads from fa where a=1000'
jdadmin 0
jdadmin'testb'
jd'reads from fb where a=1000'
pmr_jd_''
)

NB. hash_insert_fixed1 called directly with args
hash_test=: 3 : 0
d=: i.y
col=. pointer_to_name_jd_ 'd__'
hlen=. 4 p: +:y
h=: hlen$_1
hashP=. pointer_to_name_jd_ 'h__'
l=: y$_1
linkP=. pointer_to_name_jd_ 'l__'
a=: y$1
actP=. pointer_to_name_jd_ 'a__'
off=. 0
lib =. LIBJD_jd_,' hash_insert_fixed1 > x x x x x x x'
decho off;hashP;linkP;actP;col;col
r =. lib cd off;hashP;linkP;actP;col;col
)

NB. hashv i.50e6
NB. hash_fixed1 to get hash values
NB. return collisions expected,actual
hashv=: 3 : 0
d=: y
hv=: (#y)$_1
dp=.  pointer_to_name_jd_ 'd__'
hvp=. pointer_to_name_jd_ 'hv__'
lib=. LIBJD_jd_,' hash_fixed1 > x x x'
time=. <.0.5+1000*timex'lib cd dp;hvp'
len=. 11>.4 p: +:#y
hv=: len|hv
actual=. (#d)-#~.hv
NB. m buckets n inserts
'm n'=. len,#d
expected=. <.0.5+n - m * (1 - ((m-1)%m)^n)
echo'time actual expected'
time,actual,expected
)