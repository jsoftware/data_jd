/*
binary reverse proxy between client and jdserver
client <- https -> node <- http -> jdserver

.ssh/jserver'key.pem and fullchain.pem

proof of concept - needs work to be functional/robust/secure
 not hardened against DoS or security attacks - friendly users assumed
*/

console.log('server started');

//const conf  = JSON.parse('{"nport":"3000","jport":"65220"}');
const conf  = JSON.parse(process.argv[2]);

const https  = require('https');
const http  = require('http');
const fs     = require('fs');
const jdsreq = require(__dirname+"/jds.js");

var nport=  conf.nport;
var jport=  conf.jport;
var jdpath= conf.jdpath;

const bind= '0.0.0.0';  // anybody can connect to us

const options = {
  //key: fs.readFileSync(__dirname+'/key.pem'),
  //cert: fs.readFileSync(__dirname+'/cert.pem')
  key:  fs.readFileSync('.ssh/jserver/key.pem'),
  cert: fs.readFileSync('.ssh/jserver/fullchain.pem'),
  'trust proxy': true
};

function reply(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/plain'});res.end(p);}

const server_https = https.createServer(options, (req, res) => {doit(req,res);});

const server_http = http.createServer((req, res) => {doit(req,res);});

var ping= false; // 1 for immediate response with no jd call

function doit(req,res){
  if(req.method == 'POST')
  {
    if(ping){
      res.writeHead(200, "OK", {'Set-Cookie':"jds_cookie=;path=/;Secure;Httponly",'Content-Type': 'application/octet-stream'});
      res.end('{"Jd ping":0}');
      return;
    }

    // add cookie to end of request and pass to jds
    dopost(req, res, function() {
      var c= get_cookies(req)['jds_cookie'];
      req.post= Buffer.concat([req.post,Buffer.from(' '+c),]);
      jdsreq.jdsreq('localhost',jport,req.post,res); // pass (cmd cookie) to jds
   });
   return;
  }

  // get
  var s= decodeURIComponent(req.url);
  switch(s){
   case '/': s= jdpath+'/server/client/server.html'; break;
   case '/curl':        s= jdpath+'/server/client/curl';break;
   case '/pyclient.py': s= jdpath+'/server/client/pyclient.py';break;
   case '/pytest.py':   s= jdpath+'/server/client/pytest.py';break;  
   case '/ping':        ping= !ping;     
   default: s= '';
  }
  res.writeHead(200, "OK", {'Content-Type': 'text/html'}); // ,'Content-Disposition': 'attachment'
  try{ s= fs.readFileSync(s, 'utf8'); }catch(error){ s= ''; }
  res.end(s);

};

 server_https.keepAliveTimeout=10000;
 server_http.keepAliveTimeout=10000;

 server_https.listen(nport, bind, () => {console.log(`Server running at https://${bind}:${nport}/`);});

 // listen on nport+2 for http connections - probably not justified by the limited performance difference
 //server_http.listen(Number(nport)+2, 'localhost', () => {console.log(`Server running at http://localhost:${Number(nport)+2}/`);});

 var get_cookies = function(request) {
  var cookies = {};
  if (typeof(request.headers.cookie) == "undefined") return cookies;
  request.headers && request.headers.cookie.split(';').forEach(function(cookie) {
    var parts = cookie.match(/(.*?)=(.*)$/)
    cookies[ parts[1].trim() ] = (parts[2] || '').trim();
  });
  return cookies;
};

function dopost(req, res, callback) {
        var postdata = [];
        req.on('data', function(data) {
            postdata.push(data);
        });
        req.on('end', function() {
            req.post = Buffer.concat(postdata);
            callback();
        });
}
  