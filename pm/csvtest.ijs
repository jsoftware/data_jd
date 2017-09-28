NB. try to reproduce Jd bug - jdmap failed

CSVFOLDER=: '~temp/jd/csv/test'
csvfile=:   CSVFOLDER,'/f.csv'
csvfolder=: jpath'~temp/jd/new/csv' NB. temp folder for csv loader
jdfolder=:  jpath'~temp/jd/testcsv/a' 

NB. createcsv 101
createcsv=: 3 : 0
jddeletefolder_jd_ CSVFOLDER
jdadminx'testcsv'
jd'createtable f'
jd'createcol f c1 byte  64';'abc'$~y,64
jd'createcol f c2 byte   8';'abc'$~y,8
jd'createcol f c3 byte  10';'abc'$~y,10
jd'createcol f c4 byte   2';'abc'$~y,2
jd'createcol f c5 byte  64';'abc'$~y,64
jd'createcol f c6 byte   1';'abc'$~y,1
jd'createcol f c7 byte  64';'abc'$~y,64
jd'createcol f c8 byte  64';'abc'$~y,64
jd'createcol f c9 byte  11';'abc'$~y,11
jd'createcol f c10 byte 11';'abc'$~y,11
jd'createcol f c11 byte  8';'abc'$~y,8
jd'createcol f c12 byte  8';'abc'$~y,8
jd'createcol f c13 byte  8';'abc'$~y,8
jd'csvdump'
)

NB. build 31
build=: 3 : 0
csvreportclear_jdcsv_''
csvdefs_jdcsv_ fread CSVFOLDER,'/f.cdefs'
csvload_jdcsv_ csvfolder;csvfile;0  NB. csvfolder files <- csvfile
for_i. i.<:y do.
 echo 'csvappend: ',":>:i
 csvappend_jdcsv_ csvfolder;csvfile;0
end.
jdadminx'testcsv'
jdfromcsv_jdcsv_ jdfolder;csvfolder
jd'info summary'
)

small=: 3 : 0
createcsv 101
build 31
)

big=: 3 : 0
createcsv 1+13e6
build 31
)

mactest=: 3 : 0
csvreportclear_jdcsv_''
csvdefs_jdcsv_ fread CSVFOLDER,'/f.cdefs'
csvload_jdcsv_ csvfolder;csvfile;y  NB. csvfolder files <- csvfile
csvreport_jdcsv_''
)


NB. x... simple csvappend tests

csvfile1=:   CSVFOLDER,'/f1.csv'
csvfile2=:   CSVFOLDER,'/f2.csv'

xcreatecsv=: 3 : 0
jddeletefolder_jd_ CSVFOLDER
jdadminx'testcsv'
jd'createtable f1'
jd'createcol f1 c1 int _';i.y
jd'createtable f2'
jd'createcol f2 c1 int _';1e9+i.y
jd'csvdump'
)

xbuild=: 3 : 0
csvreportclear_jdcsv_''
csvdefs_jdcsv_ fread CSVFOLDER,'/f1.cdefs'
csvload_jdcsv_ csvfolder;csvfile1;0  NB. csvfolder files <- csvfile
csvappend_jdcsv_ csvfolder;csvfile2;0
jdadminx'testcsv'
jdfromcsv_jdcsv_ jdfolder;csvfolder
jd'info summary'
)
