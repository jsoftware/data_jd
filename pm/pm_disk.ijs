
NB. y loop fwrite gb - report millis per gb
gb_fwrite=: 3 : 0
assert (y>0)*.y<30
d=. 1e9$'a'
fn=: jpath'~temp/jnk.0'
ferase fn
''fwrite fn
PMA''
for_i. i.y do.
  d fwrite fn
end.
'fappend'PM''
<.0.5+y%~PMT''
)

f=: 3 : 0
d=. 1e9$'abc'
PMA''
for_i. i.y do.
 fn=. jpath'~temp/jnk',":i
 d fwrite fn
 ('fwrite',":i)PM''
end. 
)


g=: 3 : 0
d=. 1e9$'a'

PMA''
for_i. i.y do.
 fn=. jpath'~temp/jnk',":i
 d fwrite fn
end. 
'end'PM''
<.0.5+y%~PMT''
)

h=: 3 : 0
d=. 1e9$'a'
fn=. jpath'~temp/jnk',":y
PMA''
d fwrite fn
'end'PM''
<.0.5+1%~PMT''
)

gx=: 3 : 0
t=. 30
decho t
r=. ''
for_i. i.y do.
 fn=. jpath'~temp/jnk',":i
 ferase fn
 6!:3[t
 r=. r,g 1
end.
r
)

