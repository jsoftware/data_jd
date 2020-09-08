NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. createcol names with osfna (os folder not allowed) and blanks

'new'jdadmin'osfna'

chkcco=: 3 : 0
a=. {.jd'reads from ',y
t=. jdgl_jd_ y
b=. <;._2 cco_read__t''
b=. (-.;(6{.each b)=<'jdref_')#b NB. remove jdrefs
'bad cco'assert a-:b
)

cols=: <;._2 [ 0 : 0
a
aa
"b"
"bb"
/
a/b
"a b"
"a\"b"
"\"\""
)

idata=.  ((<:#cols)$<i.3),<6
tidata=. ((<:#cols)$<i.3),<6 6 6
vdata=.  ((<:# cols)#<'abc';'def';'ghijkl'),<<'qewr'
tvdata=. ((<:# cols)#<'abc';'def';'ghijkl'),<3#<'qewr'

jd'createtable /replace f ',;cols,each<' int',LF
jd'info schema'
s=. dtb each <"1 'column' jdfroms_jd_ jd'info schema'
assert s-:jdremq_jd_ each cols
jd'insert f';,cols,.idata
assert tidata-:{:"1 jd'read from f'

jd'createtable /replace f ',;cols,each<' varbyte',LF
jd'info schema'
s=. dtb each <"1 'column' jdfroms_jd_ jd'info schema'
assert s-:jdremq_jd_ each cols
jd'insert f';,cols,.vdata
assert tvdata-:{:"1 jd'read from f'

jdcsvfolder_jd_'' NB. create CSVFOLDER in DB folder for metadata
jd'csvwr f.csv f'
jd'droptable q'
jd'csvrd f.csv q'
assert (jd'read from f')-:jd'read from q'
jd'droptable q'

jd'createtable /replace f ',;cols,each<' int',','
jd'info schema'
s=. dtb each <"1 'column' jdfroms_jd_ jd'info schema'
assert s-:jdremq_jd_ each cols
jd'insert f';,cols,.idata
assert tidata-:{:"1 jd'read from f'

jd'createtable /replace f'
jd each   (<'createcol f '),each cols,each <' int'
s=. dtb each <"1 'column' jdfroms_jd_ jd'info schema'
assert s-:jdremq_jd_ each cols
jd'insert f';,cols,.idata
assert tidata-:{:"1 jd'read from f'

NB. explicit createcol
bld1=: 3 : 0
jd'createtable /replace f'
jd'createcol f a/b int'
jd'createcol f "a/ \b" int'
jd'createcol f "\" q" byte 3'
jd'insert f';'a/b';2 3 4;'a/ \b';2 3 4;'"\" q"';3 3$'adbc'
)

NB. createcol string as createtable arg
bld2=: 3 : 0
jd'createtable g a/b int,"a/ \b" int,"\" q" byte 3'
jd'insert g';'a/b';2 3 4;'a/ \b';2 3 4;'"\" q"';3 3$'adbc'
)

NB. createcol box as createtable arg
bld3=: 3 : 0
jd'createtable';'h';'a/b int,"a/ \b" int,"\" q" byte 3'
jd'insert h';'a/b';2 3 4;'a/ \b';2 3 4;'"\" q"';3 3$'adbc'
)

NB. createcol boxes as createtable arg
bld4=: 3 : 0
jd'createtable';'i';'a/b int';'"a/ \b" int';'"\" q" byte 3'
jd'insert i';'a/b';2 3 4;'a/ \b';2 3 4;'"\" q"';3 3$'adbc'
)

bld1''
jd'read a/b from f'
jd'read "a/b" from f'
jd'read "a/  \b" from f'
jd'read "\" q" from f'
jd'read from f'
assert ('a/b';'a/ \b';'" q')-:{.jd'reads from f'
assert ('a/b';'a/ \b';'" q')-:{.jd'reads a/b,"a/ \b","\" q" from f'
chkcco'f'
'invalid name' jdae'createcol f jdfoo int'

data=.jd'reads from f where a/b=2'
assert data-:jd'reads from f where "a/b"=2'
assert data-:jd'reads from f where "a/ \b"=2'
assert data-:jd'reads from f where "a/b","a/ \b"=2,2'
assert data-:jd'reads from f where "a/b","a/ \b"=2,2 or a/b=2'
assert data-:jd'reads from f where "a/b","a/ \b"=2,2 and "a/b"=2'

NB. by
jd'insert f';'a/b';2 3 4;'a/ \b';2 3 4;'" q';3 3$'adbc'
jd'reads sum a/b by "a/b" from f'
[a=. jd'read "by sum":sum a/b by a/b from f'
assert 4 6 8-:'by sum'jdfrom_jd_ a
[a=. jd'read "by sum":sum "a/ \b" by "a/ \b",a/b from f'
assert 4 6 8-:'by sum'jdfrom_jd_ a

NB. key
assert 0 2-:jd'key f';'a/b';2 4
assert 0 2 3 5-:jd'key /in f';'a/b';2 4
assert 0 2 3 5-:jd'key /in f';'a/b';2 4;'a/ \b';2 4

NB. update
bld1''
[a=. jd'reads from f'
jd'update f';'"a/ \b"=3';'a/ \b';23
jd'update f';'"a/ \b"=23';'a/ \b';3
assert a-:jd'reads from f'

NB. upsert
jd'upsert f';'a/b';,jd'read from f'
jd'upsert f';'"a/b"';,jd'read from f'
jd'upsert f';'"a/b" "a/ \b"';,jd'read from f'
'not found'jdae'upsert f';'"a/b" "x/d \b"';,jd'read from f'

bld1''
jd'delete f';0
data=. jd'reads from f'

bld1''
jd'delete f a/b=2'
assert data-:jd'reads from f'

bld1''
jd'delete f "a/b"=2'
assert data-:jd'reads from f'

bld1''
jd'delete f "\" q"="adb"'
assert data-:jd'reads from f'

bld1''
jd'delete f';jd'key f';'a/b';3
[a=. jd'reads from f'
bld1''
jd'delete f';jd'key f';'a/b';3;'a/ \b';3
[b=. jd'reads from f'
assert a-:b

bld1''
jdadmin 0
jdadmin 'osfna'
assert ('a/b';'a/ \b';'" q')-:{.jd'reads from f'
chkcco'f'

bld2''
assert (jd'reads from f')-:jd'reads from g'
chkcco'g'

bld3''
assert (jd'reads from f')-:jd'reads from h'
chkcco'h'

bld4''
assert (jd'reads from f')-:jd'reads from i'
chkcco'i'

jd'renamecol f a/b foo'
jd'renamecol f foo a/b'
jd'renamecol f a/b "how now"'
jd'renamecol f "how now" "a/b"' NB. same cco as name is reused
assert (jd'reads from f')-:jd'reads from i'
chkcco'f'

jd'renamecol';'f';'a/ \b';'_temp_col_during_type_change'
jd'renamecol';'f';'_temp_col_during_type_change';'a/ \b'
chkcco'f'

jd'dropcol f a/b'
jd'dropcol f "a/ \b"'
chkcco'f'
jd'dropcol f "\" q"'
assert 0 2-:$jd'read from f'
chkcco'f'

bld1''
jd'intx f a/b int1'
assert ('a/b';'a/ \b';'" q')-:{.jd'reads from f'
jd'intx f "a/ \b" int1'
assert ('a/b';'a/ \b';'" q')-:{.jd'reads from f'
chkcco'f'

jd'byten f "\" q" 3'
chkcco'f'

bld1''
jdcsvfolder_jd_'' NB. create CSVFOLDER in DB folder for metadata
jd'csvwr f.csv f'
jd'droptable q'
jd'csvrd f.csv q'
assert (jd'read from f')-:jd'read from q'

jd'csvwr /h1 f.csv f'
jd'droptable q'
jd'csvrd f.csv q'
assert (jd'read from f')-:jd'read from q'

jd'csvdump /replace'
a=. jd'reads from f'
jd each (<'droptable '),each<"1>{:jd'info table' NB. droptable each table
jd'csvrestore'
assert a-:jd'reads from f'
NB. csvrestore /replace will not work as csvfolder is in the db

NB. ref tests
dropref=: 3 : 0
jd'dropcol f';,;{:{:jd'info ref'
)

renames=: 4 : 0
old=. {.jd'reads from ',y
new=. (<x),each old
for_i. i.#old do.
 jd('renamecol ',y);(i{old),i{new
end. 
)

'new'jdadmin'osfna'
jd'gen ref2 f 10 3 g 3'
jd'reads from f,f.g'

dropref''
jd'ref f aref g bref'
data=. {:jd'reads from f,f.g'

dropref''
'/'renames'f'
'/'renames'g'
jd'ref f /aref g "/bref"'
assert data-:{:jd'reads from f,f.g'
chkcco'f'
chkcco'g'

dropref''
jd'droptable f'
jd'droptable g'
jd'gen ref2 f 10 3 g 3'
dropref''
'/ _'renames'f'
'/ _'renames'g'
'not allowed'jdae'ref f "/ _aref" g "/ _bref"'

dropref''
jd'droptable f'
jd'droptable g'
jd'gen ref2 f 10 3 g 3'
dropref''
'/ 'renames'f'
'/ 'renames'g'
jd'ref f "/ aref" g "/ bref"'
assert data-:{:jd'reads from f,f.g'
chkcco'f'
chkcco'g'

NB. alias

[a=. jd'reads abc:"/ akey" from f'
[b=. jd'reads "abc":"/ akey" from f'
assert a-:b

[a=. jd'reads abc:"/ akey" from f where abc=2'
[b=. jd'reads "abc":"/ akey" from f where "abc"=2'
assert a-:b
[a=. jd'reads "abc def":"/ akey" from f where "abc def"=2' 
assert a-:,.'abc def';1 1$2

[a=. jd'reads "abc def":"/ akey" from f where f."abc def"=2' 
assert a-:,.'abc def';1 1$2

[a=. jd'reads "abc def":"/ akey" from newn:f where newn."abc def"=2' 
assert a-:,.'abc def';1 1$2

[a=. jd'reads "abc def":"/ akey","g boo":g."/ bref" from f,f.g'

[a=. jd'reads "abc def":"/ akey","g boo":g."/ bref" from f,f.g where g."/ bref"=2'
[b=. jd'reads "abc def":"/ akey","g boo":g."/ bref" from f,f.g where g."g boo"=2'
assert a-:b

[b=. jd'reads "abc def":"/ akey","g boo":g."/ bref" from fff:f,fff.g where g."g boo"=2'
assert a-:b

'table.alias'jdae'reads "abc def":"/ akey","g boo":g."/ bref" from f,f.g where "g boo"=2'


dropref''
bld1''
a=. jd'get f "a/ \b"'
jd'set f "a/ \b"';|.a
b=. jd'get f "a/ \b"'
assert a-:|.b
jd'set f "a/ \b"';|.a

jd'droptable f'
bld1''
[a=. jd'reads from f'
jd'sort f a/b'
[b=. jd'reads from f'
assert a-:b
jd'sort f "a/b" desc'
assert -.a-:jd'reads from f'
jd'sort f "a/b"'
assert a-:jd'reads from f'
jd'sort f "\" q" desc , "a/ \b" desc'
jd'sort f "\" q"      , "a/ \b"     '
assert a=.jd'reads from f'

NB. table...
bld1''
a=. jd'reads from f'
'new'jdadmin'test'
jd'tablecopy q f osfna'
assert a-:jd'reads from q'

jd'delete q';'jdindex>=0'
jd'tableinsert q f osfna'
assert a-:jd'reads from q'

jd'droptable q'
jd'tablemove q f osfna'
assert a-:jd'reads from q'

NB. derived mapped col

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

jd'createcol /derived_mapped f "byte /" byte 2 foo' NB. derived_mapped_foo in custom.ijs
jd'createcol /derived_mapped f "/ int" int goo'     NB. derived_mapped_goo in custom.ijs
jd'reads from f'

jd'info derived'
jd'info derived f "byte /"'

NB. derived col
'new'jdadmin'test'
jd'createtable f'
jd'createcol f "byte 4" byte 4'
jd'createcol f "/edate" edate'
jd'insert f';'byte 4';(3 4$'abcdef');'/edate';'2014-10-12','2015-10-13',:'2016-10-14'
jd'reads from f'

jd'createcol /derived f "byte 2" byte 2 vcatg' NB. vcatg verb used to derive col
jd'createcol /derived f "/year"  int    vyear' NB. vyear verb used to derive col

custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verbs
derived_vcatg=: 3 : 0
2{."1 jd_get'f';'byte 4'
RPAREN

derived_vyear=: 3 : 0
0".4{."1 sfe jd_get'f';'/edate'
RPAREN
)
custom fwrite jdpath_jd_'custom.ijs'   NB. add derive verbs to custom.ijs
jdloadcustom_jd_'' NB. load changes

jd'reads from f'