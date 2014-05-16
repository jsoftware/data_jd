NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
bldnums=: 3 : 0
jdadminx'test'
jd'createtable';T;'a boolean,b int,c float,d int 2'
)

ins=: 3 : 0
jd'insert';T;,N,.y
)

insx=: 4 : 0
try.
 jd'insert';T;,N,.y
 assert 0
catch.
 assert (<x)e.;:>;1{jdlast
end.
)

N=: ;:'a b c d'
T=: 'num'

bldnums''
ins 0;2;2.2;1 2$23 24
1=;{:,jd'reads count a from ',T

ins 0 1;4 5;4.2 4.3;2 2$33 44 55 66
3=;{:,jd'reads count a from ',T


N=: ;:'a b c'
'missing' insx 0 1;4 5;4.2 4.3

N=: ;:'a b c d c'
'duplicate' insx 0 1;4 5;4.2 4.3;4.2 4.2;123

N=: ;:'a b c d e'
'unknown' insx 0 1;4 5;4.2 4.3;4.2 4.2;23


N=: ;:'a b c d'
'count' insx 0 1 ; 4 5 6 ; 4.2 4.3       ; 2 2$33
'shape' insx 0 1 ; 4 5   ; 4.2 4.3       ; 2 3$2
'shape' insx 0 1 ; 4 5   ; (2 1$4.2 4.3) ; 2 2$2
'data'  insx 0   ; 2.5   ; 2.2           ; 1 2$23 24

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
jd'createtable';'dt2';'a datetime,b datetime 2'
)

N=: ;:'a b'
T=: 'dt2'
blddt2''
'shape' insx 2;1 2$2

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
3=;{:,jd'reads count a from ch'

'count' insx 'ab'  ; (1 2$'ab') ; <<'abd'
'count' insx 'a'   ; (2 2$'ab') ; <<'abd'
'count' insx 'ab'  ; (1 2$'ab') ; <'abd';'qewt'
'shape' insx 'ab' ;  (2 3$'ab') ; <'abd';'qwert'
