NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

man=: 0 : 0
these utils can help you load csv files
you load a csv into Jd and, for free, it is in J
maximize ability to work with csv files with minimal Jd knowledge
)

NB. create csvload DB - y is 'new' to clear out all previous stuff
csvinit=: 3 : 0
select. y
case. 'new' do. 
 'new'jdadmin'csvload'
 jdcsvfolder_jd_'' NB. create CSVFOLDER in DB folder for metadata
case. 'keep' do.
 jdadmin'csvload'
case. do. 'arg must be new or keep'assert 0
end.
)

NB. y - table_name ; csv_file
csvprepare=: 3 : 0
e=. 'csvinit must be run first'
e assert 0=nc<'dbl_jd_'
d=. dbl_jd_
e assert #d
e assert CSVFOLDER=:PATH__d,'jdcsv/'
'tab f'=. y
f=. jpath f
vtname_jd_ tab
'file must exist'assert fexist f
'file must be .csv'assert'.csv'-:_4{.f
f fwrite CSVFOLDER,tab,'.csvlink' NB. CSVFOLDER link to csv file
d=. jd'csvprobe /replace ',tab,'.csvlink' NB. read first few rows as byte data
r=. 'first few rows:'
r=. r,,LF,.":{:d
r=. r,LF,'first row could be column headers or just data'
r=. r,LF,'run appropriate line from the following:'
r=. r,LF,'   csvload ''',tab,''';0 NB. if first row looks like data'
r=. r,LF,'   csvload ''',tab,''';1 NB. if first row looks like col headers'
)

NB. table;header
csvload=: 3 : 0
'tab header'=. y
tab=. dltb tab
if. fexist CSVFOLDER,tab,'.cnames' do.
 header=. ' /c '
else.
 header=. ;header{' /u ';' /h 1 '
end. 
jd'droptable ',tab             NB. delete table if it exists
jd'csvcdefs /replace ',header,tab,'.csvlink' NB. create metadata - /u - c1,c2,... col names
jd'csvscan ',tab,'.csvlink'    NB. scan entire file to adjust cdefs max byte col widths
jd'csvrd ',tab,'.csvlink ',tab NB. using metadata, load csv file into Jd table
)

csvread=: 3 : 0
jd'reads from abc'        NB. labeled cols
jd'read from abc'       NB. labeled rows
'c1'jdfrom_jd_ jd'read from abc'
)
