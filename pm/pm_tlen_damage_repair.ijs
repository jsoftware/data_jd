0 : 0
4.41 removed getdb fread to validate database class
 and fexist for jddamage and jdrepair files

4.42 replaced insert writestate for Tlen with jdtlen mapped file

git/jd_old/jd_4.40 and jd_4.41 used for performance comparisons
)

bld=: 3 : 0
'new'jdadmin'test'
jd'createtable f'
for_i. i.y do.
 jd'createcol f c',(":i),' int'
end.
pairs=: ,(,.'c',each ":each i.y),.<23 
)

run=: 3 : 0
bld 10
r=. ''
r=. r,   timex'jd''insert f'';pairs'
r=. r,   timex'jd''insert f'';pairs'
r=. r,3  timex'jd''insert f'';pairs'
r=. r,   timex'0[jd''read c0 from f'''
r=. r,   timex'0[jd''read c0 from f'''
r=. r,3  timex'0[jd''read c0 from f'''
r=. ('jd','.'-.~jd'list version'),'=: ',":r
".r
r
)

