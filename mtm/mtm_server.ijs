NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB. mtm insert server initialization routines

require'~Jddev/jd.ijs'

NB. RW task init - y is DB
winit=: 3 : 0
jdadmin 0
jdadmin y
d=. deb each<"1>2{"1{:jd'info schema'
'int2 not allowed'   assert -.(<'int2')e.d
'int4 not allowed'   assert -.(<'int4')e.d
'ref not allowed'    assert 0 0=>$each {.{:jd'info ref'
jd'info summary'
)

NB. RO task init - y is DB
rinit=: 3 : 0
jdadmin 0
jdadmin y;MTRO_jmf_
NB. (;{.{.jdadminop_jd_'')jdadminop_jd_ 'read reads info list' NB. only allow read type ops
JDMTMRO_jd_=: 1 NB. mark as mtm ro task
jd'info summary' NB. critical that RO tasks has correct and stable locale info
)
