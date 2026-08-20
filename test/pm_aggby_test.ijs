NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. aggregate by timings - thanks to Joe Bogner database email
NB. compare aggregate by with J
NB. hash does not help Jd performance

jdadminx 'timing'
jd'createtable t';'a int';'b byte 8';'c byte 4';'d byte 12'
N=:20e6 5e6{~IFIOS+.IFRASPI+.UNAME-:'Android'  NB. arm64
group1=.10 8 $ 8 # a. {~ 97+(i.10)
group1v=. group1 {~ ?. N#10
group2=.10 4 $ 4 # a. {~ 97+(i.5)
group2v=. group2 {~ ?. N#5
jd'insert t';'a';(N#1);'b';group1v;'c';group2v;'d';group1v,.group2v

tbc=: 6!:2 'jdresult=:jd ''reads sum a by b,c from t'''
td=: 6!:2 'r=: jd ''reads sum a by d from t'''
assert ({:"1{:jdresult)-:{:"1{:r

aloc=: jdgl_jd_'t a'
bloc=: jdgl_jd_'t b'
cloc=: jdgl_jd_'t c'

doj=:  3 : 0
groupidx=:i.~ |: i.~ every (dat__bloc;dat__cloc)
jresult=: ((~.groupidx){dat__bloc);((~.groupidx){dat__cloc);,.(groupidx +//. dat__aloc)
)

tj=: 6!:2'doj 0'
assert jresult-:{:jdresult

assert JDTIMING_jd_+.tbc>td          NB. b,c vs d
assert JDTIMING_jd_+.(0.2*tj)>|td-tj NB. d   vs j - should be close
assert JDTIMING_jd_+.td<1.4*tj       NB. not too much worse than j time

