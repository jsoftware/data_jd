jdadminnew'tutorial'
jd'createtable f'
jd'createcol f a int'
jd'insert f a';12 13 14
jd'createcol f b int'          NB. default values
jd'createcol f d int';88 89 90 NB. values
jd'createcol f e int';101      NB. value
jd'createcol f "a/ =\" \b" int';23 24 25 NB. all chars are allowed
jd'reads from f'
jd'reads  from f where "a/ =\" \b"=24'
