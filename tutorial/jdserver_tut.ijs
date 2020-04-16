0 : 0
preliminary version of jdserver - subject to change!
)

jd_jdserver_jman_

'new'jdadmin'test'
jdserver 'json json;createtable f'
jdserver 'json json;createcol f i int'
jdserver'json json;info schema'
jbindec jdserver'jbin jbin;info schema'
jdserver 'json json;insert f;',jsonenc 'i';2 3 4
jbindec jdserver 'jbin jbin;insert f;',jbinenc 'i';2 3 4
jdserver 'json json;read from f'
jbindec jdserver 'jbin jbin;read from f'
