NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

coclass'jd'

PTM=: '^'    NB. ptable filename

NB. chars not allowed in Jd names because they are used as file names
NB. also to avoid parsing problems
NB. ` unix shell script
NB. ~ vi etc. temp file
RESERVEDCHARS=: '/\ *.,:?<>|"''`~' NB. illegal chars in dan/table/col names
RESERVEDWORDS=: ;:'by from where order'

ECOUNT=:     'incorrect arg count'
EDNONE=:     'dropdynamic does not exist'
EPRECISION=: 'extra precision'
ESHAPE=:     'bad shape'
ETSHAPE=:    'bad trailing shape'
ETALLY=:     'bad count'
ETYPE=:      'bad type'
EALLOC=:     'bad alloc'
EOPTION=:    'bad option'
EDUPLICATE=: 'duplicate col'
EUNKNOWN=:   'unknown col'
EMISSING=:   'missing col'
EDELETE=:    'jddeletefolder failed'
EINDEX=:     'bad index'
EDROPSTOP=:  'dropstop'
EUNIQUE=:    'warning: deleted N rows to stay unique'

LOCALE=: CLASS=: <'jd'
CHILD=: <'jdfolder'
