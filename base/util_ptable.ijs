NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

coclass 'jd'

isptable=: 3 : 0
if. '.'e.y do. 0 return. end. NB.!!! ptable must be first in from and by itself - f and not f.g
-.0-:jdgl :: 0: y,PTM NB. ispatable table_name
)

NB. return sorted ptable suffixes ; Tlens
getparts=: 3 : 0
a=. y,PTM
n=. NAMES__dbl
b=. (<a)=(#a){.each n
b=. b*.(#a)<;#each n NB. remove f~
n=. b#n
c=. b#CHILDREN__dbl
n=. (#a)}.each n
t=. ;(3 : 'Tlen__y')"0 c
s=. /:n
n=. s{n
t=. s{t
n;t
)

NB. return sorted ptable suffixes for setting setting tab~ pcol
getpartsx=: 3 : 0
n=. (>:#y)}.each 2 }.getparttables y
)

NB. sorted partition table names (f, f~, f~..., ...)
NB. returns single table name if not partition table
NB. returns single table name if y is already a partition name (has a ~)
getparttables=: 3 : 0
if. PTM e.y do. <y return. end.
ns=. NAMES__dbl
ns=. /:~ns#~(<,y)=(ns i.each PTM){.each ns
if. 1<#ns do.
 t=. jdgl ;{.ns
 'table (not a ptable) has partitions' assert S_ptable__t
end.
ns
)

NB. typ f data
NB. filename-suffix from insert values
NB. edate edatetime conversions to int required in ptable filename
pcol_ffromv=: 4 : 0
if. 'int'-:x do. y return. end.
if. 2=3!:0 y do.
 t=. sfe efs y
else.
 t=. sfe y
end.
c=. ('edate'-:x){19 10
t=. c{."1 t
0".t -."1 '-T:Z'
)

NB. typ f data
NB. filebname-suffix from pcol values - used in read
pcol_ffromv_x=: 4 : 0
select. x
case. 'int'       do.
 s=. ":each<"1 ,.y
case. 'edate'     do.
 s=. '-'-.~ each 10{.each sfe each <"0 y
case. 'edatetime' do.
 s=. (<'-T:')-.~ each 19{.each sfe each <"0 y
case.             do.
 'bad pcol type'assert 0
end.
)

NB. typ f data
getpcolvals=: 4 : 0
select. x
case. 'int' do.
 d=. 0".each y
case. 'edate' do.
 d=. ('-' 4 7} 1 1 1 2 1 2 1 1 # ]) each y
case. 'edatetime' do.
 d=. ('--T::' 4 7 10 13 16} 1 1 1 2 1 2 1 2 1 2 1 2 1 1 # ]) each y 
end.
/:~>d
)
