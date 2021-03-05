// forward client request to jds server and return result (html or json) to client

const http  = require('http');

// p is string (json table) result from jds request
// {\n"*... indicates key data is Content-Type ... and is returned to client
// otherwise p is returned to client as text/plain
function reply(code,res,p)
{
  if('{\n"*'==p.substring(0,4)) // *text/html indicates content-type and string
  {
    var q= JSON.parse(p);
    var k = Object.keys(q);
    res.writeHead(code, "OK", {'Content-Type': k[0].substring(1)});
    res.end(q[k[0]]);
  }
  else
  {
   res.writeHead(code, "OK", {'Content-Type': 'text/plain'});
   res.end(p);
  }
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
