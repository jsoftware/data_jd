
NB. create new date col from existing datetime col
  
NB. set does not handle dynamic cols that need updates
NB. this is not a problem when set is done to a newly created col
NB. but is a serious problem if used on a col in a ref
  
jdadminx'test'
jd'createtable';'f';'dt datetime'
jd'insert';'f';'dt';20121212101010 20121111101010
jd'createcol f d date'
jd'reads from f'
jd'set';'f';'d';<.10e6%~jd'get f dt'
jd'reads from f'
t=. jd'read from f'
('d'jdfrom_jd_ t)-:<.10e6%~'dt'jdfrom_jd_ t
  
