NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jd'

NB. Each folder which is handled by JD contains files:
NB. jdclass giving the class without the leading 'jd'
NB. (folder, database, table, column).
NB. state giving global state (optional).
NB. If no class is present, it is assumed to be a folder.

NB. Each class must contain the globals:
NB. CLASS        the name of the class
NB. CHILD        the class of contained objects
NB. STATE        global nouns to save to file
NB. open         called on Open
NB. testcreate   called like create with LOCALE as left argument;
NB.                fails if create would fail
NB. create       called (with arguments) on Create
NB. close        called on Close and Drop

NB. jd provides:
NB. NAME
NB. PATH
NB. PARENT       the locale of the parent object
NB. LOCALE       the locale of this object
NB. CHILDREN     the locales of children
NB. NAMES        the names of children
NB.
NB. Open         open a jd folder (locale must be child of current locale)
NB. Close        close a folder, but leave the data
NB. Create       create a child object
NB. Drop         remove a child object (by locale)
NB. readstate    read state from the filesystem
NB. writestate   write state to the filesystem
NB.
NB. getloc       get a locale from a name

NB. jd is special because it cannot be instantiated.
NB. Thus it only contains a few of the globals.
LOCALE =: CLASS =: <'jd'
CHILD =: <'jdfolder'

PATH=:NAME=: ''
CHILDREN=: ".'CHILDREN'
NAMES=: ".'NAMES'

NB. =========================================================
NB. utilities
NB. y is the name of this locale
Init =: 3 : 0
PATH =: termSEP PATH__PARENT, NAME =: >y
LOCALE =: coname''
CHILDREN =: NAMES =: ''
NB. writestate''
)
NewChild =: 3 : 0
loc =. cocreate ''
coinsert__loc CHILD
coinsert__loc PARENT__loc =: LOCALE
CHILDREN =: CHILDREN,loc
NAMES =: NAMES,<NAME__loc=:y
loc
)
RemoveChild =: 3 : 0
CHILDREN =: CHILDREN-.y
NAMES =: NAMES-.<NAME__y
)

getloc=: 3 : 0
if. -.'/'e.,>y do.
 if. '.' e. y=.,>y do. 4 :'getloc__y x'/ LOCALE ,~ |.<;._1'.',y return. end.
 if. (,'^') -: y do. PARENT return. end.
end.
ind=. NAMES i. <y
if. (ind=#NAMES) do.
 if. 0=nc<'Tlen' do.
  i=. ({."1 TEMPCOLS)i.<NAME,'_',y
  if. i<#TEMPCOLS do. {:i{TEMPCOLS return. end.
 end.
 throw 'Not found: ',(2}.>CHILD),' ',,":y
end.

c=. ind{CHILDREN

NB. map as required
if. APIRULES do.
 if. 'jdcolumn'-:;CLASS__c do.
  if. (-.OP-:'reference')*. _1=nc {.MAP__c,each <'__c' do. NB. OP reference creates multiple cols/mappings and is special
   mapcolfile__c"0 MAP__c
   opentyp__c ''
  end.
 end.
end.

c
)

NB. y is a name.
ischildfolder =: 3 : 0
CHILD -: <'jd', LF-.~1!:1 :: ('folder'"_) <PATH,(>y),'/jdclass'
)

openallchildren =: 3 : 0
for_name. dirsubdirs PATH do.
  Open^:ischildfolder name
end.
)

NB. unmap everything in path
unmappath =: 3 : 0
msk=. PATH ([ -: #@[ {. ])&.> 1 {"1 mappings_jmf_
jdunmap &> msk # {."1 mappings_jmf_
)

NB. =========================================================
NB. y is a name, which extends PATH.
Open =: 3 : 0
y=.,>y
if. NAMES e.~ <y do. getloc y return. end.
if. -.ischildfolder y do.
  msg =. 'n1 cannot be opened by c2 n2'
  throw msg rplc 'n1';y;'c2';CHILD,'n2';NAME
end.
loc =. NewChild y
Init__loc y
readstate__loc ''
open__loc ''
loc
)

NB. y is (NAME;dat) where dat will be passed to create
NB. x gives class of created object (default CHILD).
Create=: 3 : 0
'name dat' =. ({. (,<) }.) y =. boxopen y
if. ischildfolder name do.
  throw 'Create: ',name,' already exists as a child of ',NAME
end.
LOCALE testcreate__CHILD dat
dcreate PATH,name=.,name

NB. folder links locate cols on particular paths
if. 'column'-:2}.>CHILD do.
 links=. fread 'links.txt',~jdpath''
 if. -.links-:_1 do.
  links=. >bd2 each <;._2 links
  link=. jpath PATH,name
  a=. _3{.<;.2 PATH,name,'/'
  s=. <}:;1}.a
  i=. s i.~ {."1 links
  if. i<#links do.
   j=. ;{:i{links
   j=. j,'/'#~'/'~:{:j
   target=. jpath j,}:;a
   jdcreatefolder target
   if. IFWIN do.
    t=. '"',link,'" "',target,'"'
    t=. 'mklink /D /J ',t rplc '/';'\'
    jddeletefolder link
    shell t NB. wndows does junction between folders
   else.
    n=. '"',target,'" "',link,'"'
    t=. 'ln -s ',n
    jddeletefolder link
    shell t
   end.
  end.
 end.
end.

(2}.>CHILD) 1!:2 <PATH,name,'/jdclass'
loc =. NewChild name
Init__loc name
create__loc dat
loc
)

NB. =========================================================
NB. y is a locale, or an unboxed name.
Close =: 3 : 0
y =. getloc^:(0=L.) y
if. y -.@e. CHILDREN do.
  throw 'Close: ',NAME__y,' is not a child of ',NAME
end.
for_loc. CHILDREN__y do. Close__y loc end.
RemoveChild y
writestate__y ''
close__y ''
codestroy__y ''
EMPTY
)
NB. =========================================================
NB. For testing purposes only
BadClose =: 3 : 0
y =. getloc^:(0=L.) y
if. y -.@e. CHILDREN do.
  throw 'Close: ',NAME__y,' is not a child of ',NAME
end.
for_loc. CHILDREN__y do. BadClose__y loc end.
RemoveChild y
close__y ''
codestroy__y ''
EMPTY
)
NB. =========================================================
NB. same arguments as Close
Drop =: 3 : 0
if. 0=L.y do.
  if. (<y=.,y)-.@e.NAMES do.
    if. ischildfolder y do. jddeletefolder PATH,y end.
    return.
  end.
  y =. getloc y
end.
path =. PATH__y
Close y
jddeletefolder path
EMPTY
)

NB. =========================================================
NB. state
readstate=: 3 : 0
if. #STATE do. pdef (3!:2) 1!:1 <PATH,'jdstate' end.
)
writestate=: 3 : 0
if. #STATE do. (3!:1 pack STATE) 1!:2 <PATH,'jdstate' end.
)
