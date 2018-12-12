NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

len=: 10
bgn=: efs_jd_ '2015-11-20'

jdadminnew'test'

f=: 3 : 0
jd 'createtable tab'
jd 'createcol tab Measure int _';len $2 3 4
jd 'createcol tab Usage float _';len $o. 2 3 4
jd 'createcol tab RecordTS edatetimem _';bgn + 864e11 * len$0 1 2
jd 'createcol tab RE byte 10';>len$;:'one two three four'
)
f''
jd 'reads from tab'
NB. dates are all the same so use in following order by does not make a difference
jd 'reads sum Usage by RecordTS,RE from tab where Measure=3'
jd 'reads sum Usage by RE,RecordTS from tab where Measure=3'

NB. enhance this test with different dates are validation of results
