coclass'jwget'

0 : 0
duplicates facilities in pacman and web/gethttp

pacman doesn't allow explicit filename, and has too much baggage
web/gethttp writes report/errors to console

this is the pacman version with:
 explicit file save name and simpler error check and result
)

3 : 0''
if. IFUNIX do.
  if. UNAME-:'Darwin' do.
    HTTPCMD=: 'curl -o %O --stderr %L -f -s -S %U'
  else.
    HTTPCMD=: 'wget -O %O -o %L -t %t %U'
  end.
else.
  if. fexist t=. jpath '~tools/ftp/wget.exe' do.
    HTTPCMD=: '"',t,'" -O %O -o %L -t %t -T %T %U'
  else.
    HTTPCMD=: 'wget.exe -O %O -o %L -t %t -T %T %U'
  end.
  if. fexist t=. jpath '~tools/zip/unzip.exe' do.
    UNZIP=: '"',t,'" -o -C '
  else.
    UNZIP=: 'unzip.exe -o -C '
  end.
end.
)

hostcmd=: [: 2!:0 '(' , ] , ' || true)'"_

shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd y
else.
  spawn_jtask_ y
end.
)

NB. timeout,retries hardwired to 60,3
NB. filename jwget url
jwget=: 4 : 0
f=. y
p=. jpath x
q=. jpath '~temp/jwget.log'
ferase p;q
fail=. 0
cmd=. HTTPCMD rplc '%O';(dquote p);'%L';(dquote q);'%t';'3';'%T';'60';'%U';f
try. e=. shellcmd cmd catch. 'jwget shellcmd failed'assert 0
end.
t=. fread q
'jwget error'assert _1~:t
('jwget error (see ',q,' for details')assert 0=+./'error' E. tolower t
p
)

NB. get zip file from joftware jdcsv and unzip in CSVFOLDER
NB. used by bus_lic and qunadl_ibm tutorials
getcsv=: 3 : 0 NB. get csv file if it doesn't already exist
f=. (y{.~y i.'.'),'.zip'
if. -.fexist CSVFOLDER__,y do.
 (CSVFOLDER__,f) jwget 'www.jsoftware.com/download/jdcsv/',f
 unzip=. ;(UNAME-:'Win'){'unzip';jpath'~tools/zip/unzip.exe'
 t=. '"',unzip,'" "',fn,'" -d "',(jpath CSVFOLDER__),'"'
 if. UNAME-:'Win' do. t=. '"',t,'"' end.
 r=. shell t
 r,LF,'CSVFOLDER now contains the csv file'
else.
 'CSVFOLDER already contains the csv file'
end.
)
