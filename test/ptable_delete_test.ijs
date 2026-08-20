NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

require JDP,'tools/ptable.ijs'

gc=: 3 : 0
>{:{:jd'read count p from f'
)

gu=: 3 : 0
>{:{:jd'read u from f'
)

guw=: 3 : 0
if. 0=L.y do.
 >{:{:jd'read u from f where ',y
else.
  r=. jd'key /in f';y
  >{:{:jd'read u from f where jdindex in (',((":r)rplc' ';','),')'
end.
)

chk=: 3 : 0
v=. (gu'')-.guw y
jd'delete ptab';y
jd'delete f';y
assert (jd'reads from ptab')-:jd'reads from f'
assert v-:gu''
assert (#v)=gc''
)

ptablebld'int'

chk'val=14'
chk'jdindex in (4,21)'
chk'p';2015;'u';12 16
chk'p';2015 2015 2016 2016;'u';13 15 22 25
chk'jdindex in (2,6,9,12)'

ptablebld'int'
chk'val=14 or val=8'
chk'jdindex in (21,4)'
chk'p';2015;'u';16 12
chk'p';2016 2016 2015 2015;'u';25 22 15 13
chk'jdindex in (12,9,6,2)'

ptablebld'int'
chk'p';2015;'val';8 NB. delete multiple rows - keyin
chk'p';2016 2015;'val';6 8
chk'p';2014 2015;'val';14 8


