NB. Jd epochdt (epoch datetime) is nanoseconds from 2000-01-01
NB. utilities convert between epochdt and iso 8601 extended format

efs_jd_ '2000-01-01' NB. epochdt 0 is 2000-01-01
efs_jd_ '2105'       NB. nanoseconds from 2000 to 2105
efs_jd_ '1970-01-01' NB. negative for nanoseconds before 2000

assert IMIN_jd_=efs_jd_ '1700'  NB. canonical invalid date rather than error
assert IMIN_jd_=efs_jd_ '2300'  NB. canonical invalid date rather than error
assert IMIN_jd_=efs_jd_ '????'  NB. canonical invalid date rather than n_jd_eror

sfe_jd_ efs_jd_ '1970'

NB. iso 8601 examples
NB. -T:.,+- decorators required and validated
NB. . or , separates seconds from nanoseconds
a=: ><;._2 [ 0 : 0
2014-10-11T12:13:14.123456789+05:30
2014-10-11T12:13:14,123456789+05
2014-10-11T12:13:14.123456789
2014-10-11T12:13:14.123456789
2014-10-11T12:13:14.123
2014-10-11T12:13:14
2014-10-11T12:13
2014-10-11T12:13
2014-10-11T12+05
2014-10-11T12
2014-10-11
2014
)

[e=: efs_jd_ a NB. convert iso 8601 to epochdt

sfe_jd_ e NB. convert epochdt to iso 8601

(sfe_jd_ e),.' ',.a NB. epochdt converted to 8601 , original 8601


'. 9'sfe_jd_ e NB. . instead of , elide Z and nano
'. 3'sfe_jd_ e NB. milli

NB. efs can request different precisions
e=: efs_jd_ '2014-10-11T12:13:14.123456789'
assert 466344794123456789=e
e=: 'd' efs_jd_ '2014-10-11T12:13:14.123456789' NB. date
assert 466300800000000000=e
e=: '0' efs_jd_ '2014-10-11T12:13:14.123456789' NB. and time
assert 466344794000000000=e
e=: '3' efs_jd_ '2014-10-11T12:13:14.123456789' NB. and millis
assert 466344794123000000=e
e=: '9' efs_jd_ '2014-10-11T12:13:14.123456789' NB. and nanos
assert 466344794123456789=e

[t=. ', d' sfe_jd_ efs_jd_ '2015-01-22T00:00:00+02:00' NB. 2 hours subtracted to give utc
assert '2015-01-21'-:t

[t=. ', d' sfe_jd_ efs_jd_ '2015-01-22T00:00:00-02:00' NB. 2 hours added to give utc
assert '2015-01-22'-:t


NB. 0 1 0 efs y - ignore offset
NB. 0 1 0 efs_jd_ '2014-10-11T12:13:14+05'
NB. assert '2014-10-11T12:13:14'-:', t'sfe_jd_ 0 1 0 efs_jd_ '2014-10-11T12:13:14+05'

NB. 0 1 1 efs y - ignore offset and return offset
NB. [t=. 0 1 1 efs_jd_ '2014-10-11T12:13:14+05'
NB. assert t-:466344794000000000;300

NB. verify some edge conditions
t=. efs_jd_ '1800-01-01'
assert '1800-01-01T00:00:00,000000000'-:sfe_jd_ t
assert '?'={.sfe_jd_ t-1
assert '1800-01-01T00:00:00,000000001'-: sfe_jd_ t+1

t=. efs_jd_ '2200-12-31T23:59:59,999999999'
assert '2200-12-31T23:59:59,999999999'-:sfe_jd_ t
assert '2200-12-31T23:59:59,999999998'-:sfe_jd_ t-1
assert '?'={.sfe_jd_ t+1


NB. T or blank allowed as delimiter of time fields
assert (efs_jd_'2015-01-22T00:00:00+02:00')=efs_jd_'2015-01-22 00:00:00+02:00'
assert (efs_jd_'2015-01-22  ')=efs_jd_'2015-01-22'

NB. there are 4 epochdt col types - epochdt values are ints
NB. edatetimen yyyy-mm-ddThh:mm:ss,nnnnnnnnn
NB. edatetimem yyyy-mm-ddThh:mm:ss,nnn
NB. edatetime  yyyy-mm-ddThh:mm:ss
NB. edate      yyyy-mm-dd

NB. inserted data can be in iso 8601 format or in epochdt ints
NB. inserted data is validated to not have extra precision
NB. read of epochdt data is formatted to iso 8601 (unless reads with /e)

NB. edatetimen nano
jdadminx'test'
jd'createtable f a edatetimen' NB. epoch with nanos
jd'insert f a';a               NB. conversion done in Jd
jd'insert f a';efs_jd_'2016'   NB. conversion done in client
jd'insert f a';'2017'
jd'reads from f'
jd'reads from f where a="2014"'
[a=: jd'reads from f where a in ("2014","2017")'
d=. (":efs_jd_ '2014',:'2017')rplc ' ',','
b=: jd'reads from f where a in (',d,')'
assert a-:b
[a=: jd'reads from f where a>"2014-10-11T12:13:14"' 
b=: jd'reads from f where a>466344794000000000' 
assert a-:b

assert 'domain error'-:jd etx 'reads from f where a>2014-10-11T12:13:14' NB. string not in quotes
assert 'domain error'-:jd etx 'reads from f where a=2014-09-30' NB. string not in quotes

[efs_jd_ '2014-10-11T12:13:14'
jd'reads from f where a>466344794000000000'
jd'reads max a from f'
assert ('2017-01-01T00:00:00,000000000')-:,;{:jd'reads max a from f'

jd'reads from f where jdindex<3' NB. default is , sep and no Z mark for utc
c=. jdgl_jd_'f a'
sep__c=: '.' 
utc__c=: 'Z'
NB. sep and utc are persistent column attributes
jd'reads from f where jdindex<3' NB. . sep and no Z

jd'reads /e from f where jdindex<3' NB. epoch int rather than iso8601
jd'get f a'         NB. raw column data

NB. edatetimem milli
jdadminx'test'
jd'createtable f a edatetimem' NB. epoch with milli
jd'insert f a';'2014-10-11T12:13:14'
jd'insert f a';'2014-10-11T12:13:14,123'
'domain error'-:jd etx 'insert f a';'2014-10-11T12:13:14,123456' NB. extra precision is an error
'domain error'-:jd etx 'insert f a';efs_jd_ '2014-10-11T12:13:14,123456'
jd'reads from f'

NB. edatetime
jdadminx'test'
jd'createtable f a edatetime' NB. epoch with nano
jd'insert f a';'2014-10-11T12:13:14'
'domain error'-:jd etx 'insert f a';'2014-10-11T12:13:14,123' NB. extra precision is an error
'domain error'-:jd etx 'insert f a';efs_jd_'2014-10-11T12:13:14,123'
'domain error'-:jd etx 'insert f a';'2014-10-11T12:13:14,123',:'2014'

NB. edate
jdadminx'test'
jd'createtable f a edate'
jd'insert f a';'2014-10-11',:'2015-01-01'
'domain error'-:jd etx 'insert f a';'2015-10-11T12:13:14' NB. extra precision is an error
'domain error'-:jd etx 'insert f a';efs_jd_ '2015-10-11T12:13:14'
jd'reads from f where a>"2014-10-11T10:11:11"' NB. extra precision allowed in where clause
jd'reads from f'

NB. by year from temp col derived from edatetimen col
jdadminx'test'
jd'createtable f a edatetimen'
'a b'=: efs_jd_ '2014-09-10',:'2016-10-11'
d=. <.(b-a)%10
m=. a+d*i.10 NB. 10 random between a and b
jd'insert f a';m
jd'reads from f'
jd'createcol f b int _';>:i.10


NB. by year from permanent year col
jd'createcol f y byte 4';4{."1 sfe_jd_ jd'get f a' NB. column of year
jd'reads from f'
jd'reads sum b by y from f'

NB. jdadminx'test'
NB. jd'createtable f a edatetimen, a_offset int'
NB. jd'insert f';,(;:'a a_offset'),.a
NB. [a=: jd'reads from f'

NB. csv
jdadminx'test'
CSVFOLDER=: F=: jpath'~temp/jd/csv/junk/'
jdcreatefolder_jd_ F

a=: 0 : 0
2014-01-02T03:04:05+05:30
2014-02-03T10:11:12,123456789-05:30
)

adef=: 0 : 0
1 dt8601 byte 36
options TAB LF NO \ 0
)

(toJ a) fwrite F,'a.csv'
adef fwrite F,'a.cdefs'

jd'csvrd a.csv c'
[a=. jd'reads from c'
