0 : 0
try to fork/execl in J in order to get pid from fork result
trouble is the pid is for /bin/sh
and can't figure out how to get from there to the pid for the jconsole task
)

libc=: unxlib'c'
fork=: libc,' fork >x'
execl=: libc,' execl i *c *c *c *c *'

start=: 0 : 0
echo i.2 3
echo 6!:0''
a=: i.23
echo a
)

start fwrite '~/start.ijs'

NB. redirect (no terminal) task
rdofork=: 3 : 0
r=. fork cd ''
if. r=0 do.
 try.
  arg=. '/bin/sh';'sh';'-c';'/home/eric/j901/bin/jconsole start.ijs < /dev/null > jnk.jnk';<<0
  a=. execl cd arg
  'dofork execl failed'fwrite'jnk.jnk'
 catch. 
  'dofork cd failed'fwrite'jnk.jnk'
 end.
 exit'' NB. only get here if cd or execl failed
end.
r
)

NB. terminal task
tdofork=: 3 : 0
r=. fork cd ''
if. r=0 do.
 try.
  cmd=. 'x-terminal-emulator -e ','"/home/eric/j901/bin/jconsole start.ijs"'
  arg=. '/bin/sh';'sh';'-c';cmd;<<0
  a=. execl cd arg
  'dofork execl failed'fwrite'jnk.jnk'
 catch. 
  'dofork cd failed'fwrite'jnk.jnk'
 end.
 exit'' NB. only get here if cd or execl failed
end.
r
)
