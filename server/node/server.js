/*
clients <- https -> node <- http -> jdserver

client: https://...:3000         - gets application html
client: https://...:3000/s1/...  - get html by running s1 xget verb

proof of concept - needs work to be functional/robust/secure
 not hardened against DoS or security attacks - friendly users assumed

logon user/pswd stores token in cookie
 list of valid u/p values set in config
 crypto on up list - convert token to u/p

start J
   load'jd'
   jdrt'node
*/

const https  = require('https');
const fs     = require('fs');
const crypto = require("crypto"); // used only for initialization
const jdsreq = require(__dirname+"/jds.js");
const conf   = require(process.argv[2]);

const port= conf.port;
const bind= '0.0.0.0';  // anybody can connect to us

const svc= JSON.parse(conf.svc);
var svcreport= "";
for (i = 0; i < svc.length; i++)
{
  svcreport+= svc[0][i];
  svcreport+= " host/port/dan: "+svc[1][i]+" "+svc[2][i]+" "+svc[3][i]+"\n";
}

var getdata= fs.readFileSync(__dirname+'/server.html', 'utf8');
getdata= getdata.replace("SVCREPORT",svcreport);

const options = {
  key: fs.readFileSync(__dirname+'/key.pem'),
  cert: fs.readFileSync(__dirname+'/cert.pem')
};

var token= []; // cookie token for u/p lookup
while(token.length<conf.up.length){token.push(crypto.randomBytes(16).toString("hex"))};

function reply(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/plain'});res.end(p);}

function replyc(code,res,p,cookie)
{
  res.writeHead(code, "OK", {'Set-Cookie':"jds_cookie="+cookie+";Secure;Httponly",'Content-Type': 'text/html'});
  res.end(p);
}

const server = https.createServer(options, (req, res) => {
  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      var s= decodeURIComponent(req.post);
      console.log("command: "+s);
      var t= s.substring(0,4);
      s= s.substring(4); // strip off type - jds= or lgn= or lgx=
      switch(t)
      {
        case "lgn=":
         var i= conf.up.indexOf(s);
         if(-1==i)
          replyc(200,res,"login - invalid",0);
         else
          replyc(200,res,("login - valid"),token[i]);
         break; 
 
        case "lgx=":
         replyc(200,res,"logoff",0);break;

        case "jds=":
          var c= get_cookies(req)['jds_cookie'];
          i= token.indexOf(c);
          if(-1==i){replyc(200,res,"logon required",0);return;}
          c= conf.up[i];

          var i= s.indexOf(' '); // strip of service name
          var svcnm= s.substring(0,i);
          s= s.substring(i+1);
          var svci= svc[0].indexOf(svcnm);
          if(-1==svci){reply(200,res,"invalid service name");return;}

          var host= svc[1][svci];
          var port= svc[2][svci];
          var dan=  svc[3][svci];
          var olds= s;
          s= "json json "+dan+" "+c+';'+s;
          jdsreq.jdsreq(c,host,port,dan,olds,res);
          break;

       default:
         reply(200,res,"bad command")
    }
   });
   return;
  }

  // get
  var s= decodeURIComponent(req.url);
  if("/"==s)
  {
   res.writeHead(200, "OK", {'Content-Type': 'text/html'});
   res.end(getdata);
  }
  else
  {
   c= "u/p" // hardwired user pswd
   var svcnm= s.substring(1);
   var i= svcnm.indexOf('/'); // strip of service name
   svcnm= svcnm.substring(0,i);
   var svci= svc[0].indexOf(svcnm);
   if(0!=svci){reply(200,res,"invalid get service name");return;}
   var host= svc[1][svci]; var port= svc[2][svci]; var dan=  svc[3][svci];
   jdsreq.jdsreq(c,host,port,dan,("xget "+s),res);
  }
});

 server.listen(port, bind, () => {
  console.log(`Server running at https://${bind}:${port}/`);
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
  var postdata = "";
      req.on('data', function(data) {
          postdata += data;
          if(postdata.length > 1e6) {
              postdata = "";
              res.writeHead(413, {'Content-Type': 'text/plain'}).end();
              req.connection.destroy();
          }
      });
      req.on('end', function() {
          req.post = postdata;
          callback();
      });
  }
