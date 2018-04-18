NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass'jd'

pmhelp=: 0 : 0
   pmclear_jd_'' NB. clears times and start recording
   pmclear_jd_ 0 NB. stop recording
   pmr_jd_''     NB. reports times for last PMMR_jd_ ops
   pmtotal_jd_'' NB. returns total time
   
Non-Jd times can be included.

   pm'name'      NB. start timer
   pmz''         NB. end timer
   pmz_jd_''[doit data[pm_jd_'zxcv'
)

pmclear=: 3 : 0
if. 0-:y do. PMON=: 0 return. end.
PMON=: 1
PMN=: PMT=: ''
i.0 0
)

NB. record section start
pm=: 3 : 0
PMNAME=:  y
PMSTART=: 6!:9''
i.0 0
)

pmfmt=: 3 : 0
if. 0=#y do. '' else. ' ',y end.
)

NB. record section end
pmz=: 3 : 0
if. _1=nc<'PMON' do. PMON=: 0 end.
if. -.PMON do. return. end.
t=. 0>.(#PMN)-<:PMMR
PMN=: t}.PMN,<(14{.PMNAME),fmtsummary jdlasty
PMT=: t}.PMT,PMSTART-~6!:9''
i.0 0
)

pmnb=: 3 : 0
t=. 0>.(#PMN)-<:PMMR
PMN=: t}.PMN,<y
PMT=: t}.PMT,0
i.0 0
)

NB. report jd performance
pmr=: 3 : 0
t=. <.0.5+1000*PMT%6!:8''
(8j0":,.t,+/t),.' ',.>PMN,<'total'
)

pmtotal=: 3 : 0
+/<.0.5+1000*PMT%6!:8''
)

fmtsummary=: 3 : 0
if. 0=L.y do.
 deb y
else.
 y=. (<'-') ((2~:;3!:0 each y)#i.#y)}y
 y=. (<'-') ((1<;$@$each y)#i.#y)}y
 y=. ;(<' '),~each y
end.
if. 120<#y do. y=. '...',~120{.y end.
deb y
)
