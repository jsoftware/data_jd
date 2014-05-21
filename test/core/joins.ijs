NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

f=: Open_jd_ jpath'~temp/jd'
d=: (Create__f [ Drop__f) 'joindemo'

'A B'=: <"1 (|:#"1 i.@#) >, <@,"0/~ i.3

matchnone=: 0 ,.~ -.
matchone=: ,.~@:([-.-.)
matchall=: ,.~"_1@:( ] (] #~ #/.~@[ {~ ~.@[ i. ]) ([-.-.) )

default=: matchnone , matchone
left=: matchnone , matchall
inner=: matchall
outer=: matchnone , matchall , |."_1@:matchnone~

AdB=:       A default  B
BdA=: |."_1 A default~ B
AlB=:       A left  B
BlA=: |."_1 A left~ B
AiB=:       A inner  B
BiA=: |."_1 A inner~ B
AoB=:       A outer  B
BoA=: |."_1 A outer~ B
ArB=: BlA
BrA=: AlB

setequals=: -:&:(/:~)

1: Create__d 'a';'aidx int';<< A
1: Create__d 'b';'bidx int';<< B

1: MakeRef__d   'a b' ,.&;: 'aidx bidx'
1: MakeRef__d |.'a b' ,.&;: 'aidx bidx'

NB. Separate tables
A -:&, > {:"1 Read__d '* from a'
B -:&, > {:"1 Read__d '* from b'

NB. Left, right, and default joins
AdB setequals |:>{:"1 Read__d 'a.*,b.* from a,a.b'
BdA setequals |:>{:"1 Read__d 'a.*,b.* from b,b.a'
AlB setequals |:>{:"1 Read__d 'a.*,b.* from a,left a.b'
BlA setequals |:>{:"1 Read__d 'a.*,b.* from b,left b.a'
ArB setequals |:>{:"1 Read__d 'a.*,b.* from a,right a.b'
BrA setequals |:>{:"1 Read__d 'a.*,b.* from b,right b.a'

NB. Inner and outer joins
AiB setequals |:>{:"1 Read__d 'a.*,b.* from a,inner a.b'
BiA setequals |:>{:"1 Read__d 'a.*,b.* from b,inner b.a'
AoB setequals |:>{:"1 Read__d 'a.*,b.* from a,outer a.b'
AoB setequals |:>{:"1 Read__d 'a.*,b.* from b,outer b.a'

NB. Same for joins using symbols
AdB setequals |:>{:"1 Read__d 'a.*,b.* from a,a.b'
BdA setequals |:>{:"1 Read__d 'a.*,b.* from b,b.a'
AlB setequals |:>{:"1 Read__d 'a.*,b.* from a,a>b'
BlA setequals |:>{:"1 Read__d 'a.*,b.* from b,b>a'
ArB setequals |:>{:"1 Read__d 'a.*,b.* from a,a<b'
BrA setequals |:>{:"1 Read__d 'a.*,b.* from b,b<a'
AiB setequals |:>{:"1 Read__d 'a.*,b.* from a,a-b'
BiA setequals |:>{:"1 Read__d 'a.*,b.* from b,b-a'
AoB setequals |:>{:"1 Read__d 'a.*,b.* from a,a=b'
AoB setequals |:>{:"1 Read__d 'a.*,b.* from b,b=a'
