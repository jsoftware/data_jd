0 : 0
clean Jd table data

byte cols untouched
Na values replaced by median
outlier values (min and max) replaced by median
)

median=: 3 : '((<.-:#y){/:y){y' NB. central value in sorted data
fmt=: 3 : '1000%~<.y*1000'
cleanlabs=: 'Na';'%Na';'mid';'avg';'neg';'min';'max';'out-';'out+'

NB. table_name ; omin ; omax ; 'change or not'
NB. min outliers are: <<.avg%omin
NB. max outliers are: ><.omax*avg
clean=: 3 : 0
'tab omin omax change'=. y
'invalid change'assert (<change) e. 'change';''
s=. jd'info schema ',tab
cols=. dltb each<"1 >1{"1 {:s
typs=. <"1 >2{"1 {:s
a=. (0,#cleanlabs)$''
for_col. cols do.
 c=. jdgl_jd_ tab,' ',;col
 select. typ__c
 case.'int';'edatetimen';'float' do.
  r=. cleansub c;omin;omax;change
 case. 'byte' do.
  r=. (+/(0{a.)={."1 ,.dat__c),(<:#cleanlabs)#0
 case.        do. r=. _1
 end.
 a=. a,r
end.
if. 'change'-:change do. clean tab;omin;omax;'' return. end.
(,.' ';cols),.(,.' ';typs),.cleanlabs,<"0 a
)

NB. if change - replace Na, Out-, out+ with median
cleansub=: 3 : 0
'c omin omax change'=. y
nav=. >('float'-:typ__c){IMIN_jd_;__
d=. forcecopy dat__c
r=. +/na=. d=nav
r=. r,100*fmt r%#d
r=. r,mid=. median d
'median is Na'assert mid~:nav
d=. mid (I.na)}d NB. replace Na now so other calcs make sense
r=. r,avg=. fmt (+/d)%#d
r=. r,+/neg=. 0>d
r=. r,<./d
r=. r,>./d
r=. r,+/outm=. d<<.avg%omin NB. mid could be 0 so use avg
r=. r,+/outp=. d><.omax*avg NB. mid could be 0 so use avg

if. change-:'change' do. dat__c=: mid (I.outm+.outp)}d end. NB. replace Na,outm,outp with mid

r
)
