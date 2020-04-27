NB. Lab: run jconsole tasks

require JDP,'server/jctask.ijs'

report_jctask_'' NB. report of jc tasks

NB. if tasks are listed that you care about
NB. do not do the next step as it kills all jc tasks

clean_jctask_'all'

NB. jconsole terminal task
NB. new jconsole terminal task will have focus
NB. click tutorial window to recover focus
tid=. run_jctask_ 't';'test1';'echo i.3 4' NB. type;description;sentences

tid NB. unique jc task identifer
dir '~temp/jctask','/',tid NB. tid is folder with task info
tid get_jctask_ 'start.ijs'   NB. script used to start the task
tid get_jctask_ 'type' 
tid get_jctask_ 'description'
tid get_jctask_ 'pid'         NB. task host pid
report_jctask_''

NB. in jconsole terminal window created in a previous step, run sentence: exit''
report_jctask_'' NB. note red (read/exit/date) changed from run to exit

tid=. run_jctask_ 't';'test2';'echo i.23' NB. type;description;sentences
report_jctask_''

NB. close the new jconsole terminal by clicking the x close button
report_jctask_'' NB. note red changed from run to dead

tid=: run_jctask_ 't';'test3';'a=: i.23',LF,'echo a' NB. LF delimited list of sentences
report_jctask_''
killtid_jctask_ tid
report_jctask_''

tid=. run_jctask_ 't';'test4';<'i.5';'exit''''' NB. boxed list of sentences
report_jctask_'' NB. note test4 red is exit

NB. jconsole redirect task (no terminal)
tid=. run_jctask_ 'r';'test5';'echo i.5'
tid get_jctask_ 'start.ijs' NB. r type has last sentence of: exit''
report_jctask_''
tid get_jctask_ 'out'  NB. redirected task outputt

report_jctask_''
clean_jctask_'all' NB. kill run tasks and remove all jctask folders
