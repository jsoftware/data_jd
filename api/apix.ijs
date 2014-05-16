NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. api extension (keep apl.ijs core smaller

coclass'jd'

jd_info=: 3 : 0
jd_close'' NB. close so we get fresh data
t=. bdnames y
if. t-:,<'version' do. ,.'version';'1.0' return. end.
if. t-:,<'open'    do. ,.'open';<>opened'' return. end.
if. ({.t)=<'state' do.
 jd_close'' NB. insist close so current state flushed to file
 'table prefix'=. 2{.}.t
 p=. dbpath_jd_ DB_jd_
 p=. p,'/',table,'/'
 d=. {."1 dirtree p
 d=. d#~(<'jdstate')=_7{.each d
 d=. (#jpath p)}.each d
 d=. d#~(<prefix)=(#prefix){.each d
 d=. d,.(3!:2)@fread each (<p),each d
 ('path';'state'),d
 return.
end. 
'f d'=. getfolder''
Open__f d
r=. infox t
)

infox=: 3 : 0
'type tab col'=. 3{.y
NB. type=. >{.y
NB. tables=. }.y
p=. jpath dbpath DB
maps=. mappings_jmf_
maps=. maps /:1{"1 maps
d=. 1{"1 maps
b=. (;(<p)-:each (#p){.each d)
d=. b#d
h=. b#{."1 maps
t=. >_3{.each <;._2 each d,each'/'
if. 0~:#tab do.
 m=. (0{"1 t)e.<tab
 d=. m#d
 h=. m#h
 t=. m#t
end.
if. 0~:#col do.
 m=. (1{"1 t)e.<col
 d=. m#d
 h=. m#h
 t=. m#t
end.
if. 0=$t do.t=. 0 3$'' end. NB. lazy kludge
select. type
case. 'table' do.
 m=. ((2{"1 t)=<'dat')*.(2{.each 1{"1 t)~:<'jd'
 t=. m#t
 t=. ,.>~.0{"1 t
 ,.'table';t
case. 'schema' do.
 m=. ((2{"1 t)=<'dat')*.(2{.each 1{"1 t)~:<'jd'
 t=. m#t
 w=. m#d
 tabs=. >0{"1 t
 cols=. >1{"1 t
 w=. (w i: each '/'){.each w
 s=.  3!:2 each fread each w,each <'/jdstate'
 ti=. ;({."1 each s) i. each <<'typ'
 si=. ;({."1 each s) i. each <<'shape'
 typ=.   >>{:"1 each ti { each s
 shape=.  >":each >{:"1 each si { each s
 (;:'table column type shape'),:tabs;cols;typ;shape
case. 'varbyte' do.
 m=. (2{"1 t)=<'val'
 t=. m#t
 w=. m#d
 tabs=. 0{"1 t
 cols=. 1{"1 t
 r=. 0 3$''
 for_i. i.#tabs do.
  j=. d i. <jpath (dbpath DB),'/',(>i{tabs),'/',(>i{cols),'/dat'
  if. j<#d do.
   z=. <4}.}:;j{h
   t=. {:"1 dat__z
   r=. r,(<./t);(<.(+/t)%#t);>./t
  end.
 end.
 (;:'table column min avg max'),:(>tabs);(>cols);(,.>0{"1 r);(,.>1{"1 r);(,.>2{"1 r)
case. 'last' do.
 ,.(;:'cmd time space'),:lastcmd;lasttime;lastspace
case. 'map' do.
 tp=. ;".each(<'3!:0 '''),each h,each <'''~'
 sz=. (JTYPES i. tp){JSIZES
 tp=. tp{'bad';'bool';'lit';'bad';'int';'bad';'bad';'bad';'float'
 sh=. ".each (<'$'''),each h,each <'''~'
 bs=. sz*each */each sh
 fs=. <"0[1!:4 d
 ds=. (>:;d i:each '/')}.each d
 (;:'table column noun file jtype shape bytes fsize'),(}:"1 t),.h,.ds,.tp,.sh,.bs,.fs
case. 'summary' do.
 tabs=. ~.0{"1 t
 r=. 0 2$''
 for_i. i.#tabs do.
  j=. d i. <jpath (dbpath DB),'/',(>i{tabs),'/jdactive/dat'
  z=. <4}.}:;j{h
  a=. +/dat__z
  b=. (#dat__z)-a
  r=. r,a,b
 end.
 (;:'table active deleted'),tabs,.<"0 r
case. 'hash' do.
  t=. }:"1 t#~(2{"1 t)=<'hash'
  (;:'table column'),({."1 t),.7}.each {:"1 t
case. 'reference' do.
  t=. }:"1 t#~(2{"1 t)=<'datl'
  (bdnames'table table_column(s)'),({."1 t),.12}.each {:"1 t
case. 'agg' do.
 d=. getdb''
 ,.(<'aggs'),{."1 AGGFCNS__d
case. do.
 assert 0['unsupported info command'
end. 
)

statefmt=: 3 : 0
({."1 y)=. {:"1 y
typ,' ',deb ,showbox subscriptions
if. 1=#subscriptions do.
 deb ,showbox subscriptions
else.
 (deb ,showbox {.subscriptions),' > ',deb ,showbox {:subscriptions
end.
)
