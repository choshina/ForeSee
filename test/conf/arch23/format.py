#arg1: config file
#arg2: csv file

import sys
import csv

system = ''
T = 0
cp = 0
Tu = 0
form = ''

sort_str = ''
sorts = []

with open(sys.argv[1], 'r') as conf:
	lines = conf.readlines()
	system = lines[0].strip()
	T = float(lines[1])
	cp = int(lines[2])
	sort_str = lines[3].strip()
	Tu = T/cp
	form = lines[4].strip()

	for st in sort_str.split(' '):
		sorts.append(int(st))

with open(sys.argv[2], 'r') as res:
	with open(sys.argv[2].replace('.csv', '_.csv'), 'w') as out:
		header = ["system", "property", "simulations", "time", "robustness", "falsified", "input"]
		outcsv = csv.writer(out, quoting=csv.QUOTE_NONNUMERIC)
		outcsv.writerow(header)

		outrows = []
		resr = csv.reader(res, delimiter=';')
		for r in resr:
			if r[0] == 'filename':
				continue

			print(r)
			outrow = []
			outrow.append(system)

			files = r[0].split('_')
			prop = files[-2]
			if prop == 'afc27':
				prop = '(AFC27 0.008)'
			if prop == 'afc29':
				prop = '(AFC29 0.007)'
			if prop == 'afc33':
				prop = '(AFC33 0.007)'
			if prop == 'nn1':
				prop = '(NN 0.005 0.03)'
			if prop.startswith('car'):
				prop.replace('car', 'CC')
			if prop.startswith('steam'):
				prop = 'SCa'
			outrow.append(prop)

			sims = int(r[4])
			outrow.append(sims)

			time = float(r[3])
			outrow.append(time)

			rob = float(r[5])
			outrow.append(rob)

			falsified = "yes" if int(r[2]) == 1 else "no"
			outrow.append(falsified)

			
			inputs = '['
			for i in range(cp):
				inputs = inputs + str(i*Tu) + ' '
				for k in sorts:
					inputs = inputs + r[7 + i + (k-1)*cp] + ' '
				inputs = inputs + ';'
				if form == 'pwc': #piecewise constant
					inputs = inputs + str((i+1)*Tu-0.1) + ' '
					for k in sorts:
						inputs = inputs + r[7 + i + (k-1)*cp] + ' '
					inputs = inputs + ';'
			inputs = inputs + str(T) + ' '
			for k in sorts:
				inputs = inputs + r[7 + cp - 1 + (k-1)*cp] + ' '
			inputs = inputs + ']'
			outrow.append(inputs)

			outcsv.writerow(outrow)
