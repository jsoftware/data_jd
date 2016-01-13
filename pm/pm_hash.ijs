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

require'plot'


hashfile=: 3 : 0
'~temp/jdpm/',y,'.txt'
)

jdpm=: '~temp/jdpm/'


gdb=: 3 : 0
jdpm,gdan y
)

gdan=: 3 : 0
'pma',(10":y)rplc ' ';'0'
)

pmaccess=: 3 : 0
jdaccess y
pmnb_jd_'jdaccess ',y
)

NB. pmcreate 1e6 - rows
NB. close reduces paging
pmcreate=: 3 : 0
jdcreatefolder_jd_'~temp/jdpm'
CSVFOLDER=: 'csv',~gdb y
jddeletefolder_jd_ CSVFOLDER
jdadminx 'x',~gdb y
jdadminx gdb y
pmclear_jd_''
pmaccess gdan y
jd'createtable f'
d=. y?.@$<:2^63
n=.((y<40000){40000,<.0.5*y)?.@$<:2^63

jd'createcol f a int _';d        NB. unique serial number
jd'close'
jd'createcol f b int _';y$n      NB. supplier id
jd'close'
jd'createcol f c int _';i.y      NB. data
jd'close'
                                                    NB. jd'createcol f d int _';(1e6*y)$n
jd'createtable g'
jd'createcol g p int _';|.n      NB. unique supplier id
jd'close'
jd'createcol g q int _';i.#n     NB. data
jd'close'

erase 'd n'

jd'csvwr f.csv f'
jd'close'
jd'csvwr g.csv g'
jd'close'

r=. pmr_jd_''
(r,.LF) fwrite '/pmcreate.txt',~gdb y
r
)

pmhash=: 3 : 0
jdadmin gdb y
jd'createhash f a'
jd'close'
jd'createhash f b'
jd'close'
jd'close'
jd'createhash g p'
jd'close'
jd'reference f b g p'
jd'close'
r=. pmr_jd_''
(r,.LF) fwrite '/pmhash.txt',~gdb y
r
)

pmload=: 3 : 0
jd'csvwr f.csv f'
jd'close'
jd'csvwr g.csv g'
jd'close'
pmaccess 'x',~gdan y
jd'csvrd /rows 0 f.csv h'
jd'close'
jd'csvrd /rows 0 g.csv i'
jd'close'
pmaccess gdan y
pmnb_jd_'jdaccess ',t
r=. pmr_jd_''
(r,.LF) fwrite '/pmcreate.txt',~gdb y
r
)



pmhash1s=: 3 : 0
'start step end'=. y
F=: f=. jdpm,'hash1.txt'
''fwrite f 
while. start<:end do.
 pmclear_jd_''
 pmhash 'hash';1;start
 (LF,~8":start,pmtotal_jd_'')fappend f
 start=. start+step
end.
)

pmplot=: 3 : 0
d=. fread y
n=. 0".each<;._2 d
y=. ;{.each n
x=. ;{:each n
plot y;x
)

pmref=: 3 : 0
jdadmin gdb y
t=. 'f jdreference f d g p'
decho t
'dynamic already exists'assert 0=jdgl_jd_ :: 0: t
pmclear_jd_''
jd'reference f d g p'
r=. pmtotal_jd_''
jdadmin 0
(":r)fwrite ('/pmreference.txt'),~gdb y
r
)


pmrep=: 3 : 0
d=. 1 dir (gdb y),'/pm*'
n=. _4}.each}.each(d i: each '/')}.each d
v=. 8":each 0".each fread each d
sptable n,.v
)



NB. hashtime 'hash';1;10;10;60
NB. hashtime type;cols;start;step;limit
NB. type:  hash
NB. cols 1 (f a) or 2 (f b c)
NB. start: *1e6 rows
NB. step:  +1e6 rows
NB. limit: go up this*1e6 rows
hashtime=: 3 : 0
'type cols start step limit'=: y
fn=. hashfile type
''fwrite fn
while. start<:limit do.
 r=. hashit type;cols;start
 (LF,~8":start,r)fappend fn
 start=. start+step
end.
)

plotit=: 3 : 0
t=. 0".each<;._2 fread hashfile y
y=. ;{.each t
x=. ;{:each t
plot y;x
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