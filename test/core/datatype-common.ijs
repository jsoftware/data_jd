NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Test that all the datatypes work with insertion, deletion

f =: Open_jd_ jpath '~temp/jd'
d =: (Create__f [ Drop__f) 'btest'

NB. boolean, int, float, byte, enum
tVals =: (}: , 2#{&a.&.>@{:) (<"_1 ]12 (?.@$"0) 2 1e8 0 128)
NB. varbyte
tVals =: tVals , < (((#i.@#) </. a.{~97+26?.@$~+/) (12?.@$10))
NB. date, datetime, time
tVals =: tVals , ({.@":"0 ] 12 8?.@$10) ; (1e7+9e7*12?.@$0) ; (12 3?.@$24)

NB. Add shape 5
tVals5 =: (({.,5,}.)@:$$5&(,@:#))&.> _3}.tVals
NB. Add shape 3 2
tVals32 =: (({.,3 2,}.)@:$$6&(,@:#))&.> _3}.tVals

tNms =: (],(,&'5')&.>,&(_3&}.)(,&'32')&.>) TYPES
tCol =: ; tNms (LF,~[,' ',(HASH#'hash '),])&.> (],(,&' 5')&.>,&(_3&}.)(,&' 3 2')&.>) TYPES
tVals =: tVals , tVals5 , tVals32

t =: Create__d 't';tCol;<tNms,.tVals

order =: tNms i.~ {."1 Read__d 'from t'
cols =: order { {:"1 @: Read__d
tCols =: cols 'from t'
(21#12) -: #@> tCols
1 4 8 2 2 32 4 4 4 1 4 8 2 2 32 1 4 8 2 2 32 -: 3!:0@> tCols
(6{.tVals) -: (6{.tCols)
(9}.tVals) -: (9}.tCols)

NB. test insertion
Insert__d 't';<tNms,.|.&.>tVals
ct =. cols 'from t'
(21#24) -: #@> ct
tCols -: 12&{.&.> ct
tCols -: |.@(12&}.)&.> ct

NB. test typechecks
assertfailure;._2 ](0 :0)
Insert__d 't';< tNms ,. (}:&.>@{.,}.)tVals
Insert__d 't';< tNms ,. }.tVals
Insert__d 't';< tNms ,. (<0 4)C.tVals
Insert__d 't';< tNms ,. (<1 2)C.tVals
Insert__d 't';< tNms ,. (<2 3)C.tVals
Insert__d 't';< tNms ,. (<0 9)C.tVals
)

NB. test resizing
Insert__d 't';<tNms,.2004&$&.> tVals
ct =. cols 'from t'
(21#2028) -: #@> ct
tCols -: 12&{.&.> ct
tCols -: _12&{.&.> ct

NB. test deletion
Delete__d 't';'jdindex>=1992'
ct =. cols 'from t'
(21#1992) -: #@> ct
tCols -: 12&{.&.> ct
tCols -: _12&{.&.> ct

NB. test deletion resizing
Delete__d 't';'jdindex>=12'
tCols -: cols 'from t'

NB. test drop
Drop__d 't'
-.ischildfolder__d 't'
t =: Create__d 't';tCol;<tNms,.tVals
tCols -: cols 'from t'

NB. test restore from filesystem
d =: Open__f 'btest' [ Close__f d
tCols -:&(/:~) cols 'from t'

NB. test singleton insertion
Insert__d 't';<tNms ,. {.&.> tCols
((,{.)&.> tCols) -:&(/:~) cols 'from t'
