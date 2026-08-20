NB. ECSVBYTE0 tests - avoid crashes
CSVFOLDER=: '~temp/jd/csv'

bld=: 3 : 0
jdadminnew'test'
jd'createtable f'
jd'createcol f a byte 0'
jd'createcol f b byte 3'
jd'createcol f c int'
jd'insert f';'a';(10 0$'abc');'b';(10 3$'bcd');'c';i.10
jd'reads from f'
)

bld''
ECSVBYTE0_jd_ jdae'csvwr f.csv f' NB. crash avoided
