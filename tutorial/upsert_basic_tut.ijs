
jdadminnew'tutorial'
jd'createtable /pairs f';'a';0 1 2 3 4;'b';23 24 25 26 27
jd'reads from f'
NB. upsert based on key a
jd'upsert f';'a';'a';2 5 6;'b';66 77 88 NB. 1 update and 2 inserts
jd'reads from f'
jd'createcol f c byte';'abcdefg'
jd'reads from f'
NB. upsert based on key a b
jd'upsert f';'a b';'a';2 5 6;'b';66 _100 1000;'c';'xyx' NB. 1 update and 2 inserts
jd'reads from f'
