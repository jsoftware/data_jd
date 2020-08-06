NB. derived col

0 : 0
derived col
 values calculated = usually from another col
 not mapped
 allowed in ref
 not allowed in a ptable
 calculated when first referenced
 not allowed in insert/upsert/update/... pairs

 calculated with verb derived_mapped_xxxx defined in custom.ijs
  xxxx is from jd'createcol /derived col type [trailing shape] xxxx'

 csv dumps data (not derived_xxxx verb)
 jdloadcustom loads changes to custom.ijs to db locale
 
 mark dirty whenever a dependency might have changed
 mark dirty is agressive - e.g. in perhaps most case sort would be ok
 but instead sort does not sort derived and marks them dirty
 sort/dropcol/delete all mark derived dirty
)

jdadminnew'test'
jd'createtable f'
jd'createcol f b byte 4'
jd'createcol f e  edate'
jd'insert f';'b';(3 4$'abcdef');'e';'2014-10-12','2015-10-13',:'2016-10-14'
jd'reads from f'

jd'createcol /derived f catg byte 2 vcatg ' NB. vcatg verb used to derive col
jd'createcol /derived f year int vyear'      NB. vyear verb used to derive col
'value error'jdae'reads from f'      NB. derive verbs not defined
jdlast NB. last error indicates table and col

custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verbs
derived_vcatg=: 3 : 0
2{."1 jd_get'f b'
RPAREN

derived_vyear=: 3 : 0
0".4{."1 sfe jd_get'f e'
RPAREN
)
custom fappend jdpath_jd_'custom.ijs'   NB. add derive verbs to custom.ijs
jdloadcustom_jd_'' NB. load changes

jd'reads from f'

CSVFOLDER=: '~temp/jd/csv'
jd'csvwr f.csv f'
jd'csvrd f.csv g'
assert (jd'reads from f')-:jd'reads from g'
jd'info derived'
jd'info derived f'
jd'info derived f catg'
