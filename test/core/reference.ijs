NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

f =: Open_jd_ jpath '~temp/jd'
d =: (Create__f [ Drop__f) 'btest'

A=: Create__d 'A' ; ((,', '&,)&:>/@:((,' '&,)&.>);<@(,.".@('r_',,&' 1000')&.>)) TYPES_CORE
B=: Create__d 'B' ; 'boolean boolean,int int'

empty MakeRef__d 'A B' ,.&;: 'boolean boolean'

Insert__d 'B';<('boolean';'int'),.(2&|;])i.100

empty MakeRef__d 'A B' ,.&;: 'int int'

d =: (Open__f [ Close__f) 'btest' NB. was BadClose without writestate

Insert__d 'B';<('boolean';'int'),.(2&|;])100+i.100
