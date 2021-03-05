NB. jd_x... verbs for jdrt'node'

jd_xdo=: 3 : 0
try. 1 2$'result';<do__ y catch. 1 2$'error';13!:12'' end.
)

custom_html=: 0 : 0
<!DOCTYPE html><html><head></head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<body>BODY</body></html>
)

jd_xget=: 3 : 0
try.
 data=. ,LF,.~":i.>:?10 10
 body=. '<h1>Report for URL: ',y,'</h1><hr/><h2>',(timestamp''),'</h2>'
 body=. body,'<pre>',data,'</pre>'
catch.
 body=. '<pre>request failed: ',(13!:12''),'</pre>'
end. 
1 2$'*text/html';custom_html rplc 'BODY';body
)