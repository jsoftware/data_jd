
jdadminnew'tutorial'
jd'droptable f'                                 NB. droptable if it exists
jd'createtable f'
'already exists'jdae'createtable f'             NB. accept expected error
jd'createtable /replace f'                      NB. droptable first if it exists
jd'createtable /replace f'                      NB. no  coldefs                    
jd'createtable /replace f a int'                NB. one coldef
jd'createtable /replace f a int,b byte 3'       NB. ,  delimited coldefs 
jd'createtable /replace f a int',LF,'b byte 3'  NB. LF delimited coldefs
jd'createtable /replace f';'a int';'b byte 3'   NB. boxed coldefs
jd'createtable /replace /a 10000 2 0 f'         NB. resize allocation values
jd'createtable /replace /pairs f';'a';2 3;'b';2 3$'abcdef' NB. pairs - coldefs and data
jd'createtable /replace /types /pairs f';'a(edate)';'1990-12-02';'b(float)';23
'access'jdadmin'' NB. tutorial end - you may want to access another dan
