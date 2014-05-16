NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. northwind.sandp, sed run with ref and reference

load'~addons/data/jd/demo/common.ijs'

builddemo'northwind'
f=. '~addons/data/jd/demo/northwind/northwind.ijs'
jdadmin'northwind'
load f
jdadmin'northwind_shuffle'
load f

builddemo'sandp'
f=. '~addons/data/jd/demo/sandp/sandp.ijs'
jdadmin'sandp'
load f
jdadmin'sandp_shuffle'
load f

builddemo'sed'
f=. '~addons/data/jd/demo/sed/sed.ijs'
jdadmin'sed'
load f
jdadmin'sed_shuffle'
load f

load'~addons/data/jd/demo/vr/vr.ijs'

