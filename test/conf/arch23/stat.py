#first argument: path where csv file are in
#

import sys
import os
import numpy

testpath = sys.argv[1]

sims = []

fr = 0
mean = 0.0
median = 0
simratio = 0.0
time = 0.0
sim_time = 0.0
fn = ''

with open(testpath,'r') as f:
	linenum = 0
	lines = f.readlines()
	for line in lines[1:]:
		data = line.strip()
		datas = data.split(';')
		fn = datas[0]
		fr = fr + int(datas[2])
		sims.append(float(datas[4]))
		time = time + float(datas[3])
		sim_time = sim_time + float(datas[6])
mean = numpy.mean(sims)
median = numpy.median(sims)
simratio = (sim_time/time)*100.0

print(fn + ':' + str(fr) + ' ' + str(mean) + ' ' + str(median) +' '  +  str(simratio))
