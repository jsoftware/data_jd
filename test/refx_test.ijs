NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
NB. verify ref dat set properly 

acr=: 3 : 0
n=. y
jdadminx'test'
jd'createtable f'
a=. 13*i.n
b=. 89*i.1000<.-:n
jd'createcol f a  int _';a
jd'createcol f b  int _';n$b
jd'createtable g'
jd'createcol g a  int _';|.a
jd'createtable h'
jd'createcol h b  int _';|.b
)

validate=: 3 : 0
jd'ref f a g a'
jd'reads from f,f.g where jdindex=0' NB. make dirty ref clean
jd'ref f b h b'
jd'reads from f,f.h where jdindex=0' NB. make dirty ref clean

h=. jdgl_jd_'f jdref_a_g_a'
a=. jdgl_jd_'f'
refdata=: Tlen__a=#dat__h

ra=: jd'reads from f,f.g,f.h'
)

acr 100

validate''

jdshuffle_jd_'f'
jdshuffle_jd_'g'
jdshuffle_jd_'h'

validate''

NB. preliminary work for when ref dynamically handles delete/insert
acr 10
jd'ref f a g a'
jd'delete f';'a=13'
jd'delete g';'a=13'
jd'insert f';'a';100;'b';200
jd'insert g';'a';500


