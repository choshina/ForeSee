#first argument: path where csv files are in
#second argument: name of the new csv file
#

import sys
import os

def listdir(path):
	L = []     
	for file in os.listdir(path):  
		if os.path.splitext(file)[1] == '.csv':
			L.append(file)
	return L  

testpath = sys.argv[1]
newfile = sys.argv[2]
list_name = listdir(testpath)
list_name.sort()

with open(newfile,'a') as f:
	head = open(testpath+'/'+list_name[0],'r').readlines()[0].strip()
	f.write(head)	
	f.write('\n')
	for tb in list_name[0:]:
		with open(testpath + '/' + tb,'r') as ftb:
			linenum = 0
			for line in ftb.readlines():
				if linenum == 0:
					linenum = 1
				else:
					data = line.strip()
					f.write(data)
					f.write('\n')
