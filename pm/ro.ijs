NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

require'~addons/net/jcs/jcs.ijs'

0 : 0
how effective is having multiple RO tasks doing random reads

create large DB and measure throughput for tasks 1 through 8

little improvement for compute bound task competing for same resource

main reason would be that slow tasks would not block fast tasks

JOBS 6!:3 benifits from 4 tasks (3.7)

JOBS spinner benefits from 4 task (3.7)

JOBS jd benefits from 4 tasks (2.5) (no change if all from f or if from f and g)

)


NB. rows rocreate range
rocreate=: 3 : 0
rows=: y
range=: <.y%100
jdadmin 0
jdadminx'ro'
jd'createtable f'
jd'createcol f a int'
jd'createcol f b int'
jd'createcol f c int'
d=: ?.rows$range
jd'insert f';'a';d;'b';d;'c';d

jd'createtable g'
jd'createcol g a int'
jd'createcol g b int'
jd'createcol g c int'
d=: ?.rows$range
jd'insert g';'a';d;'b';d;'c';d
jdadmin 0
jdadminro'ro'
)

tests=: 2}.each <;._2 [ 0 : 0 
0 jd'reads from f where a=0'
1 jd'reads from f where b=0'
2 jd'reads from f where c=0'
3 jd'reads from f where b=0 or b=1 or b=2 or c=0 or b=0 or c=0 or b=0 or c=0 or b=0 or c=0'
4 6!:3[5
5 6!:3[?3
6 jd'reads from f where a=0'
7 jd'reads from g where a=0'
8 spinner 5
)

test=: 3 : ';y{tests'

NB. seconds to run test 
NB. seconds rorate test
rorate=: 4 : 0
jdadmin 0
jdadminro'ro'
t=. ;y{tests
echo t
cnt=. 0
s=: 6!:1''
while. (6!:1'')<s+x do.
 ".t
 cnt=. >:cnt
end.
cnt%x
)

spinner=: 3 : 0
s=. 6!:1''
while. y>s-~6!:1'' do. end.
)


NB. y is number of tasks to create
pjinit=: 3 : 0
peinit_jcs_ PORTBASE_jcs_+i.y
peload_jcs_'~Jddev/jd.ijs'
peset_jcs_'jdadminro''ro'''
petasks_jcs_
)


NB. y number of jobs of each type
NB. 20 0; 5 1
pjjobs=: 3 : 0
y=. boxopen y
r=. ''
for_n. y do.
 'c t'=. >n
  r=. r,c#<test t
end.
JOBS=: ,.((#r)?.#r){r
i. 0 0
)

necho=: [
necho =: echo

pjcompare=: 3 : 0
pjinit 1
a=. pjrun''
echo LF,LF
pjinit 4
b=. pjrun''
a%b
)

pjclean=: 3 : 0
for_n. petasks_jcs_ do. runz__n :: 0: 0 end.
)

NB. run JOBS
pjrun=: 3 : 0
echo #petasks_jcs_
tm=. (2,~#JOBS)$0
rs=. '' NB. job results
ns=. '' NB. job numbers
error=.0
i=. 0 NB. started
j=. 0 NB. ended
c=. #JOBS
start=. 6!:1''
while. j<c do.
  'rc reads writes errors'=. poll_jcs_ 5000;'';<petasks_jcs_
  if.  0=rc do. necho '                               poll 0:' end.

  for_n. writes do.
   if. i<c do.
    t=. ;i{JOBS
    tm=. (6!:1'') (<i,0)} tm
    job__n=: i
    runa__n t
    i=. >:i
   end. 
  end. 

  for_n. reads do.
   try.
     rs=. rs,{.;{:{: runz__n 0
     tm=. (6!:1'') (<job__n,1)} tm
     j=. >:j
     necho'done ',":job__n
   catch.
     echo lse__n
     error=. 1
   end.
  end.
end.
if. error do. echo 'errors in result' end.
rs
t=. start-~6!:1''
TM=: <.1000*tm-start
t
)


foo=: 3 : 0
while. y=.<:y do.
 pjinit 1
 n=. {.petasks_jcs_
 runa__n 'i.4'
 echo runz__n 0
 pjinit 4
 n=. {.petasks_jcs_
 runa__n 'i.6'
 echo runz__n 0
end.
5
)


boo=: 3 : 0
while. y=.<:y do.
 pjinit 1
end.
23
)
