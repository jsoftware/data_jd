NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

NB. test host flush of memory mapped dirty pages

jd'close'
jdadminx'test'
jd'createtable f'
jd'createcol f a int _';i.10e6

jd'flush' NB. may have already been flushed if createcol does flush
c=: jdgl_jd_'f a'
dat__c=: >:dat__c NB. lots of dirty pages
t=: timex 'jd''flush'''
'dirty buffer flush too fast'assert (t>0.1)+.UNAME-:'Darwin' NB. mac does not wait for flush to finish
