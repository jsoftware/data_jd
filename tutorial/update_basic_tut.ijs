
jdadminnew'tutorial'
jd'gen test f 5'
jd'reads from f'
jd'update f';2 4;'int';200 300      NB. update rows 2 4
jd'reads from f'
jd'update f';_;'float';7.7          NB. update all rows
jd'reads from f'
jd'update f';'boolean=1';'byte';'x' NB. update where
jd'reads from f'
NB. update based on key int
jd'key f';'int';101 200 NB. last match for each key
jd'update f';'int';'int';101 200;'byte';'qQ'
jd'reads from f'
NB. update based on key float,boolean
jd'key f';'float';7.7;'boolean';1 0 NB. last match key
jd'update f';'float boolean';'float';7.7;'boolean';1 0;'byte';'45'
jd'reads from f'
'i b'=: {:"1 jd'read jdindex,boolean from f where int < 104'
jd'update f';i;'boolean';-.b NB. modify with indexes
