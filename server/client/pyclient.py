# python3 client and req for jd server

from pathlib import Path
import os,shutil,subprocess,lz4.frame,json

def mkdirunique(path,name):
 path= str(Path(path).resolve())
 Path(path).mkdir(parents=True,exist_ok=True)
 c= 0
 p= path+os.sep+name
 while 1:
  c= c+1
  if 100<c:
    raise Exception('too many folders')
  try:
   Path(path).mkdir(exist_ok=False)
   break
  except:
   path= p+'-'+str(c)
 return path

# codepath,clientpath,id,host,port
# returns path to client files that is arg to req
def client(codepath,folderpath,id,host,port):
 path=mkdirunique(folderpath,id)
 # path= str(Path(folderpath+os.sep+id).resolve())
 Path(path).mkdir(parents=True,exist_ok=True)
 fwrite(path+os.sep+'jdclass','w','jdclient')
 cert= '-k' if 'localhost'==host else ''
 hostpath= path

 d= fread(codepath+os.sep+'curl','r')
 d= d.replace('$1',hostpath)
 d= d.replace('$2',host+':'+port)
 d= d.replace('$3',cert)
 if('\\'==os.sep):
  fwrite(hostpath+os.sep+'curl.bat','w',d)
 else:
  fwrite(hostpath+os.sep+'curl','w',d)
 
 return hostpath

def fread(p,mode):
 f= open(p,mode)
 r= f.read()
 f.close()
 return r

def fwrite(p,mode,d):
 f= open(p,mode)
 f.write(d)
 f.close()

def req(hostpath,a):
 fwrite(hostpath+os.sep+'post','wb',lz4.frame.compress(a.encode('utf-8')))
 
 try:
  e= 0
  if('\\'==os.sep):
   r= subprocess.run([hostpath+os.sep+'curl.bat'],stdout=subprocess.DEVNULL,check=True) # r avoids CompleteProcess msg
  else: 
   subprocess.run([fread(hostpath+os.sep+'curl','r')],shell=True,check=True)
   
 except:
  e= 1

 if e:
  raise Exception(fread(hostpath+os.sep+'stderr','r'))

 r= fread(hostpath+os.sep+'result','rb')

 if('logoff'==a):
  shutil.rmtree(hostpath)
  
 if r[0] == 123: # {
  return json.loads(r.decode('utf-8'))
 else:
  r= lz4.frame.decompress(r)
  return json.loads(r.decode('utf-8'))
