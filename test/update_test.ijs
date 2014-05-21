NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
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

N=: ;:'A B C'
T=: 'ch'
bldch=: 3 : 0
jdadminx'test'
jd'createtable';'ch';'A byte,B byte 2,C varbyte'
)

bldch''
ins 'q'  ; (1 2$'qw')   ; <<'qwe'
ins 'Bx' ; (2 2$'zxpo') ; <'ghi';'jklmn'

jd'reads from ch'
3=;{:,jd'reads count A from ch'


NB. bug - update with exported varbyte value 3 times damages mapping!

jd'update';T;'B="qw"';'A';'z'
jd'reads from ch'
jd'close'

jd'update';T;'B="qw"';'A';'z'
jd'reads from ch'
jd'close'

jd'update';T;'B="qw"';'A';'z'
