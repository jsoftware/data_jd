NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

coclass'jd'

JDOK=: ,.<'Jd OK'

IMAX=:  9223372036854775807
IMIN=:  _1+-IMAX
IBAD=: IMIN

I1MAX=: <:<.2^7
I1MIN=: _1+-I1MAX
I1BAD=: I1MIN

I2MAX=: <:<.2^15
I2MIN=: _1+-I2MAX
I2BAD=: I2MIN

I4MAX=: <:<.2^31
I4MIN=: _1+-I4MAX
I4BAD=: I4MIN

PTM=: '^'    NB. ptable filename

NB. chars not allowed in Jd names because they are used as file names
NB. also to avoid parsing problems
NB. ` unix shell script
NB. ~ vi etc. temp file
RESERVEDCHARS=: '/\ *.,:?<>|"''`~-=' NB. illegal in dan/table/col names - -= conflict with joins
RESERVEDWORDS=: ;:'by from where order'
MAXNAMECHARS=: 201 NB. includes terminating blank

t=. 0 : 0 NB. map colname RESERVEDCHARS
/ _fs_
\ _bs_
  _
* _star_
. _dot_
, _comma_
: _colon_
? _query_
< _lt_
> _gt_
| _bar_
" _dquote_
' _quote_
` _tie_
~ _tilda_
- _minus_
= _equal_
)

'bad COLNRPLC'assert RESERVEDCHARS-:;{.each <;._2 t
COLNRPLC=: (<"0 RESERVEDCHARS_jd_) ,. 2}.each<;._2 t


ECOUNT=:     'incorrect arg count'
EDNONE=:     'bad SUBSCR'
EEPOCH=:     'bad epoch data'
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
ETABLEFILE=: '/table and /file are mutually exclusive'

LOCALE=: CLASS=: <'jd'
CHILD=: <'jdfolder'
