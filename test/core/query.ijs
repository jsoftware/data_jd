NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that queries function

load JDP,'test/core/key.ijs' NB. Uses the key test to build test database

((#~=&1) >{:{:Read__d 'int from ref') -: >{:{:Read__d 'int from ref where int = 1'
((#~e.&1 2 4) >{:{:Read__d 'int from ref') -: >{:{:Read__d 'int from ref where int in (1,2,4)'

((#~=&(<,:'1')) >{:{:Read__d 'varbyte from ref') -: >{:{:Read__d 'varbyte from ref where varbyte is "1"'
((#~e.&(,:&.>'1';'2';'4')) >{:{:Read__d 'varbyte from ref') -: >{:{:Read__d 'varbyte from ref where varbyte in ("1","2","4")'
