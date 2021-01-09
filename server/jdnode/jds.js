// node request to Jd server

const http  = require('http');

function reply(code,res,p)
{
  res.writeHead(code, "OK", {'Content-Type': 'text/plain'});
  res.end(p);
}

async function jdsreq(up,host,port,dan,s,res)
{
s= "json json "+dan+" "+up+';'+s;
let promise= dorequest(host,port,s);
promise.then(good,bad);
function good(data){reply(200,res,data);}
function bad(data) {reply(200,res,data);}
}

exports.jdsreq= jdsreq;

function dorequest(host,port,body){
    return new Promise(function(resolve, reject) {
     i= body.indexOf('#');
     if(i!=-1){body= body.substring(0,i)+"\n"+body.substring(i+1);}
     let options = {hostname: host,port: port,path: "/",method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(body)
      }
    }
    http
      .request(options, res => {
        var data = ""
        res.on("data", d => {data += d})
        res.on("end", () => {resolve(data);})
      })
      .on("error",  (error) => {reject(JSON.stringify(error));})
      .end(body)
  });
}
