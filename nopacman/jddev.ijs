man=: 0 : 0
Jd development

~addons -> j90x/addons
~Addons -> git/addons

editing/testing done with git/addons/data/jd

   load'~addons/data/jd/jd.ijs' NB. from ~addons
   
   load'~Addons/data/jd/jd.ijs' NB. from git/addons
   
Initial load sets JDP_jd_ as path to jd folder and this
is used for all other file references.

*** pacman release build (from ~Addons/ide/jhs):
 bup'git/addons/data/jd'

 ...$ cd git/addons/data/jd
 ...$ git pull
 ...$ git status - resolve problems

start J
   load'~Addons/ide/jhs/nopacman/dev.ijs'
   setp'data/jd'
   manifest_status'' NB. edit manifest to resolve problems
   bump_version''

 ...$ git status
 ...$ git commit -a -m "pacman release ..."
 ...$ git push
