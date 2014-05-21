NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that unique columns work

f =: Open_jd_ jpath '~temp/jd'
d =: (Create__f [ Drop__f) 'btest'

1: Create__d 'a';'col int'
1: MakeUnique__d 'a';'col'

Insert__d 'a'; <'col';0 1
