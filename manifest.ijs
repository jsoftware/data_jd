NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
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

VERSION=: '2.3.3'

FILES=: 0 : 0
jd.ijs
manifest.ijs
api/api.ijs
api/api_adm.ijs
api/api_change.ijs
api/api_csv.ijs
api/api_drop.ijs
api/api_info.ijs
api/api_read.ijs
api/client.ijs
api/jjd.ijs
base/column.ijs
base/common.ijs
base/constants.ijs
base/database.ijs
base/folder.ijs
base/jmfx.ijs
base/log.ijs
base/pm.ijs
base/read.ijs
base/scriptlists.ijs
base/table.ijs
base/tests.ijs
base/util.ijs
base/util_epoch.ijs
base/util_ptable.ijs
base/validate.ijs
base/where.ijs
base/zutil.ijs
cd/jd.dll
cd/libjd.dylib
cd/libjd.so
config/server_default.ijs
csv/csv.ijs
csv/csvinstall.ijs
csv/csvtest.ijs
demo/common.ijs
demo/jhs/jdapp1.ijs
demo/northwind/northwind.ijs
demo/northwind/csv/Categories.cdefs
demo/northwind/csv/Categories.csv
demo/northwind/csv/custom.ijs
demo/northwind/csv/Customers.cdefs
demo/northwind/csv/Customers.csv
demo/northwind/csv/Employees.cdefs
demo/northwind/csv/Employees.csv
demo/northwind/csv/OrderDetails.cdefs
demo/northwind/csv/OrderDetails.csv
demo/northwind/csv/Orders.cdefs
demo/northwind/csv/Orders.csv
demo/northwind/csv/Products.cdefs
demo/northwind/csv/Products.csv
demo/northwind/csv/Shippers.cdefs
demo/northwind/csv/Shippers.csv
demo/northwind/csv/Suppliers.cdefs
demo/northwind/csv/Suppliers.csv
demo/sandp/sandp.ijs
demo/sandp/csv/custom.ijs
demo/sandp/csv/j.cdefs
demo/sandp/csv/j.csv
demo/sandp/csv/p.cdefs
demo/sandp/csv/p.csv
demo/sandp/csv/s.cdefs
demo/sandp/csv/s.csv
demo/sandp/csv/sp.cdefs
demo/sandp/csv/sp.csv
demo/sandp/csv/spj.cdefs
demo/sandp/csv/spj.csv
demo/sed/sed.ijs
demo/sed/csv/custom.ijs
demo/sed/csv/e.cdefs
demo/sed/csv/e.csv
demo/sed/csv/r.cdefs
demo/sed/csv/r.csv
demo/sed/csv/s.cdefs
demo/sed/csv/s.csv
demo/sed/csv/t.cdefs
demo/sed/csv/t.csv
demo/vr/vr.ijs
doc/admin.html
doc/change.html
doc/csv.html
doc/dynamic.html
doc/favicon.ico
doc/general.html
doc/guide.html
doc/index.html
doc/jblue.png
doc/jda.css
doc/license.html
doc/manage.html
doc/misc.html
doc/ops.html
doc/opsinfo.html
doc/opsread.html
doc/overview.html
doc/release.html
doc/support.html
doc/table-table.html
doc/technical.html
dynamic/base.ijs
dynamic/hash.ijs
dynamic/hash1.ijs
dynamic/ref.ijs
dynamic/reference.ijs
dynamic/smallrange.ijs
dynamic/unique.ijs
gen/ptable.ijs
pm/csvtest.ijs
pm/pm.ijs
pm/pma.ijs
pm/pmb.ijs
pm/pmc.ijs
pm/pmx.ijs
pm/pm_disk.ijs
pm/pm_hash.ijs
pm/pm_hashtimes.ijs
pm/pm_reference.ijs
test/alloc_test.ijs
test/append_test.ijs
test/basic_test.ijs
test/cd_query_test.ijs
test/createcol_test.ijs
test/createhash_unique_test.ijs
test/csv_test.ijs
test/dropdynamic_test.ijs
test/droptable_test.ijs
test/drop_rename_test.ijs
test/dynamic_test.ijs
test/error_test.ijs
test/float_test.ijs
test/flush.ijs
test/hashx_test.ijs
test/hash_insert_test.ijs
test/hash_pass_test.ijs
test/hash_test.ijs
test/info_test.ijs
test/insert_test.ijs
test/jdindex_test.ijs
test/joinorder_test.ijs
test/join_test.ijs
test/log_test.ijs
test/modify_test.ijs
test/multicol_test.ijs
test/northwind_test.ijs
test/orderby_test.ijs
test/pm_aggby_test.ijs
test/pm_hash_test.ijs
test/ptable_csv_test.ijs
test/ptable_delete_test.ijs
test/ptable_insert_test.ijs
test/ptable_modify_test.ijs
test/ptable_read_test.ijs
test/ptable_update_test.ijs
test/query_test.ijs
test/readx_test.ijs
test/reference_test.ijs
test/refx_test.ijs
test/ref_test.ijs
test/rmdir_test.ijs
test/sandp_test.ijs
test/sed_test.ijs
test/shape_test.ijs
test/smallrange_test.ijs
test/stress_test.ijs
test/update_test.ijs
test/validate_test.ijs
test/where_test.ijs
test/core/datatype-common.ijs
test/core/datatype.ijs
test/core/hash.ijs
test/core/joins.ijs
test/core/key.ijs
test/core/query.ijs
test/core/reference.ijs
test/core/testall.ijs
test/core/unique.ijs
test/core/util.ijs
test/core/utilref.ijs
tutorial/admin_tut.ijs
tutorial/aggregation_tut.ijs
tutorial/csv_details_tut.ijs
tutorial/csv_tut.ijs
tutorial/custom_tut.ijs
tutorial/dropstop_tut.ijs
tutorial/epochdt_tut.ijs
tutorial/from_tut.ijs
tutorial/hash_tut.ijs
tutorial/intro_tut.ijs
tutorial/join_tut.ijs
tutorial/link_tut.ijs
tutorial/log_tut.ijs
tutorial/performance_tut.ijs
tutorial/ptable_tut.ijs
tutorial/reads_tut.ijs
tutorial/server_tut.ijs
tutorial/setget_tut.ijs
tutorial/table_from_array_tut.ijs
tutorial/table_table_tut.ijs
tutorial/tempcol_tut.ijs
tutorial/unique_tut.ijs
tutorial/update_bulk_tut.ijs
tutorial/where_tut.ijs
types/autoindex.ijs
types/base.ijs
types/byte.ijs
types/datetimes.ijs
types/enum.ijs
types/epoch.ijs
types/numeric.ijs
types/varbyte.ijs
)

RELEASE=: 'j701 j801 j802 j803 j804 j805 j806'
