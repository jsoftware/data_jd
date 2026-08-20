NB. how to update several records at once

jdadminx'test'

jd'droptable GC'
jd'createtable GC';'ID int';'Name byte 20';'Town byte 30'
jd'insert GC';'ID';10 14 17 18 22 42;'Name';(20{."1>'Porsche';'Mercedes';'BWM';'VW';'Opel';'Maybach');'Town';30{."1>'Stuttgart';'Stuttgart';'Munich';'Wolfsburg';'Ruesselsheim';'Where?'

jd'reads from GC'

NB. Single update of Town for Mercedes, ID=14
jd'update GC';'ID=14';'Town';,:30{.'Stuttgart-Untertuerkheim'

jd'reads from GC'

jd'reads from GC order by ID'

NB. Let us update the single column "town" for three records at once
NB. IDs are, respectively: 42, 10, and 18 for Maybach, Porsche, VW
]upd_town=:'Town';3 30{.>'Sindelfingen';'Stuttgart-Zuffenhausen';'Wolfsburg-Autostadt'

jd'update GC';'ID in 42, 10, 18';upd_town

jd'reads from GC'

empty 0 : 0
Oops, that is not what we had in mind!
when doing a bulk update it is mandatory to pass
data to the update according to the
sequence in which they show up in an unsorted read
)

NB. Delete the whole table
jd'delete GC';'ID<>0'

NB. Build it again
jd'insert GC';'ID';10 14 17 18 22 42;'Name';(20{."1>'Porsche';'Mercedes';'BWM';'VW';'Opel';'Maybach');'Town';30{."1>'Stuttgart';'Stuttgart';'Munich';'Wolfsburg';'Ruesselsheim';'Where?'
jd'reads from GC'

empty 0 : 0
prior to updating data, read the affected records
order of IDs in where does not affect order of records in result
)

]db=.jd 'read ID from GC where ID in 18,10,42'
]db=.jd 'read ID from GC where ID in 42,10,18'

NB. Update records as before
]upd_town=:'Town';3 30{.>'Sindelfingen';'Stuttgart-Zuffenhausen';'Wolfsburg-Autostadt'

NB. The update IDs are, respectively: 42, 10, and 18
upd_IDs=.42 10 18

sort_order=.upd_IDs i. 0 1{::db

jd'update GC';'ID in 42, 10, 18';,(0{upd_town),.((<sort_order){each 1{upd_town)

jd'reads from GC'

