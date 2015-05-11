NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. date, datetime, and time types
coclass 'jdtint'
coclass deftype 'timelike'

ADDRANK =: 1
DATAFILL =: -~2
NB. =========================================================
NB. x is an example string like 'yyyymmdd.hhmmss' .
fixdatetime =: 4 :0

NB. APIRULES insist on integers - avoid complicated conversions
if. APIRULES do. fixtype_jdtint_ y return. end. 

len =. #x-.'.'  NB. maximum length of input (and length of output)
min =. x i. '.' NB. minimum length of input
float =. min<len
base =. #;.2~ 1,~ 2 ~:/\ x-.'.'
if. float do. minbase =. #;.2~ 1,~ 2 ~:/\ min{.x end.

rnk =. #@$ val=.y
if. (rnk=1) *. (2=3!:0 val) do. rnk =. #@$ val=.,:val end.
if. (rnk>1) +. (0<L.val) do.
  val=.>val
  throwif 2 ~: #@$ val
  if. 2 = 3!:0 >@{.val do. NB. From string
    val=. (#~ e.&'0123456789')"1 >val
    ndigits =. ' ' +/@:~:"1 val
    if. float do.
      throwif (len&~: +./@:*. min&~:) ndigits
      val=. (=&' ')`(,:&'0')} len {."1 val
    else.
      throwif len +./@:~: ndigits
    end.
    ,boxopen val=. "."1 val return.
  else. NB. From list of numbers
    if. float *. (#base) > #{.val do.
      throwif (#minbase) ~: #{.val
      val =. (#base) {."1 val
    end.
    throwif (#base) ~: #{.val
    if. 4 ~: 3!:0 val do.
      if. !float do.
        int=. <. :: 0: val
      end.
      throwif -. int -: val
      val=. int + -~ 2
    end.
    throwif (val < 0) +.&(+./@,) (val >:"1 ]10^base)
    val=. (10<.@^base) #. val
  end.
elseif. 4 ~: 3!:0 val do. NB. From number
  if. -.float do.
    val=. <. :: _1: val
  else.
    mult=. 10<.@^ x (<:@#@[-i:) '.'
    val=. <.@:(*&(10<.@^len-min)) :: _1: val
  end.
  throwif (-.@-: |) val
  throwif (val +./@:< 10^+/}.base) +. (val +./@:>: 10^len)
  val=. val + -~2
elseif. float do.
  throwif val +./@:>: 10^len
  if. val<10^<:len do.
    throwif (val +./@:< 10^<:min) +. (val +./@:>: 10^min)
    val=. val * 10<.@^len-min
  end.
elseif. do.
  throwif (val +./@:< 10^+/}.base) +. (val +./@:>: 10^len)
end.
, boxopen val=. ,val
)

NB. =========================================================
coclass deftype 'date'
fixtype =: 'yyyymmdd'&fixdatetime

NB. =========================================================
coclass deftype 'datetime'
fixtype =: 'yyyymmdd.hhmmss'&fixdatetime

NB. =========================================================
coclass deftype 'time'
fixtype =: 'hhmmss'&fixdatetime
