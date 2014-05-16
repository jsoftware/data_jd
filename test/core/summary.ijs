NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that summary columns work

require '~addons/data/jd/test/core/util.ijs'
f=: Open_jd_ jpath '~temp/jd'
d=: (Create__f [ Drop__f) 'btest'

DATA=. 1000 ?@$ 1000

A=: Create__d 'A';'col int';<,:'col';DATA
B=: Create__d 'B';'col int';<,:'col';i:5
1: MakeUnique__d 'B';'col'

NB. ustom aggregate functions
NB. aggregate fns no longer stored in state
NB. db open gets default agg fns
NB. additional agg funs usually added by custom.ijs
aggcreate=: 3 : 0
f=. Open_jd_ jpath '~temp/jd'
d=. Open__f'btest'
(1:"0) addagg__d 'ones'
]  addagg__d 'identity'
(10|]) addagg__d 'mod10'
(<@":) addagg__d 'boxatopformat'
<@(3!:1) addagg__d 'boxbinary'
(10|<.@%&100 10 1)"0 addagg__d 'split3digits'
)

aggcreate''

1: MakeSumR__d 'identity A.jdindex,colmod10: mod10 A.col,split3: split3digits A.col from A'

1: MakeRef__d   ('A';'B'),.'colmod10';'col'
1: MakeRef__d |.('A';'B'),.'colmod10';'col'

1: MakeSumR__d 'identity A.jdindex,hasBdata: ones A.jdindex from A,A-B'
1: MakeSumR__d 'identity B.jdindex,hasAdata: ones B.jdindex from A,A-B'

1: MakeSumR__d 'num1: count A.col, min1: min A.col, avg1: avg A.col, dat1: boxatopformat A.col by B.jdindex from B,B-A'
1: MakeSumR__d 'num2: count A.col, min2: min A.col, avg2: avg A.col, dat2: boxatopformat A.col by B.jdindex from A,A.B where B'

sum=: {. MakeSumRTable__d 'sum';'num: count A.col, min: min A.col, avg: avg A.col, dat: boxatopformat A.col,split3bin: boxbinary A.split3 by colmod10: A.colmod10 from A order by colmod10'

setequals=: -:&:(/:~)

runtests=. 3 : 0
o=.    ((#&>;<./&>;(+/%#)&>) y) -: {:"1}: Read__d 'num1,min1,avg1,col from B where hasAdata=1 order by col'
o=. o, *./ y setequals&> ".&.> >{:{.Read__d 'dat1,col from B where hasAdata=1 order by col'
o=. o, ((#&>;<./&>;(+/%#)&>) y) -: {:"1}: Read__d 'num2,min2,avg2,col from B where hasAdata=1 order by col'
o=. o, *./ y setequals&> ".&.> >{:{.Read__d 'dat2,col from B where hasAdata=1 order by col'
)
NB. o=. o, (Read__d 'from sum') setequals Read__d 'num: count A.col, min: min A.col, avg: avg A.col, dat: boxatopformat A.col,split3bin: boxbinary A.split3 by colmod10: A.colmod10 from A order by colmod10'

NB. Initial test
NB. =========================================================
runtests 6{. (10&| (</./:~.@[) ]) DATA

NB. Close test
NB. =========================================================
BadClose__f 'btest' NB. avoid writestate
d=: Open__f'btest'
aggcreate'' 
runtests 6{. (10&| (</./:~.@[) ]) DATA

NB. Insert to B
NB. =========================================================
1: Insert__d 'B';<'col';,:6
runtests 7{. (10&| (</./:~.@[) ]) DATA

NB. Insert to B & Close
NB. =========================================================
1: Insert__d 'B';<'col';,:7
BadClose__f 'btest' NB. avoid writestate
d=: Open__f'btest'
aggcreate'' 
runtests 8{. (10&| (</./:~.@[) ]) DATA

NB. Insert to A
NB. =========================================================
MOREDATA=. 1000 ?@$ 1000
1: Insert__d 'A';,:<'col';MOREDATA
runtests 8{. (10&| (</./:~.@[) ]) DATA=. DATA,MOREDATA

NB. Insert to A & Close
NB. =========================================================
MOREDATA=. 1000 ?@$ 1000
1: Insert__d 'A';,:<'col';MOREDATA
BadClose__f 'btest' NB. avoid writestate
d=: Open__f'btest'
aggcreate'' 
runtests 8{. (10&| (</./:~.@[) ]) DATA=. DATA,MOREDATA
