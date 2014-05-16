NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
require '~addons/data/jd/test/core/util.ijs'

f =: Open_jd_ jpath '~temp/jd'
d =: (Create__f [ Drop__f) 'btest'

A=: Create__d 'A' ; ((,', '&,)&:>/@:((,' '&,)&.>);<@(,.".@('r_',,&' 1000')&.>)) TYPES
B=: Create__d 'B' ; 'boolean boolean,int int'

empty MakeRef__d 'A B' ,.&;: 'boolean boolean'

Insert__d 'B';<('boolean';'int'),.(2&|;])i.100

empty MakeRef__d 'A B' ,.&;: 'int int'

d =: (Open__f [ BadClose__f) 'btest'

Insert__d 'B';<('boolean';'int'),.(2&|;])100+i.100
