NB. time map related things.

map_creates=: 3 : 0
jd'createtable f'
for_i. i.y do.
 jd'createcol f c',(":i),' int'
end.
)

map_times=: 3 : 0
jdadminx 'test'
echo 'create';timex'map_creates 1000'
echo 'close ';timex'jd''close'''
echo 'schema';timex'jd''info schema'''
)

NB. from a complete shutdown and restart
map_map_time=: 3 : 0
jdadmin'test'
echo'map';timex'jd''info schema'''
)

0 : 0
times on fast linux with ssd
   map_times''
┌──────┬────────┐
│create│0.830701│
└──────┴────────┘
┌──────┬────────┐
│close │0.081012│
└──────┴────────┘
┌──────┬───────┐
│schema│0.20704│
└──────┴───────┘
   map_map_time''
┌───┬────────┐
│map│0.821654│
└───┴────────┘

times on older windows laptop
   map_times''
┌──────┬───────┐
│create│10.5645│
└──────┴───────┘
┌──────┬────────┐
│close │0.309289│
└──────┴────────┘
┌──────┬───────┐
│schema│1.34713│
└──────┴───────┘
   map_map_time''
┌───┬───────┐
│map│13.8546│
└───┴───────┘
 )
 