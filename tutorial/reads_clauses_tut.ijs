jdadmin'sandp'

jd'reads from j'
jd'reads from p'
jd'reads from s'
jd'read from s' NB. read is reads flipped

NB. a query can have SELECT, FROM, WHERE, and ORDER
NB. [SELECT] from FROM [where WHERE] [order by ORDER]
NB. everything but FROM is optional

jd'reads * from j'          NB. SELECT * is all cols
jd'reads city from j'       NB. SELECT city
jd'reads city,color from p' NB. SELECT city and color 

NB. WHERE is a predicate for the rows to satisfy
NB.  it consists of relations like qty>100 or city="Paris"
NB.  which can be preceded by "not" and combined by "and" and "or"
NB.  operations execute as in J (right to left and can be parenthesized)
NB.  cols of compatible type can be compared

jd'reads from p where pname="Screw" or weight<14 and city="London"'
jd'reads from p where pname="Screw" or (weight<14 and city="London")'
jd'reads from p where (pname="Screw" or weight<14) and city="London"'
jd'reads from s where city in ("Athens","London")'
jd'reads from p where color is "Red"'
jd'reads from p where color = "Red"'
jd'reads from p where color eq "Red"'
[r=. jd'reads pname from p where pname like "C"'     NB. regex
assert 'CamCog'-:' '-.~,>{:r
[r=. jd'reads pname from p where pname likeci "C"'   NB. regex - case insensitives
assert 'ScrewScrewCamCog'-:' '-.~,>{:r
[r=. jd'reads pname from p where pname unlike "C"'   NB. regex
assert 'NutBoltScrewScrew'-:' '-.~,>{:r
[r=. jd'reads pname from p where pname unlikeci "C"' NB. regex
assert 'NutBolt'-:' '-.~,>{:r
jd'reads from p where weight range (11,14)' NB. In range, inclusive
jd'reads from p where weight range (11,12,16,18)' NB. Multiple ranges

NB. ORDER is col(s) to order by
NB.  col order ascending unless followed by "desc"

jd 'reads weight,city from p order by weight,city'
jd 'reads weight,city from p order by weight,city desc'
jd 'reads weight,city from p order by weight desc,city'
jd 'reads weight,city from p order by weight desc,city'

jd 'reads weight,city from p where weight>=17 or city is "London" order by city, weight desc'
