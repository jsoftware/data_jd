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

VERSION=: '2.2.5'

FILES=: 0 : 0
manifest.ijs
jd.ijs
demo/common.ijs
demo/sed/sed.ijs
demo/sed/csv/jdcsvrefs.txt
demo/sed/csv/r.cdefs
demo/sed/csv/e.csv
demo/sed/csv/t.csv
demo/sed/csv/s.cdefs
demo/sed/csv/e.cdefs
demo/sed/csv/r.csv
demo/sed/csv/s.csv
demo/sed/csv/t.cdefs
demo/sandp/sandp.ijs
demo/sandp/csv/spj.cdefs
demo/sandp/csv/jdcsvrefs.txt
demo/sandp/csv/sp.csv
demo/sandp/csv/j.cdefs
demo/sandp/csv/p.csv
demo/sandp/csv/s.cdefs
demo/sandp/csv/j.csv
demo/sandp/csv/spj.csv
demo/sandp/csv/sp.cdefs
demo/sandp/csv/s.csv
demo/sandp/csv/p.cdefs
demo/vr/vr.ijs
demo/northwind/northwind.ijs
demo/northwind/csv/jdcsvrefs.txt
demo/northwind/csv/Shippers.csv
demo/northwind/csv/Products.csv
demo/northwind/csv/Employees.csv
demo/northwind/csv/Categories.cdefs
demo/northwind/csv/Suppliers.csv
demo/northwind/csv/Suppliers.cdefs
demo/northwind/csv/Shippers.cdefs
demo/northwind/csv/Customers.cdefs
demo/northwind/csv/Products.cdefs
demo/northwind/csv/Employees.cdefs
demo/northwind/csv/OrderDetails.csv
demo/northwind/csv/OrderDetails.cdefs
demo/northwind/csv/Orders.cdefs
demo/northwind/csv/Categories.csv
demo/northwind/csv/Customers.csv
demo/northwind/csv/Orders.csv
demo/jhs/jdapp1.ijs
tutorial/csv_load_tut.ijs
tutorial/admin_tut.ijs
tutorial/ptable_tut.ijs
tutorial/update_bulk_tut.ijs
tutorial/table_table_tut.ijs
tutorial/tempcol_tut.ijs
tutorial/setget_tut.ijs
tutorial/intro_tut.ijs
tutorial/custom_tut.ijs
tutorial/performance_tut.ijs
tutorial/join_tut.ijs
tutorial/server-jhs_tut.ijs
tutorial/aggregation_tut.ijs
tutorial/log_tut.ijs
tutorial/table_from_array_tut.ijs
tutorial/from_tut.ijs
tutorial/epochdt_tut.ijs
tutorial/reads_tut.ijs
tutorial/server-zmq_tut.ijs
tutorial/link_tut.ijs
tutorial/csv_tut.ijs
tutorial/dropstop_tut.ijs
tutorial/csv_details_tut.ijs
csv/csv.ijs
csv/csvinstall.ijs
csv/csvtest.ijs
config/server_default.ijs
tools/convert.ijs
dynamic/ref.ijs
dynamic/base.ijs
doc/Convert.htm
doc/License.htm
doc/jd.css
doc/Ops_csv.htm
doc/Ops_read.htm
doc/Index.htm
doc/General.htm
doc/Ops_info.htm
doc/Ops_manage.htm
doc/Overview.htm
doc/Technical.htm
doc/Release.htm
doc/Support.htm
doc/Ops_create.htm
doc/Ops_table-table.htm
doc/Ops_rename.htm
doc/Ops.htm
doc/Admin.htm
doc/Ops_join.htm
doc/Ops_drop.htm
doc/Ops_misc.htm
doc/Ops_dynamic.htm
doc/Guide.htm
doc/Ops_change.htm
cd/libjd.dylib
cd/libjd.so
cd/jd.dll
gen/ptable.ijs
api/api_read.ijs
api/client.ijs
api/api_csv.ijs
api/api_info.ijs
api/api_change.ijs
api/api_drop.ijs
api/api.ijs
api/jjd.ijs
api/api_adm.ijs
pm/pm_disk.ijs
pm/pmc.ijs
pm/pmb.ijs
pm/pm.ijs
pm/pmx.ijs
pm/csvtest.ijs
types/numeric.ijs
types/epoch.ijs
types/byte.ijs
types/autoindex.ijs
types/base.ijs
types/datetimes.ijs
types/varbyte.ijs
types/enum.ijs
base/jmfx.ijs
base/folder.ijs
base/scriptlists.ijs
base/util_ptable.ijs
base/util.ijs
base/table.ijs
base/repair.ijs
base/constants.ijs
base/log.ijs
base/pm.ijs
base/validate.ijs
base/tests.ijs
base/database.ijs
base/util_epoch.ijs
base/read.ijs
base/where.ijs
base/common.ijs
base/column.ijs
base/zutil.ijs
test/valid_data_test.ijs
test/ptable_read_test.ijs
test/ref_dirty_test.ijs
test/basic_test.ijs
test/drop_rename_test.ijs
test/stress_test.ijs
test/insert_revert_test.ijs
test/readx_test.ijs
test/table_append_test.ijs
test/ptable_modify_test.ijs
test/insert_test.ijs
test/ptable_csv_test.ijs
test/northwind_test.ijs
test/shape_test.ijs
test/droptable_test.ijs
test/ref_test.ijs
test/query_test.ijs
test/rmdir_test.ijs
test/createcol_test.ijs
test/error_test.ijs
test/validate_test.ijs
test/alloc_test.ijs
test/utf8_test.ijs
test/ptable_update_test.ijs
test/join_test.ijs
test/ptable_insert_test.ijs
test/pm_aggby_test.ijs
test/info_test.ijs
test/jdindex_test.ijs
test/cd_query_test.ijs
test/modify_test.ijs
test/update_test.ijs
test/sandp_test.ijs
test/orderby_test.ijs
test/delete_test.ijs
test/flush.ijs
test/sed_test.ijs
test/log_test.ijs
test/refx_test.ijs
test/multicol_test.ijs
test/ptable_delete_test.ijs
test/joinorder_test.ijs
test/where_test.ijs
test/csv_test.ijs
)

RELEASE=: 'j804 j805 j806'
