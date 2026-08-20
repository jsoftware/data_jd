jdadminnew'tutorial'
jd'gen test f 5'
jd'key     f';'int';104 102
jd'key     f';'int';104 102 120
jd'key     f';'int';104 102 120;'byte';'ECx'  NB. _1 for not found
jd'key /in f';'int';104 102 120;'byte';'ECx'  NB. sorted - no _1
jd'key     f';'boolean';1 NB. last row that matches
jd'key /in f';'boolean';1 NB. all rows that match
