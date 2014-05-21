NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. northwind.sandp, sed run with ref and reference

load JDP_jd_,'demo/common.ijs'

builddemo'northwind'
f=. JDP_jd_,'demo/northwind/northwind.ijs'
jdadmin'northwind'
load f
jdadmin'northwind_shuffle'
load f

builddemo'sandp'
f=. JDP_jd_,'demo/sandp/sandp.ijs'
jdadmin'sandp'
load f
jdadmin'sandp_shuffle'
load f

builddemo'sed'
f=. JDP_jd_,'demo/sed/sed.ijs'
jdadmin'sed'
load f
jdadmin'sed_shuffle'
load f

load JDP_jd_,'demo/vr/vr.ijs'

