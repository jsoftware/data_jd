NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm server/client common routines

NB. define n z perhaps not the best solution
mtmenc_z_=: 3 : 'if. (2=3!:0 y)*.1>:$$y do. y else. y=. 3!:1 y end.'
mtmdec_z_=: 3 : 'if. 227=a.i.{.y do. 3!:2 y else. y end.' 

streamframe=: 3 : 0
0 streamframe y
:
t=. mtmenc y
t,~'JdMTMfrm',(((8#256)#:HLEN+#t){a.),((8#256)#:x){a.
)

framelen=: 3 : 0
256#.a.i._8{.16{.y
)

getrid_z_=: 3 : 0
256#.a.i._8{.24{.y
)

0 : 0
frame header
'JdMTMfrm' - 8 chars
len        - 8 byte integer (see framelen)
rid        - request id - same format as framelen
)

HLEN=: 24 NB. bytes in  frame header

