fix_tlen_man=: 0 : 0
Tables used with 4.42 will be marked damaged if used with previous versions.

Previous versions stored table row count (Tlen) in table jdstate file.
In 4.42 Tlen has been removed from jdstate and is in jdtlen mapped file.
A performance improvement, but makes it difficult to revert to earlier version.

Run this verb with the path to the jd folders to fix:
 move jdtlen values to jdstate files
 
  >start J - do not load Jd
   load ' path to Jd 4.42 or later folder ','/tools/fix_tlen.ijs'
   fix_tlen '' NB. display this help
   fix_tlen ' path to folder with tables to fix' NB. for example, '~temp/jd'
  >shutdown J
  >start J and load Jd (version prior to 4.42)
  > should be OK now
  > databases marked damaged because of this problem can be fixed
   jdrepair 'tlen was fixed'
   jddamage '' NB. db is probably OK now
)

fix_tlen=:3 : 0
if. ''-:y do. fix_tlen_man return. end.
'y used as path to jd folders to fix'assert 0~:#y
if. (<'jd')e.conl 0 do. jdadmin 0[jd'close' end. NB. avoid conflict if Jd is loaded
d=. {."1 dirtree y
k=. '/jdtlen'
ck=. -#k
d=. ((ck{.each d)=<k)#d
if. 0=#d do. 'no fixes required in that path' return. end.
d=. ck}.each d
for_i. i.#d do.
 p=. ;i{d
 s=. 3!:2 fread p,'/jdstate'
 s=. ((<'Tlen')~:{."1 s)#s NB. any old Tlen rows
 map_jmf_ 'tlen';p,'/jdtlen'
 s=. ('Tlen';15!:15 tlen),s NB. add Tlen row to state - forcecopy required
 unmap_jmf_'tlen'
 (3!:1 s)fwrite p,'/jdstate'
 ferase p,'/jdtlen'
end. 
'fixed table jdstate files: ',":#d
)