CONTEXT=: 'jbin jbin http u/p;' NB. default x
msr'dropdb'
msr'createdb'
msr'createtable f'
msr'createcol f a int'
msr'insert f';'a';2 3
msr'read from f'
'json json http u/p;' msr 'read from f'
wget'read from f'
wget'insert f';'a';6
wget'read from f'
curl'read from f'
