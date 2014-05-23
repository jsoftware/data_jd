NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. northwind.sandp, sed run with ref and reference

NB.! shuffle tests need work (order by)
load JDP,'demo/common.ijs'

builddemo'northwind'
f=. JDP,'demo/northwind/northwind.ijs'
jdadmin'northwind'
load f
NB. jdadmin'northwind_shuffle'
NB. load f

builddemo'sandp'
f=. JDP,'demo/sandp/sandp.ijs'
jdadmin'sandp'
load f
NB. jdadmin'sandp_shuffle'
NB. load f

builddemo'sed'
f=. JDP,'demo/sed/sed.ijs'
jdadmin'sed'
load f
NB. jdadmin'sed_shuffle'
NB. load f

load JDP,'demo/vr/vr.ijs'

