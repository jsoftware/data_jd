NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass'z'

forcecopy_z_=: a: { ]

NB. from test suite tsu.ijs - return expected error
etx_z_=: 1 : 'x :: (<:@(13!:11)@i.@0: >@{ 9!:8@i.@0:)'

showbox_z_=: 3 : 0
t=. ,d=. ":y
d=. ($d)$' ' ((t e. 32{.a.)#i.#t)}t
(-.*./"1 d="1 1[' '#~{:$d)#d
)

decho_z_=: echo_z_

NB. JHS echo to console - should be in JHS core or even stdlib
echoc=: 3 : 0
if. IFJHS do.
 try.
  jbd 1
  jfe_jhs_ 0
  echo y
 catch.
 end.
 jfe_jhs_ 1
 jbd 0
else.
 echo y
end. 
)

dechoc_z_=: echoc_z_

NB. redirect

0 : 0
F=: '~temp/log.txt'
'' fwrite R
redirect_jfe_ F
i.23
'asdf';'sdgf'
redirect_jfe_''
fread F
)

coclass'jfe'

redirect=: 3 : 0
if. ''-:y do.
 output_jfe_=: output_jhs_
else.
 LOG=: y
 output_jfe_=: log_jfe_
end. 
i.0 0
)

log_jfe_=: 4 : 0
y fappend LOG
)