NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
jdadminx'test'

jd'createtable f'
jd'createcol f a int _';a=.i.5
jd'createcol f b int 2';b=. i.5 2
jd'createcol f c byte 4';c=.5 4$'asdf134'

assert (a;b;c)-:{:"1 jd'read from f'

jd'createtable g'
jd'createcol g a int'
jd'createcol g b int 2'
jd'createcol g c byte 4'
jd'insert g';'a';a;'b';b;'c';c

assert (jd'read from f')-:jd'read from g'
