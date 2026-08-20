0 : 0
measure ms/gb sustained disk transfer rates
)

GBC=: 1e9
D=: GBC$'a'
fn=: jpath'~temp/jnk.0'


NB. y loop indexed fwrite - report ms/gb
ms_gb_ndx_fwrite=: 3 : 0
assert (y>0)*.y<30
''fwrite fn
PMA''
s=. 0
for. i.y do.
  D 1!:12 fn;s
  s=. s+GBC
end.
''PM''
<.0.5+y%~PMT''
)

NB. y loop indexed fread - report ms/gb
ms_gb_ndx_fread=: 3 : 0
assert y<:<.GBC%~fsize fn
s=. 0
t=. 0
PMA''
for. i.y do.
 t=. +/'a'=1!:11 fn;s,GBC
 s=. s+GBC
end.
''PM''
<.0.5+y%~PMT''
)

ms_gb_map_read=: 3 : 0
JCHAR map_jmf_ 'd';fn
b=. <.GBC%~#d
PMA''
t=. +'a'=/d
''PM''
unmap_jmf_ 'd'
<.0.5+b%~PMT''
)

cu=: 3 : 0
