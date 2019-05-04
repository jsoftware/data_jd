
NB. vr - based on lab vehicle registration database
NB. original example had multiple tables to show idea of enums
NB. this version is a single table

NB. utilities
toss=: ? @ (# #) { ]              NB. toss x dice with faces y
wordlines=: [: ;: [: ; ,&' ';._2  NB. multiline wf

MAKES=:  10{.each     ;:'Ford Dodge Buick Pontiac Hudson Rambler Toyota Honda Accura VW Mercedes'
COLORS=: 10{.each     ;:'Red Green Blue Grey Pink Yellow Mauve Maroon'
TDATA=:  10{.each ''; ;:'Due Unpaid Dead'

FIRSTNAME=: 10{.each wordlines 0 : 0
  Alex Amit Anne Boris Boyd Bruce Carlos Clare Dale Darryn Dianne Graham
  Harlan Harry Helen Jason Jody Johnny Julien Klaus Lewis Linda Lynne Marc
  Margot Milane Munroe Noel Owen Pam Rose Ross Shawn Skip Tom Toshio Troy
  Vin Vince
)

LASTNAME=: 10{.each wordlines 0 : 0
  Abbott Adams Algar Anctil Andrews Beale Boudreau Brady Briscoe Budd
  Cahill Davis Dilworth Donohoe Downs Fobear Foster Gerow Glancey Gordon
  Green Hill Johnson Keegan Keller Kelly Kerik McBride McKee Miller Mills
  Newton Patrick Patten Power Rogerson Stearn Sullivan Tang Taylor
  Thompson
)

VCols=: 0 : 0
lic       int
make      byte 10
color     byte 10
year      int
fine      float
firstname byte 10
lastname  byte 10
comment   byte 10
)

NB. generate y random vr records
VData=: 3 : 0
lic=. licx+i.y NB. 1e6+?~y
licx=: licx+y
make=. >y toss MAKES
color=. >y toss COLORS
year=. 1900 + ?y$99
fine=. (+ 10*0<]) 0.01 * (?y$5000) * (?100)=100|i.y
firstname=. >y toss FIRSTNAME
lastname=.  >y toss LASTNAME
comment=. >TDATA {~ (0 < fine) * ? y $ #TDATA
lic;make;color;year;fine;firstname;lastname;<comment
)

build=: 3 : 0
jdadminx'vr'
len=. >(''-:y){y;30
assert 1=#len
licx=: 1e9
jd'createtable';'vr';VCols
blk=. 100000
cnt=. 0
while. len > 0 do.
 cnt=. cnt + len <. blk
 jd'insert';'vr';,(;:'lic make color year fine firstname lastname comment'),.VData len <. blk
 len=. len - blk
end.
i.0 0
)

build 1000

jdadmin'vr'
jd'reads count lic from vr'
jd'reads count lic by make from vr'
jd'reads from vr where lic<1000000100 and make="Ford"'

