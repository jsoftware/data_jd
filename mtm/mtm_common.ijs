NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm server/client common routines

NB. define n z perhaps not the best solution
enc_z_=: 3!:1
dec_z_=: 3!:2

streamframe=: 3 : 0
0 streamframe y
: 
t=. enc y
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


