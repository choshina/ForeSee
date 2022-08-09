import sys
import platform
import glob

matlab = ''
osys = platform.system()
if osys == 'Linux':
	mpaths = glob.glob('/usr/local/MATLAB/*/bin/')
	mpaths.sort()
	matlab = mpaths[-1] + '/matlab'
elif osys == 'Darwin':
	mpaths = glob.glob('/Applications/MATLAB*/bin/')
	mpaths.sort()
	matlab = mpaths[-1] + '/matlab'


model = ''
algorithm = '' 
optimization = []
phi_str = []
controlpoints = []
input_name = []
input_range = []
parameters = []
timespan = ''
loadfile = ''

status = 0
arg = ''
linenum = 0

budget_p = 0
scalar = 0

algopath = ''
trials = ''
timeout = ''
max_sim = ''
addpath = []

with open(sys.argv[1],'r') as conf:
	for line in conf.readlines():
		argu = line.strip().split()
		if status == 0:
			status = 1
			arg = argu[0]
			linenum = int(argu[1])
		elif status == 1:
			linenum = linenum - 1
			if arg == 'model':
				model = argu[0]

			elif arg == 'optimization':
				optimization.append(argu[0])
			elif arg == 'phi':
				complete_phi = argu[0]+';'+argu[1]
				for a in argu[2:]:
					complete_phi = complete_phi + ' '+ a
				phi_str.append(complete_phi)
			elif arg == 'controlpoints':
				controlpoints.append(int(argu[0]))
			elif arg == 'input_name':
				input_name.append(argu[0])
			elif arg == 'input_range':
				input_range.append([float(argu[0]),float(argu[1])])
			elif arg == 'parameters':
				parameters.append(argu[0])	
			elif arg == 'timespan':
				timespan = argu[0]
			elif arg == 'trials':
				trials = argu[0]
			elif arg == 'timeout':
				timeout = argu[0]
			elif arg == 'max_sim':
				max_sim  = argu[0]
			elif arg == 'addpath':
				addpath.append(argu[0])
			elif arg == 'loadfile':
				loadfile = argu[0]
			elif arg == 'budget_p':
				budget_p = int(argu[0])
			elif arg == 'scalar':
				scalar = float(argu[0])
			else:
				continue
			if linenum == 0:
				status = 0


for ph in phi_str:
	for cp in controlpoints:
		for opt in optimization:
			property = ph.split(';')
			filename = model+ '_foresee_' + property[0] + '_' + str(cp)
			param = '\n'.join(parameters)
			with open('benchmarks/'+filename,'w') as bm:
				bm.write('#!/bin/sh\n')
				bm.write('csv=$1\n')
				bm.write(matlab + ' -nodesktop -nosplash <<EOF\n')
				bm.write('clear;\n')
				for ap in addpath:
					bm.write('addpath(genpath(\'' + ap + '\'));\n')
				if loadfile!= '':
					bm.write('load ' + loadfile + '\n')
				bm.write('InitBreach;\n\n')
				bm.write(param + '\n')
				bm.write('mdl = \''+ model + '\';\n')
				bm.write('Br = BreachSimulinkSystem(mdl);\n')
				bm.write('budget_t = ' + str(timeout) + ';\n')
				bm.write('scalar = ' + str(scalar) + ';\n')
				bm.write('controlpoints = ' + str(cp) + ';\n')
				bm.write('budget_p = ' + str(budget_p) + ';\n')
				bm.write('input_name = {\'' + input_name[0] + '\'')
				for iname in input_name[1:]:
					bm.write(',')
					bm.write('\'' + iname + '\'')
				bm.write('};\n')

				bm.write('input_range = [[' + str(input_range[0][0]) + ' ' + str(input_range[0][1]) + ']')
				for ir in input_range[1:]:
					bm.write(';[' + str(ir[0]) + ' ' + str(ir[1]) + ']')
				bm.write('];\n')

				bm.write('spec = \''+ property[1]+'\';\n')
				bm.write('phi = STL_Formula(\'phi\',spec);\n')
				bm.write('T = ' + timespan + ';\n')
		
				bm.write('trials = ' + trials + ';\n')	
				bm.write('filename = \''+filename+'\';\n')
				bm.write('falsified = [];\n')
				bm.write('time = [];\n')
				bm.write('num_sim = [];\n')
				bm.write('sim_cost = [];\n')

				#for arch, x_best, obj_best, num_sim
				bm.write('x_bests = [];\n')
				bm.write('obj_bests = [];\n')

				bm.write('global simm\n')
				bm.write('global sim_time\n')
				bm.write('for n = 1:trials\n')
				bm.write('\tsimm = 0;\n')
				bm.write('\tsim_time = 0;\n')
				bm.write('\tm = mcts(phi, mdl, budget_t, budget_p, controlpoints, input_name, input_range, T, scalar);\n')
				bm.write('\tfalsified = [falsified; m.falsified];\n')
				bm.write('\tnum_sim = [num_sim;simm];\n')
				bm.write('\ttime = [time;m.time_cost];\n')
				bm.write('\tsim_cost = [sim_cost; sim_time;\n]')

				#for arch
				bm.write('\tx_bests = [x_bests; m.root.x_best\'];\n')
				bm.write('\tobj_bests = [obj_bests; m.root.obj_best];\n')
	
				bm.write('end\n')

				bm.write('scalars = ones(trials, 1)*scalar;\n')
				bm.write('budget_ps = ones(trials, 1)*budget_p;\n')
				bm.write('spec = {spec')
				n_trials = int(trials)
				for j in range(1,n_trials):
					bm.write(';spec')
				bm.write('};\n')

				bm.write('filename = {filename')
				for j in range(1,n_trials):
					bm.write(';filename')
				bm.write('};\n')

				bm.write('result = table(filename, spec, falsified, time, num_sim, obj_bests, sim_cost, x_bests);\n')
				bm.write('writetable(result,\'$csv\',\'Delimiter\',\';\');\n')
				bm.write('quit force\n')
				bm.write('EOF\n')
				bm.write('rm *.mat\n')
