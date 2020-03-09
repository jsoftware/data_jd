NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. mtm insert server initialization routines

require'~Jddev/jd.ijs'

NB. RW task init - y is DB
winit=: 3 : 0
jdadmin 0
jdadmin y
d=. deb each<"1>2{"1{:jd'info schema'
'varbyte not allowed'assert -.(<'varbyte')e.d
'int2 not allowed'   assert -.(<'int2')e.d
'int4 not allowed'   assert -.(<'int4')e.d
'ref not allowed'    assert 0 0=>$each {.{:jd'info ref'
jd'info summary'
)

NB. RO task init - y is DB
rinit=: 3 : 0
jdadmin 0
jdadmin y;MTRO_jmf_
JDMTMRO_jd_=: 1 NB. mark as mtm ro task
jd'info summary' NB. critical that RO tasks has correct and stable locale info
)
