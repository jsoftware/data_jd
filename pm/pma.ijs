NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

0 : 0
might be worthwhile to play with linux sysctl values

bin/vm report/delay/report

tuning could make sense for production Jd system
)

tm_ref=: 0 : 0
-*jdadminx 'pma'                NB. tm_ref
-gen two f A0 g
ref f a2 g b2
refset f jdreference_a2_g_b2
*jd'update f';'a1=0';'a1';0;'a2';2
*jd'update f';'a1=0';'a1';0;'a2';2
refset f jdreference_a2_g_b2
reads from f,f.g where f.a1=0
reads from f,f.g where f.a1=0
*jd'insert f';'a1';_23;'a2';1
*jd'insert g';'b2';_23
refset f jdreference_a2_g_b2
)

tm_reference=: 0 : 0
-*jdadminx 'pma'                NB. tm_reference
-gen two f A0 g
reference f a2 g b2
*jd'update f';'a1=0';'a1';0;'a2';2
*jd'update f';'a1=0';'a1';0;'a2';2
reads from f,f.g where f.a1=0
reads from f,f.g where f.a1=0
*jd'insert f';'a1';_23;'a2';1
*jd'insert g';'b2';_23
)

tm_reference_hash_hash=: 0 : 0
-*jdadminx 'pma'                NB. tm_reference_hash_hash
-gen two f A0 g
createhash f a2
createhash g b2
reference f a2 g b2
*jd'update f';'a1=0';'a1';0;'a2';2
*jd'update f';'a1=0';'a1';0;'a2';2
reads from f,f.g where f.a1=0
reads from f,f.g where f.a1=0
*jd'insert f';'a1';_23;'a2';1
*jd'insert g';'b2';_23
)

tm_reference_hash_unique=: 0 : 0
-*jdadminx 'pma'                NB. tm_reference_hash_unique
-gen two f A0 g
createhash   f a2
createunique g b2
reference f a2 g b2
*jd'update f';'a1=0';'a1';0;'a2';2
*jd'update f';'a1=0';'a1';0;'a2';2
reads from f,f.g where f.a1=0
reads from f,f.g where f.a1=0
*jd'insert f';'a1';_23;'a2';1
*jd'insert g';'b2';_23
)

tm_insert=: 0 :0
*jd'delete f';'a1<10'
*jd'insert f';'a1';0;'a2';1
*jd'insert f';'a1';1;'a2';2
)

report=: 3 : 0
echo tm_reference tm y
echo tm_reference_hash_unique tm y
echo tm_reference_hash_hash tm y
)

tm=: 4 : 0
t=. 4{.<;._2 y,' '
t=. ,('A',each '0';'1';'2';'3'),.t
t=. x rplc t
ss=. <;._2 t
t=. 0
b=. <pmdb,' ',y
for_s. ss do.
 s=. >s
 if. '+'={.s do.
  t=. t,0
  b=. b,<s,LF,".}.s
  continue.
 end.
 b=. b,<s
 j=. '-'={.s
 s=. j}.s
 k=. '*'={.s
 s=. k}.s
 if. -.k do.
  s=.  'jd''',s,''''
 end.
 t=. t,(timex s)*-.j
end.
t=. t,+/t
b=. b,<'total'
t=. <.1000*t
t=. 8j0 ": each t
last=: t,.b
seebox_jhs_ last
)


NB. tm_csvcreate tm 'f 1000 10'
tm_csvcreate=: 0 : 0
*jdadminx pmdb
gen one A0 A1 A2
*jdflush_jd_''
)

NB. tm_csvdump tm '~temp/csv' 
tm_csvdump=: 0 : 0
*jdadmin pmdb
*CSVFOLDER=: 'A0'
*jddeletefolder_jd_ CSVFOLDER
*jdflush_jd_''
csvdump
*jdflush_jd_''
+}:,LF,.~dir CSVFOLDER,'*'
)

NB. tm_csvrestore '~temp/csv' 
tm_csvrestore=: 0 : 0
*jdadminx pmdb
*CSVFOLDER=: 'A0'
*jdflush_jd_''
csvrestore
*jdflush_jd_''
)
