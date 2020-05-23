0 : 0
derived_mapped col:
 calculated - a row value is usually derived from the same row values in other cols
 mapped (backed by a file)
 not allowed in insert/upsert/update/... pairs
 allowed in ref
 not allowed in a ptable
 
 calculated with verb derived_mapped_xxxx defined in custom.ijs
  xxxx is from jd'createcol /dervied_mapped col type [trailing shape] xxxx'
  
 csv dumps data (not derived_xxxx verb)
 jdloadcustom loads changes to custom.ijs to db locale

)

jdadminnew'test'
jd'createtable f'
jd'createcol f b byte 4'
jd'createcol f e  edate'
jd'insert f';'b';(3 4$'abcdef');'e';'2014-10-12','2015-10-13',:'2016-10-14'
jd'reads from f'

NB. defns to return values for derived_mapped cols are
NB. defined in db custom.ijs and are loaded into the db locale
jdloadcustom_jd_ 0 : 0 rplc'RPAREN';')' NB. defns for derived_mapped verbs - 
derived_mapped_foo=: 3 : 0
2{."1 'b' jddmfrom y
RPAREN

derived_mapped_goo=: 3 : 0
0".4{."1 sfe 'e' jddmfrom y
RPAREN
)

0 : 0
col jddmfrom pairs - gets values from pairs arg to insert and upsert
col jddmfrom rows  - gets values from col dat for update
)

jd'createcol /derived_mapped f catg byte 2 foo' NB. derived_mapped_foo in custom.ijs
jd'createcol /derived_mapped f year int goo'    NB. derived_mapped_goo in custom.ijs
jd'reads from f'

jd'info derived'
jd'info derived f catg'

jd'insert f';'b';'qwer';'e';'2017-12-13' NB. derived_mapped cols not in pairs
jd'reads from f'

jd'insert f';'b';(2 4$'abc');'e';'2018-12-13' NB. derived_mapped cols not in pairs
jd'reads from f'

jd'upsert f';'b';'b';('efab',:'newx');'e';'2012',:'2020'
jd'reads from f'

NB. update finishes update with supplied data
NB. then derives new values for derived_mapped cols from the db rows
jd'update f';'b="qwer"';'e';'2011'
jd'reads from f'

jd'update f';'b';'b';'cdef';'e';'2013' NB. update with key
jd'reads from f'

jd'update f';'year';'year';2013;'e';'2021' NB. derived_mapped col can be in key
jd'reads from f'

jd'delete f';jd'delete f';jd'key /in f';'year';2018
jd'reads from f'

'expected result from previous steps' assert 2014 2012 2021 2011 2020-:'year'jdfrom_jd_ jd'read from f'

NB. changing a derived_mapped defn requires care
jdloadcustom_jd_ 0 : 0 rplc'RPAREN';')' NB. defns for derived_mapped verbs
derived_mapped_foo=: 3 : 0
_2{."1 'b' jddmfrom y
RPAREN
)
jd'reads from f' NB. catg col still has old values

NB. an easy way to apply the new defn is to drop the col and create it again
jd'dropcol f catg'
jd'createcol /derived_mapped f catg byte 2 foo'
jd'reads from f' NB. note new catg values


NB. derived_mapped_verb errors
jdloadcustom_jd_ 0 : 0 rplc'RPAREN';')' NB. defns for derived_mapped verbs
derived_mapped_foo=: 3 : 0
+a.[_2{."1 'b' jddmfrom y
RPAREN
)
jd'reads from f' NB. still has previous values - calc not run yet

'domain'jdae'insert f';'b';'1234';'e';'1997' NB. error in new defn
jd'reads from f' NB. error detected before any change to db

'domain'jdae'update f';'b="abcd"';'b';'asdf' NB. error in new defn
jd'reads from f' NB. db updated before error detected

jd'dropcol f catg'
'domain'jdae'createcol /derived_mapped f catg byte 2 foo' NB. error
jd'reads from f' NB. catg col is default blanks as derived_mapped verb had error

jdloadcustom_jd_ 0 : 0 rplc'RPAREN';')' NB. fix error
derived_mapped_foo=: 3 : 0
1 2{"1 'b' jddmfrom y
RPAREN
)

NB. derived_mapped col values can be validated by comparing with fresh calculation
jd'createcol /derived_mapped f test byte 2 foo' NB. col test will get calculated values
a=. jd'read test from f'
b=. jd'read catg:test from f'


jd'dropcol f catg'
jd'createcol /derived_mapped f catg byte 2 foo' NB. error
jd'reads from f' NB. catg col is default blanks as derived_mapped verb had error

CSVFOLDER=: '~temp/jd/csv'
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert (jd'reads from f')-:jd'reads from g'
jd'info derived' NB. g does not have derived_mapped cols
