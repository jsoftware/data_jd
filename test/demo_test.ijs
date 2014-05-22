NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. northwind.sandp, sed run with ref and reference

load JDP,'demo/common.ijs'

builddemo'northwind'
f=. JDP,'demo/northwind/northwind.ijs'
jdadmin'northwind'
load f
jdadmin'northwind_shuffle'
load f

builddemo'sandp'
f=. JDP,'demo/sandp/sandp.ijs'
jdadmin'sandp'
load f
jdadmin'sandp_shuffle'
load f

builddemo'sed'
f=. JDP,'demo/sed/sed.ijs'
jdadmin'sed'
load f
jdadmin'sed_shuffle'
load f

load JDP,'demo/vr/vr.ijs'

