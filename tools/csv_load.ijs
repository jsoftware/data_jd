NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. utils for getting csv files into Jd and J

csvprepare=: 3 : 0 NB. tab ; csv_file
'tab f'=: y
jdadmin :: ('new'&jdadmin) 'csvload' NB. csvload DB
jdcsvfolder_jd_''
f=. jpath f
vtname_jd_ tab
'file must exist'assert fexist f
f fwrite CSVFOLDER,tab,'.csvlink' NB. CSVFOLDER link to csv file
d=. jd'csvprobe /replace ',tab,'.csvlink' NB. read first few rows as byte data
r=. 'first few rows:'
r=. r,,LF,.":{:d
r=. r,LF,'first row could be column headers or just data'
r=. r,LF,'run appropriate line from the following:'
r=. r,LF,'   csvload ''',tab,''';0 NB. if first row looks like data'
r=. r,LF,'   csvload ''',tab,''';1 NB. if first row looks like col headers'
)

csvload=: 3 : 0 NB. tab;header
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

csvrename=: 3 : 0 NB. tab ; oldn ; <newn
'tab old new'=. y
for_i. i.(#old)<.#new do.
 jd'renamecol ',tab,' ',(jdaddq_jd_ i{::old),' ',jdaddq_jd_ i{::new
end.
i.0 0
)
