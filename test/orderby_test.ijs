NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. copied from tutorial reads with asserts added
jdadmin'sandp'
r=. jd 'reads weight,city from p order by weight,city'
assert 12 12 14 17 17 19-:,'weight'jdfroms_jd_ r
assert 'LPLOPL'-:{."1 'city'jdfroms_jd_ r

r=. jd 'reads weight,city from p order by weight,city desc'
assert 12 12 14 17 17 19-:,'weight'jdfroms_jd_ r
assert'PLLPOL'-:{."1 'city'jdfroms_jd_ r

r=. jd 'reads weight,city from p order by weight desc,city'
assert 19 17 17 14 12 12-:,'weight'jdfroms_jd_ r
assert'LOPLLP'-:{."1 'city'jdfroms_jd_ r

r=. jd 'reads weight,city from p order by weight desc,city desc'
assert 19 17 17 14 12 12-:,'weight'jdfroms_jd_ r
assert'LPOLPL'-:{."1 'city'jdfroms_jd_ r


