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
const fs     = require('fs');
const jdsreq = require(__dirname+"/jds.js");

var nport= conf.nport;
var jport= conf.jport;

const bind= '0.0.0.0';  // anybody can connect to us

var getdata= fs.readFileSync(__dirname+'/server.html', 'utf8');

const options = {
  //key: fs.readFileSync(__dirname+'/key.pem'),
  //cert: fs.readFileSync(__dirname+'/cert.pem')
  key:  fs.readFileSync('.ssh/jserver/key.pem'),
  cert: fs.readFileSync('.ssh/jserver/fullchain.pem'),
  'trust proxy': true
};

function reply(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/plain'});res.end(p);}

const server = https.createServer(options, (req, res) => {
  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      var c= get_cookies(req)['jds_cookie'];
          if(req.post[0]==43){
            req.post= Buffer.concat([Buffer.from('+ '),req.post]);
          }
          else{
            if(typeof c=='undefined' || c==''){reply(200,res,'{"Jd error":"logon required"}');return;}
            req.post= Buffer.concat([Buffer.from(c+' '),req.post]);
          }
          jdsreq.jdsreq('localhost',jport,req.post,res); // pass (cookie *cmd) to jds
       
   });
   return;
  }

  // get
  var s= decodeURIComponent(req.url);
  if("/"==s)
  {
   res.writeHead(200, "OK", {'Content-Type': 'text/html'});
   res.end(fs.readFileSync(__dirname+'/server.html', 'utf8'));
  }
  if("/bash.tar"==s)
    {
     res.writeHead(200, "OK", {'Content-Type': 'text/html'});
     res.end(fs.readFileSync(__dirname+'/bash.tar', 'utf8'));
    }
  
});

 server.listen(nport, bind, () => {
  console.log(`Server running at https://${bind}:${nport}/`);
});

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
  