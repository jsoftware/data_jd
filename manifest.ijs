NB. Copyright 2018, Jsoftware Inc.  All rights reserved.
NB. data/jd manifest

CAPTION=: 'Jd'

DESCRIPTION=: 0 : 0
Jd is a commercial database product from Jsoftware.
Although similar in terminology and features to
MySQL, Oracle, DB2, SQL Server, and others, it is closer
in spirit and design to Kx's kdb, Jsoftware's free JDB,
and old APL financial systems on mainframes in 70s and 80s.

The key difference between Jd and most other systems 
is that Jd comes with a fully integrated and mature
programming language. Jd is implemented in J and lives
openly and dynamically in the J execution and development
environment. Jd is a natural extension of J and the full power
of J is available to the Jd database application developer.
The integration is not just available to you,
it is unabashedly pushed to you for exploitation.

Jd is a columnar (column oriented) RDBMS.

Jd is particularly suited to analytics.
It works well with large tables (100s of millions of rows),
multiple tables connected by complex joins, structured data,
numerical data, and complex queries and aggregations.
)

VERSION=: '4.4.100'

FILES=: 0 : 0
manifest.ijs
jd.ijs
jdkey.txt
todo.txt
demo/
tutorial/
csv/
config/
tools/
dynamic/
doc/
api/
pm/
types/
base/
mtm/
server/
test/
bug/
)

FILESWIN64=: 0 : 0
cd/jd.dll
cd/jpcre.dll
)

FILESLINUX64=: 0 : 0
cd/libjd.so
cd/libjpcre.so
cd/rpi/libjd.so
cd/rpi/libjpcre.so
)

FILESDARWIN64=: 0 : 0
cd/libjd.dylib
cd/libjpcre.dylib
)

RELEASE=: 'j807'

DEPENDS=: 0 : 0
convert/pjson
data/jfiles
data/jmf
)

FOLDER=: 'data/jd'
