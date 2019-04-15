NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

coclass'jd'

JDOK=: ,.<'Jd OK'

imax=: 9223372036854775807
imin=: (-imax)-1

i1max=: <:<.2^7
i1min=: <:-i1max

i2max=: <:<.2^15
i2min=: <:-i2max

i4max=: <:<.2^31
i4min=: <:-i4max

MAXROWCOUNT=: _

PTM=: '^'    NB. ptable filename

NB. chars not allowed in Jd names because they are used as file names
NB. also to avoid parsing problems
NB. ` unix shell script
NB. ~ vi etc. temp file
RESERVEDCHARS=: '/\ *.,:?<>|"''`~' NB. illegal chars in dan/table/col names
RESERVEDWORDS=: ;:'by from where order'

ECOUNT=:     'incorrect arg count'
EDNONE=:     'bad SUBSCR'
EPRECISION=: 'extra precision'
ESHAPE=:     'bad shape'
EBTS=:       'bad trailing shape'
ETALLY=:     'bad count'
ETYPE=:      'bad type'
EALLOC=:     'bad alloc'
EOPTION=:    'bad option'
EOPTIONV=:   'bad option value'
EDUPLICATE=: 'duplicate col'
EUNKNOWN=:   'unknown col'
ENOTJD=:     'jd prefix not allowed'
EMISSING=:   'missing col'
EDELETE=:    'jddeletefolder failed'
EINDEX=:     'bad index'
EDROPSTOP=:  'dropstop'
EUNIQUE=:    'warning: deleted N rows to stay unique'
EBOOLEAN=:   'bad boolean data'
EFLOAT=:     'bad float data'
EINT=:       'bad int data'
EINT1=:      'bad int1 data'
EINT2=:      'bad int2 data'
EINT4=:      'bad int4 data'
EDERIVED=:   'derived not allowed'
ECSVBYTE0=:  'byte col trailing shape 0 not allowed'
EPTABLE=:    'ptable not allowed'

LOCALE=: CLASS=: <'jd'
CHILD=: <'jdfolder'
