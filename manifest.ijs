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

VERSION=: '4.4.83'

FILES=: 0 : 0
manifest.ijs
jd.ijs
todo.txt
demo/common.ijs
demo/sed/csv/jdclass
demo/sed/csv/jdcsvrefs.txt
demo/sed/csv/r.cdefs
demo/sed/csv/e.csv
demo/sed/csv/t.csv
demo/sed/csv/s.cdefs
demo/sed/csv/e.cdefs
demo/sed/csv/r.csv
demo/sed/csv/s.csv
demo/sed/csv/t.cdefs
demo/sandp/csv/jdclass
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
demo/northwind/csv/jdclass
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
tutorial/createcol_derived_mapped_tut.ijs
tutorial/createcol_derived_tut.ijs
tutorial/jctask_tut.ijs
tutorial/ptable_tut.ijs
tutorial/table_table_tut.ijs
tutorial/setget_tut.ijs
tutorial/custom_tut.ijs
tutorial/performance_tut.ijs
tutorial/reads_aggregation_tut.ijs
tutorial/log_tut.ijs
tutorial/link_tut.ijs
tutorial/dropstop_tut.ijs
tutorial/replicate_tut.ijs
tutorial/jcs_tut.ijs
tutorial/jhs_tut.ijs
tutorial/admin_tut.ijs
tutorial/intro_b_tut.ijs
tutorial/intro_a_tut.ijs
tutorial/pairs_tut.ijs
tutorial/reads_clauses_tut.ijs
tutorial/intro_c_tut.ijs
tutorial/table_from_pairs_tut.ijs
tutorial/reads_from_tut.ijs
tutorial/reads_join_tut.ijs
tutorial/reads_option_table_tut.ijs
tutorial/epochdt_tut.ijs
tutorial/stock_data_tut.ijs
tutorial/vr_tut.ijs
tutorial/sed_tut.ijs
tutorial/northwind_tut.ijs
tutorial/sandp_tut.ijs
tutorial/intro_csv_tut.ijs
tutorial/csv_advanced_tut.ijs
tutorial/quandl_ibm_tut.ijs
tutorial/bus_lic_tut.ijs
tutorial/key_tut.ijs
tutorial/info_tut.ijs
tutorial/tableinsert_tut.ijs
tutorial/update_basic_tut.ijs
tutorial/update_advanced_tut.ijs
tutorial/tablecopy_tut.ijs
tutorial/insert_tut.ijs
tutorial/delete_tut.ijs
tutorial/upsert_advanced_tut.ijs
tutorial/upsert_basic_tut.ijs
tutorial/createtable_tut.ijs
tutorial/intx_tut.ijs
tutorial/tablemove_tut.ijs
tutorial/gen_tut.ijs
tutorial/reads_basic_tut.ijs
tutorial/createcol_tut.ijs
tutorial/sort_tut.ijs
tutorial/read_tut.ijs
tutorial/blob_tut.ijs
tutorial/jdserver_tut.ijs
tutorial/json_tut.ijs
tutorial/mtm_tut.ijs
csv/csv.ijs
csv/csvinstall.ijs
csv/csvtest.ijs
config/server_default.ijs
tools/setscriptlists.ijs
tools/repair.ijs
tools/quandl.ijs
tools/tests.ijs
tools/ptable.ijs
tools/ts.ijs
tools/tut.ijs
dynamic/ref.ijs
dynamic/base.ijs
doc/License.htm
doc/jd.css
doc/Ops_csv.htm
doc/Ops_damaged.htm
doc/Ops_read.htm
doc/Index.htm
doc/General.htm
doc/Docs.htm
doc/Ops_info.htm
doc/Ops_common.htm
doc/Overview.htm
doc/Technical.htm
doc/Release.htm
doc/Support.htm
doc/Ops_create.htm
doc/Ops_table-table.htm
doc/Ops_raw.htm
doc/Ops_rename.htm
doc/Ops.htm
doc/Replicate.htm
doc/Admin.htm
doc/Ops_join.htm
doc/Ops_drop.htm
doc/Ops_misc.htm
doc/Guide.htm
doc/Ops_change.htm
api/api_read.ijs
api/api_blob.ijs
api/client.ijs
api/api_csv.ijs
api/api_table.ijs
api/api_info.ijs
api/api_create.ijs
api/api_change.ijs
api/api_csvcdefs.ijs
api/api_drop.ijs
api/api_sort.ijs
api/api.ijs
api/jjd.ijs
api/api_adm.ijs
api/api_misc.ijs
api/api_rename.ijs
api/api_replicate.ijs
api/api_gen.ijs
pm/pm_base.ijs
pm/bench.ijs
pm/pm_disk.ijs
pm/pmc.ijs
pm/pmb.ijs
pm/pm_map.ijs
pm/pm.ijs
pm/pmx.ijs
pm/replicate.ijs
pm/csvtest.ijs
types/numeric.ijs
types/epoch.ijs
types/byte.ijs
types/autoindex.ijs
types/base.ijs
types/datetimes.ijs
types/varbyte.ijs
base/fixpairs.ijs
base/jmfx.ijs
base/folder.ijs
base/lock.ijs
base/util_ptable.ijs
base/util.ijs
base/table.ijs
base/constants.ijs
base/keyindex.ijs
base/log.ijs
base/pm.ijs
base/validate.ijs
base/database.ijs
base/util_epoch.ijs
base/util_epoch_901.ijs
base/read.ijs
base/where.ijs
base/common.ijs
base/column.ijs
base/zutil.ijs
base/tests.ijs
base/testtuts.ijs
mtm/mtm.ijs
mtm/mtm_man.ijs
mtm/mtm_server.ijs
mtm/json.txt
server/jcs_server.ijs
server/http_client.ijs
server/http_client_test.ijs
server/http_server.ijs
server/jctask.ijs
server/fork.ijs
server/server_client_tools.ijs
test/createcol_derived_test.ijs
test/jdserver_test.ijs
test/byten_test.ijs
test/csvcdefs_test.ijs
test/csvrd_types_test.ijs
test/valid_data_test.ijs
test/repair_test.ijs
test/ptable_read_test.ijs
test/ref_dirty_test.ijs
test/basic_test.ijs
test/drop_rename_test.ijs
test/stress_test.ijs
test/insert_revert_test.ijs
test/readx_test.ijs
test/table_append_test.ijs
test/createtable_test.ijs
test/ptable_modify_test.ijs
test/insert_test.ijs
test/ptable_csv_test.ijs
test/northwind_test.ijs
test/shape_test.ijs
test/droptable_test.ijs
test/ref_test.ijs
test/replicate_test.ijs
test/query_test.ijs
test/upsert_test.ijs
test/rmdir_test.ijs
test/createcol_test.ijs
test/error_test.ijs
test/validate_test.ijs
test/alloc_test.ijs
test/utf8_test.ijs
test/ptable_update_test.ijs
test/join_test.ijs
test/fixpairs_test.ijs
test/ptable_insert_test.ijs
test/intx_test.ijs
test/pm_aggby_test.ijs
test/info_test.ijs
test/jdindex_test.ijs
test/cd_query_test.ijs
test/modify_test.ijs
test/joinx_test.ijs
test/update_test.ijs
test/sandp_test.ijs
test/keyindex_test.ijs
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
test/sort_test.ijs
test/user_test.ijs
test/read_types_test.ijs
test/epoch_test.ijs
test/admin_test.ijs
test/join_type_test.ijs
bug/empty_join_where.ijs
bug/csvwr.ijs
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
