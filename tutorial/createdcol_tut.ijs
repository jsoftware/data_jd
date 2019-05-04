
0 : 0
derived col:
 calculated - usually from another col
 not mapped (not backed by a file)
 can't be updated by insert etc.
 can be used in ref
 not currently allowed in a ptable
)

jdadminnew'test'
jd'createtable f'
jd'createcol f b byte 4'
jd'createcol f e  edate'
jd'insert f';'b';(3 4$'abcdef');'e';'2014-10-12','2015-10-13',:'2016-10-14'
jd'reads from f'

jd'createdcol f catg byte 2 vcatg ' NB. vcatg verb used to derive col
jd'createdcol f year int vyear'      NB. vyear verb used to derive col
'value error'jdae'reads from f'      NB. derive verbs not defined
jdlast NB. last error indicates table and col

custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verbs
derive_vcatg=: 3 : 0
2{."1 jd_get'f b'
RPAREN

derive_vyear=: 3 : 0
0".4{."1 sfe jd_get'f e'
RPAREN
)
custom fappend jdpath_jd_'custom.ijs'   NB. add derive verbs to custom.ijs

jd'close' NB. open after close will load custom.ijs to get new defns
jd'reads from f'

CSVFOLDER=: '~temp/jd/csv'
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert (jd'reads from f')-:jd'reads from g'
jd'info derived'
jd'info derived f'
jd'info derived f catg'
