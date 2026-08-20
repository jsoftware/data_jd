NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Tests for JD API

NB. ---------------------------------------------------------
NB. create column
jdadminx'test'
jd'gen test tab 5'
assert 8 -: #>{.{:jd'info schema'
jd'createcol tab xx int'
assert 9 -: #>{.{:jd'info schema'

NB. ---------------------------------------------------------
NB. create table
jdadminx'test'
jd'gen test tab 5'
jd'createtable';'tab2';'x int';'one int';'two int'
jd'insert';'tab2';'x';1 2 3 4 5 6;'one';23 24 25 26 27 28;'two';45 46 47 48 49 50
assert 11 2 -: (#,#@:~.)>{.{:jd'info schema'


NB. ---------------------------------------------------------
NB. delete
jdadminx'test'
jd'gen test tab 5'
jd'delete';'tab';'boolean=1'
assert 0 3 -: >{:,jd'read x from tab'


NB. ---------------------------------------------------------
NB. drop column
jdadminx'test'
jd'gen test tab 5'
assert 8 -: #jd'read from tab'
jd'dropcol tab int'
assert 7 -: #jd'read from tab'


NB. ---------------------------------------------------------
NB. drop table
jdadminx'test'
jd'gen test tab 5'
assert 8 -: #>{.{:jd'info schema'
jd'gen test tab2 5'
assert 16 -: #>{.{:jd'info schema'
jd'droptable tab2'
assert 8 -: #>{.{:jd'info schema'

NB. ---------------------------------------------------------
NB. get
jdadminx'test'
jd'gen test tab 5'
assert 0 1 2 3 4 -: jd'get tab x'

NB. ---------------------------------------------------------
NB. reads
jdadminx'test'
jd'gen test tab 5'
jd'reads from tab'
jd'reads x from tab'
assert (i.5)-:,;{:jd'reads x from tab'
assert (5 4$AlphaNum_j_)-:;{:jd'reads byte4 from tab'
assert (5$0 1 1)-:,;{:jd'reads boolean from tab'


NB. ---------------------------------------------------------
NB. read join
jdadminx'test'
jd'gen test tab 5'
jd'createtable';'tab2';'x int';'one int';'two int'
jd'insert';'tab2';'x';1 2 3 4 5 6;'one';23 24 25 26 27 28;'two';45 46 47 48 49 50
assert 0 0 0 0-:;$each {:jd'info ref'
jd'ref tab x tab2 x'
assert 1 3 1 14-:;$each {:jd'info ref'
assert 5 -: #>{:{. jd'read from tab,tab.tab2'


NB. ---------------------------------------------------------
NB. reads where
jdadminx'test'
jd'gen test tab 5'
jd'reads x from tab where x=3'
assert 3=;{:jd'reads x from tab where x=3'
assert 'BCE'-:,;{:jd'reads byte from tab where boolean=1'


NB. ---------------------------------------------------------
NB. set
jdadminx'test'
jd'gen test tab 5'
assert 0 1 2 3 4 -: jd'get tab x'
jd'set';'tab';'x';5 6 7 8 9
assert 5 6 7 8 9 -: jd'get tab x'
