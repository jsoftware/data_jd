NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
bldnums=: 3 : 0
jdadminx'test'
jd'createtable';T;'a boolean,b int,c float'
)

ins=: 3 : 0
jd'insert';T;,N,.y
)

insx=: 4 : 0
x jdae 'insert';T;,N,.y
)

N=: ;:'a b c'
T=: 'num'

bldnums''
ins 0;2;2.2
1=;{:,jd'reads count a from ',T

ins 0 1;4 5;4.2 4.3
3=;{:,jd'reads count a from ',T


N=: ;:'a c'
'missing' insx 0 1;4.4 5

N=: ;:'a b c c'
'duplicate' insx 0 1;4 5;4.2 4.3;4.4 5.4

N=: ;:'a b c d e'
'unknown' insx 0 1;4 5;4.2 4.3;4 4;23


N=: ;:'a b c'
'count' insx 0 1 ; 4 5 6 ; 4.2 4.3
        ins  0 1 ; 4 5   ; 4.2 4.3 
'data'  insx 0   ; 2.5   ; 2.2 

d =: 201212010
t =: 101010
dt=: 20121010111111

blddt=: 3 : 0
jdadminx'test'
jd'createtable';'dt';'a datetime,b date,c int' NB. time
)

N=: ;:'a b c'
T=: 'dt'
blddt''
ins 1   ; 2   ; 3
ins 1 1 ; 2 2 ; 3 3
3=;{:,jd'reads count a from dt'

blddt2=: 3 : 0
jdadminx'test'
jd'createtable';'dt2';'a datetime,b datetime'
)

N=: ;:'a b'
T=: 'dt2'
blddt2''
ins 2;23

N=: ;:'a b c'
T=: 'ch'
bldch=: 3 : 0
jdadminx'test'
jd'createtable';'ch';'a byte,b byte 2,c varbyte'
)
bldch''
ins 'a'  ; (1 2$'ab') ; <<'abd'
ins 'ab' ; (2 2$'ab') ; <'abd';'qwert'

jd'reads from ch'
assert 5=;{:,jd'reads count a from ch'

        ins  'ab'  ; (1 2$'ab') ; <<'abd'
        ins  'a'   ; (2 2$'ab') ; <<'abd'
'shape' insx 'ab' ;  (2 3$'ab') ; <'abd';'qwert'

N=: ;:'a b'
T=: 'chx'
bldchx=: 3 : 0
jdadminx'test'
jd'createtable';T;'a byte,b byte 2'
)
bldchx''
ins 'a'  ; (1 2$'ab') 
ins 'ab' ; (2 2$'ab')

jd'reads from chx'
3=;{:,jd'reads count a from chx'

        ins  'ab'  ; 1 2$'ab'
        ins  'a'   ; 2 2$'ab'
        ins  'ab'  ; 1 2$'ab'
'shape' insx 'ab' ;  2 3$'ab'
