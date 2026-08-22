/*
binary reverse proxy between client and jdserver
client <- https -> node <- http -> jdserver task 0 (perhaps rw replicate)
                        <- http -> jdesrver task 1 (perhaps ro replicate)
                        ...

node can route requests to multiple localhost J ports based on op
logon/logoff done in node so there is a single ductable for multiple clients

logon requires user to enter his pswd - this needs to be secure!

.ssh/jserver/key.pem and fullchain.pem
*/

const https  = require('https');
const http   = require('http');
const fs     = require('fs');
const fsp     = require('fs/promises');
const crypto = require('crypto');

// get config info argv and conf.handle folder
const nfolder= JSON.parse(process.argv[2]).handle;
const nport=   fs.readFileSync(nfolder+'a_nport').toString();
const upfile=  fs.readFileSync(nfolder+'a_upfilepath').toString();
const jports=  fs.readFileSync(nfolder+'a_jports').toString().split(" ").map( Number);

const time=  fs.readFileSync(nfolder+'a_time').toString().split(" ").map( Number);
const inttimeout= time[0]; // run timeouts every n seconds
const jqtimeout=  time[1]; // time on jobq before timeout
const jdtimeout = time[2]; // time in jd before timeout - op continues to run
const reptrigger= time[3]; // write ops before repupdate on idle clone 

const jdpath=  fs.readFileSync(nfolder+'a_jdp').toString();

const logpath= nfolder+'node.log';

const bind= '0.0.0.0';  // anybody can connect to us
const TAB   = '\t';
const LF    = '\n'

const MOK    = '{"Jd OK":0}';
const MLOGON = '{"Jd error":"logon required"}';
const MPORT  = '{"Jd error":"timeout - wait for port"}';
const MSTOP  = '{"Jd error":"server stopped"}';

//const MJD = '{"Jd error":"timeout - waiting for Jd"}'; //CURLOPT_TIMEOUT???

const options = {
  key:  fs.readFileSync('.ssh/jserver/key.pem'),
  cert: fs.readFileSync('.ssh/jserver/fullchain.pem'),
  'trust proxy': true
};

// timeout values
var sndtimeout= -1;
var rcvtimeout= -1;

const server_https = https.createServer(options, (req, res) => {doit(req,res);});
const server_admin  = http.createServer(options, (req, res) => {doitadmin(req,res);});

// admin treated as a read op so port n will work
const RDOPS= ['admin','close','read','reads','key','info','list']; // 'rd...','xrd...'

const zmq= require("zeromq");
const { Mutex }=require('async-mutex');

var socks= [];    // zmq socket
var mutexes= [];  // mutex on socket
var reps=[];      // res for replicate jd request

var jobq= []; // array of res requests for jd

// jd request info
const jlen= jports.length;
var jready= Array(jlen).fill(0); // port status - 0 ready - 1 busy
var jts=    Array(jlen).fill(0); // port ts - when sent to jd - used for jd timeout
var jres=   Array(jlen).fill(0); // port res

async function createsocks(){
  for(const p of jports){
    mutexes.push(new Mutex);
    reps.push({'jdn':jports.indexOf(p),'jdcnt':0});

    const sock = new zmq.Request({
      tcpKeepalive: 1,
      tcpKeepaliveIdle: 300,
      // tcpKeepaliveCnt: 10,
      tcpKeepaliveInterval: 300,
      //sendTimeout:    5000,  // Timeout if unable to queue
      //receiveTimeout: 60000, // Timeout if no response
      //immediate:      true, // Only queue if a peer is connected
      //relaxed:        true, // allow new request without receiving a reply first
      //correlate:      true  // ignore late replies from previous dead requests
  });

    // zmq sock connect must complete before doing send
    const promise = new Promise((resolve) => {
     sock.events.on("handshake", (event) => {
       resolve();
     });
    });
    sock.connect("tcp://127.0.0.1:"+p);
    await promise; // Wait for handshake
    socks.push(sock);
  }
}

createsocks();

var uptable;
var users;
var ductable = [];
var logcnt= 0; // increasing count of logons - added to ductable entry

async function logit(res,type,xtra) {
  if(xtra==null) extra= '';
  const ts = new Date().toISOString();
  const t  = [ts,type,res.jdlogcnt,res.jdconnection,res.jdport,res.jduser,res.jddan,res.jdop,xtra];
  const msg= t.join('\t')+LF;
  try {
    await fsp.appendFile(logpath, msg);
  } catch (err) {
    console.error('Error writing to log file:', err);
  }
}

function getupdata(){
  let s = fs.readFileSync(upfile).toString();
  uptable = s.split('\n').map(row => row.split(':'));
  users= uptable.map(row => row[0]);
 }

getupdata(); // when started and when run after upfile is changed

// interval to check for requests that have timed out
const iid= setInterval(() => {timeouts()},inttimeout);
iid.unref(); // do not prevent shutdown

// p is binary buffer from jd server
function reply(code,res,p)
{
  if('runrepupdate'==res.jdpost) return;

  if(-1!=res.jdport)reps[jports.indexOf(res.jdport)].jdcnt+=1; // count sock ops

  if(res.jdcookiereq!=res.jdcookie)
    res.writeHead(code, "OK", {'Set-Cookie':"jds_cookie="+res.jdcookie+";path=/;Secure;Httponly",'Content-Type': 'text/html'});
  else
    res.writeHead(code, "OK", {'Content-Type': 'application/octet-stream'});
  res.end(p); // post reply
}

function nodecmd(req,res){
  let i= req.post.lastIndexOf('\n');
  //let a= req.post.slice(0,i).toString();
  //req.post= req.post.slice(i+1);

  let a= req.post.slice(i+1).toString();
  req.post= req.post.slice(0,i);

  // logon dan user pswd;logoff;op n
  res.jdop= '';
  res.jdxtra= '';
  res.jdport= -1;
  res.jdlogoff= 0;
  a= a.split(';');
  for(const b of a){
    switch(b.split(' ')[0]){
      case '': break;
      case 'logon' : logon(res,b); break;
      case 'logoff': res.jdlogoff= 1;break;
      case 'free'  : res.jdlogoff= 1;break; // free does logoff and then curl cleanup and codestroy
      case 'eok'   : break;
      case 'port'  : res.jdport= parseInt(b.slice(5));
                     if(-1==jports.indexOf(res.jdport)){reply(200,res,'{"Jd error":"node port bad"}');return 1;}
      case 'op'    : res.jdopstring= b.slice(3); res.jdop= res.jdopstring.split(' ')[0]; break; // read ops choose rep ports
      default:       reply(200,res,'{"Jd error":"node command unknown"}');return 1;
    }
  }  
 return 0; 
}

// check user/pswd against upfile
// res.jdcookie set to '' if invalid or new cookie for session
function logon(res,str){
  res.jdcookie= ''; // assume logon fails
  const bdnames= str.split(' '); // logon dan user pswd
  res.jduser= bdnames[2];
  res.jddan= bdnames[1];
  let i= users.indexOf(res.jduser);
  if(i==-1){logit(res,'onx');return;}
  var t= crypto.createHash('sha3-256').update(bdnames[3]+uptable[i][1]).digest('hex');
  if(t!=uptable[i][2])return;
  res.jdcookie= crypto.randomUUID(); // cookie for new logon
  res.jdlogcnt= logcnt;
  ductable.push([bdnames[1],bdnames[2],res.jdcookie,logcnt++]); // add dan,user,uuid,logcnt to ductable
  logit(res,'on')
}

function doitadmin(req,res){
  res.writeHead(200, "OK", {'Content-Type': 'text/html'}); // ,'Content-Disposition': 'attachment'
  if(req.method == 'POST')
  {
    res.end('admin post not supported'); // get reply
  }

  // get
  var s= decodeURIComponent(req.url);
  switch(s){
   case '/shutdown': shutdown();s= 'shutdown requested'; break;
   default: s= 'unknown admin command'; break;
  }
  res.end(s);
}  

function doit(req,res){
  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      res.jdcookiereq= get_cookies(req)['jds_cookie'];
      res.jdcookie= res.jdcookiereq; // logon can set new value
      res.jdconnection= req.connection.remoteAddress;
      if(nodecmd(req,res)) return; 

      // jdop has been set and jdport is -1 or n
      let readop= -1!=RDOPS.indexOf(res.jdop) || 'rd'==res.jdop.slice(0,2) || 'xrd'==res.jdop.slice(0,3); 
      if( !readop || 1==jports.length) res.jdport= jports[0];

      const cookies= ductable.map(row => row[2]);
      const i= cookies.indexOf(res.jdcookie);
      if(i==-1){logit(res,'on-');reply(200,res,MLOGON);return;}

      // get dan and user from ductable indexed by cookie
      res.jddan= ductable[i][0];
      res.jduser= ductable[i][1];
      res.jdlogcnt= ductable[i][3];

      if(res.jdlogoff){
        ductable.splice(i,1); // remove entry
        logit(res,'off');
      }

      if(0==res.jdop.length){logit(res,'mt');reply(200,res,MOK);return}

      if(stop) {reply(200,res,MSTOP);return} // stop active keep-alive connections

      res.jdpost= Buffer.concat([req.post,Buffer.from('\n'+res.jddan+' '+res.jduser),]); // + dan + user
      res.jdts=  Date.now(); // used to purge old requests that have not been started
      runem(res);
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
   default: s= '';
  }
  res.writeHead(200, "OK", {'Content-Type': 'text/html'}); // ,'Content-Disposition': 'attachment'
  try{ s= fs.readFileSync(s, 'utf8'); }catch(error){ s= ''; }
  res.end(s); // get reply
};

 server_https.keepAliveTimeout=10000;
 
 server_https.listen(nport, bind, () => {console.log(`https started at https://${bind}:${nport}/`);});

 server_admin.listen(2 + +nport,'127.0.0.1',() => {console.log(`admin started at http://${bind}:${2 + +nport}/`);});

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

// run res on port set in res.jdport
async function run(res) {
  const release = await mutexes[jports.indexOf(res.jdport)].acquire();
  try{ 
    var p;
    try{
      logit(res,'jd');
      var jdi= jports.indexOf(res.jdport);
      var sock= socks[jdi];
      jts[jdi]=  Date.now(); // time when sent to jd
      jres[jdi]= res;        // res for the jd request
      jready[jdi]= 1;        // port busy

      //logit(res,'jda',jdi+' '+jready[jdi]);

      await sock.send([res.jdpost.length.toString(),res.jdpost]);
      [p] = await sock.receive();
      jready[jdi]= 0; // port is ready

      //logit(res,'jdz',jdi+' '+jready[jdi]);

      setTimeout(() =>{runem()},0);

    } catch (error) {
      p= '{"Jd error":"zmq - '+error.message+'"}';
      logit(res,'zmq',error.message);
    }
    reply(200,res,p);
  } finally {
   release();
  }
}

var trigger= reptrigger; 

// runem is synchronous - no mutex or await
function runem(res){  
  if(res!=null){logit(res,'q');jobq.push(res);}
  var i,j;
  for (i = 0; i < jlen; i++){
    if(0==jobq.length) break;

    // if this mutex is locked then it will do a runem when it is released
    if(mutexes[i].isLocked()) continue;

    // look for res that can run on this port
    for (j = 0; j < jobq.length; j++){
      let t= jobq[j];
      if(jports[i]==t.jdport || (-1==t.jdport && i>0)){
        jobq.splice(j,1);
        t.jdport= jports[i];
        run(t);
      }
    }
  }


  // repupdate for clones that are idle
  if(reps[0].jdcnt>trigger){
    trigger+= reptrigger;
    for (i = 1; i < jlen; i++){
      if(mutexes[i].isLocked()) continue;
      t= reps[i];
      t.jdop= 'runrepupdate';
      t.jdpost= 'runrepupdate';
      t.jdport= jports[i];
      run(t);
    }
  }

}

// timeout reply to those on jobq too long
// timeout is not done for jd op - this helps graceful shutdown
function timeouts(){
  // reply if on jobq too long
  for (let i = 0; i < jobq.length; i++){
    let ts=  Date.now();
    let res= jobq[i];
    if(jqtimeout<(ts-res.jdts)){
      // remove from q and provide response
      jobq.splice(i,1);
      reply(200,res,MPORT);
    }
  }
  
  /*
  // reply if in jd too long
  for(let i=0; i<jlen;i++){
    let ts= Date.now();
    if(!mutexes[i].isLocked()) continue;

    // busy port - how long has it been busy
    if(jdtimeout<(ts-jts[i]) && 0!=jts[i]){
      jts[i]= 0; // do not see this one again
      let res= jres[i];
      reply(200,res,jdwait);
    }
  }
  */  
}

var stop= 0;

// called by server_http/localhost get shutdown
// stop - graceful shutdown request
// node task will terminate when there is nothing to do
// jobq requests will all complete before node goes idle and terminates
// jds  requests will all complete before jobq requests complete
// changes must be coordinated with jdserver'... stop'
function shutdown(signal) {
  if(!stop){
    stop= 1;
    console.log("stop request");
    server_https.close(() => {
      let t= 'stop status: '+(+(0==jobq.length));
      for(let i=0; i<jlen;i++) t+= ' '+(+!mutexes[i].isLocked());
      console.log(t);
      console.log('stop node exit');
      // can console.log message be lot on exit?
      process.exit(0);
    });

    server_https.closeIdleConnections(); // stop idle keep-alive requests - active keep-alive keep running

    for (let i = 0; i < jobq.length; i++){
      let res= jobq[i];
      jobq.splice(i,1);
      reply(200,res,MSTOP);
    }
  
  }
}

