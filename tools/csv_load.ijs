NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. utils for getting csv files into Jd and J

coclass'jd'

csvadmin=: 3 : 'jdadmin :: (''new''&jdadmin) y'

csvprepare=: 3 : 0 NB. tab ; csv_file
t=. 'arg must be: ''table'';''file'''
t assert 1=L.y
t assert 2=#y
t assert 2=;3!:0 each y
'table file'=. y
t assert fexist file
vtname table
csvadmin 'csvload'
jdcsvfolder''
file fwrite CSVFOLDER__,table,'.csvlink' NB. CSVFOLDER link to csv file
d=. jd'csvprobe /replace ',table,'.csvlink' NB. read first few rows as byte data
r=. 'first few rows:'
r=. r,,LF,.":{:d
r=. r,LF,'first row could be column headers or just data'
r=. r,LF,'run appropriate line from the following:'
r=. r,LF,'   csvload_jd_ ''',table,''';0 NB. if first row looks like data'
r=. r,LF,'   csvload_jd_ ''',table,''';1 NB. if first row looks like col headers'
)

csvload=: 3 : 0 NB. tab;header
'table header'=. y
csvadmin'csvload'
if. fexist CSVFOLDER__,table,'.cnames' do.
 header=. ' /c '
else.
 header=. ;header{' /u ';' /h 1 '
end. 
jd'droptable ',table               NB. delete table if it exists
jd'csvcdefs /replace ',header,table,'.csvlink' NB. create metadata - /u - c1,c2,... col names
jd'csvscan ',table,'.csvlink'      NB. scan entire file to adjust cdefs max byte col widths
jd'csvrd ',table,'.csvlink ',table NB. using metadata, load csv file into Jd table
jd'csvreport /f ',table            NB. loader full report for table tab
)

csvrename=: 3 : 0 NB. table ; oldn ; <newn
'table old new'=. y
csvadmin'csvload'
for_i. i.(#old)<.#new do.
 jd'renamecol ',table,' ',(jdaddq_jd_ i{::old),' ',jdaddq_jd_ i{::new
end.
i.0 0
)

csvmove=: 3 : 0
'sinkdb sinktable sourcetable'=: y
csvadmin'csvload'
'source table does not exist'assert 'table'-: fread (jdpath''),table,'/jdclass'
csvadmin sinkdb
jd'droptable ',sinktable
jd'tablemove ',sinktable,' ',table,' csvload'

)