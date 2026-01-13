// forward binary client request to jds server and return binary result to client

const http  = require('http');

const jdok   = '{"JD OK":0}';
const jderror= '{"Jd error":"logon failed"}';

// p is binary buffer from jd server
// p[0] is 0 if logon, 1 if logoff, or other
function reply(code,res,p)
{
  if(p[0]==0){ // logon
    var t= p.toString().slice(1);
    res.writeHead(code, "OK", {'Set-Cookie':"jds_cookie="+t+";path=/;Secure;Httponly",'Content-Type': 'text/html'});
    res.end((0==t.length)?jderror:jdok);
  }else if(p[0]==1){ // logoff
    res.writeHead(code, "OK", {'Set-Cookie':"jds_cookie=;path=/;Secure;Httponly",'Content-Type': 'application/octet-stream'});
    res.end(jdok);
  }else{
    res.writeHead(code, "OK", {'Content-Type': 'application/octet-stream'});
    res.end(p);
  }
}

async function jdsreq(host,port,s,res)
{
let promise= dorequest(host,port,s);
promise.then(good,bad);
function good(data){reply(200,res,data);}
function bad(data) {reply(200,res,data);}
}

exports.jdsreq= jdsreq;

function dorequest(host,port,body){
  return new Promise(function(resolve, reject) {
   let options = {hostname: host,port: port,path: "/",method: "POST",
    headers: {
      "Content-Type": "application/octet-stream",
      "Content-Length": Buffer.byteLength(body)
    }
  }
  http
    .request(options, res => {
      var data = [];
      res.on("data", d => {data.push(d)})
      res.on("end", () => {resolve(Buffer.concat(data));})
    })
    .on("error",  (error) => {reject(JSON.stringify(error));})
    .end(body)
});
}
