# $ python3 -i jdtest.py codepath jdclientpath id host port
import sys
from importlib import reload # allow reload(jd) if src is changed
sys.path.append(sys.argv[1])
import pyclient as jd
#         codepath    folderpath  host       port         dan
jdp1= jd.client(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5])
print(jd.req(jdp1,'logon simple user0 pswd0'))
print(jd.req(jdp1,'["insert t","a",123,"byte","777"]'))
print(jd.req(jdp1,'read from t'))
print(jd.req(jdp1,'info summary'))
print(jd.req(jdp1,'\"info summary\"'))
print(jd.req(jdp1,'info schema'))
print(jd.req(jdp1,'logon simple xxx xxx'))
print(jd.req(jdp1,'info schema'))

