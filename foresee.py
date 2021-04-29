import sys
import time
import os


specs = {'AT1': 'alw_[0,30](not (gear[t]==4) or (speed[t]>35))', 'AT2': 'alw_[0,30](not (gear[t] == 4) or (ev_[0,5](RPM[t] < 4300)))', 'AT3': 'alw_[0,30](speed[t] < 130) and alw_[0,30](gear[t] < 5)', 'AT4':'alw_[0,30](speed[t] < 135 and RPM[t] < 4780)', 'AT5': 'alw_[0,30](ev_[0,10](not(gear[t] == 1)) or RPM[t] > 600)', 'AT6': 'alw_[0,30](ev_[0,5](speed[t] < 120 or RPM[t] > 3500))', 'AT7': 'alw_[0,30](RPM[t] < 4750) and alw_[0,30](gear[t] < 5)', 'AT8': 'alw_[0,10](speed[t]<50) or ev_[0,30](RPM[t] > 2520)', 'AT9': 'ev_[10,30](speed[t] < 50 or speed[t] > 60 or RPM[t] < 1000)', 'AT10': 'alw_[0,30](not(gear[t] == 4) or (speed[t] >= 35 and ev_[0,5](RPM[t] < 4000)))', 'AT11': 'alw_[0,30](ev_[0,8](not(gear[t] == 1) or (speed[t] < 20 and RPM[t] < 600)))', 'AT12': 'alw_[0,30]((speed[t]<135) and (RPM[t]<4780)) or alw_[0,30](gear[t] < 3)', 'AT13': 'alw_[0,30](not (gear[t] == 4) or (ev_[0,5](RPM[t] < 4000))) and alw_[0,30](gear[t] < 5)', 'AT14': 'not(alw_[0,30](throttle[t] == 0 or brake[t] == 0)) or (alw_[0,30](speed[t] < 110))', 'AT15': 'alw_[0,30]((RPM[t] < 4770 or alw_[0,1](RPM[t] > 1000)) and ev_[0,5](gear[t] < 5))', 'AT16': 'alw_[0,30](not(gear[t] == 4) or (ev_[0,5](RPM[t] < 3000) and (not(gear[t] == 2) or speed[t] < 20)))', 'AT17': 'alw_[0,5](speed[t]< 70 and gear[t] < 4) and alw_[10,20](RPM[t] < 4780) and alw_[25,30](speed[t] < 130)', 'AT18': 'alw_[0,30]((not(gear[t] == 4) or (ev_[0,5](RPM[t] < 4250))) and (not(gear[t] == 3) or ev_[0,5](RPM[t] < 4700)) and (not(gear[t] == 2) or ev_[0,5](RPM[t]< 4800)))', 'AT19': 'alw_[0,30]((not(gear[t] == 1) or (speed[t] < 80)) and (not(gear[t] == 2) or (speed[t] < 90)) and (not(gear[t] == 3) or speed[t] > 20) and (not(gear[t] == 4) or speed[t] > 30))', 'AT20': '(alw_[0,29](speed[t]<100) or alw_[29,30](speed[t]>64)) and (alw_[0,30](RPM[t] < 4770 or alw_[0,1](RPM[t] > 700)))', 'AT21': 'not(alw_[0,30](not (throttle[t] > 90) or ev_[0,10](throttle[t] < 30))) or (alw_[0,30]((gear[t] == 4) => (ev_[0,5](RPM[t] < 4000))))', 'AT22': 'not(alw_[0,30](not (throttle[t] > 70) or ev_[0,10](brake[t] > 50))) or (alw_[0,30](not(gear[t] == 4) or (speed[t] >= 35)))', 'AFC1': 'alw_[11,50](not(controller_mode[t] == 1) or (mu[t] < 0.228))', 'AFC2':'alw_[0,50](Pedal_Angle[t] < 40) or (alw_[11,50](mu[t] < 0.225))', 'AFC3': 'alw_[0,50](Engine_Speed[t] < 1000) or (alw_[11,50](mu[t] < 0.225))', 'AFC4': 'ev_[0,50](Engine_Speed[t] < 910 and Pedal_Angle[t] < 25) or (alw_[11,50](mu[t] < 0.225))', 'AFC5': 'alw_[0,50](Pedal_Angle[t] < 40) or (alw_[11,50](ev_[0,8](mu[t] < 0.06)))', 'AFC6': 'alw_[0,50](Pedal_Angle[t] < 40 or Engine_Speed[t] < 1000) or (alw_[11,50](ev_[0,8](mu[t] < 0.06)))', 'FFR1': 'not(alw_[0,5](((u1[t]>0 and u3[t]>0) or (u1[t]<0 and u3[t]<0)) and ((u2[t]>0 and u4[t]>0) or (u2[t]<0 and u4[t]<0)))) or alw_[0,5](not(x1[t]>3.9 and x1[t]<4.1) and not(x3[t]>3.9 and x3[t]<4.1))', 'FFR2': 'not(ev_[0,5](alw_[0,2](x1[t] > 1.5 and x1[t] < 1.7 and x3[t]> 1.5 and x3[t] < 1.7 )))'}

def conf_gen(home, rq, time_str, specID, algo, trials, c = 0.2, bp = 10):
	spec = ''
	model = ''

	conf_file = home + '/test/conf/' + specID + time_str
	if rq == 1:
		spec = specs[specID]
		if specID.startswith('AT'):
			model = 'Autotrans_shift'
			basic_file = home + '/test/conf/AT_basic'
		elif specID.startswith('AFC'):
			model = 'fuel_control'
			basic_file = home + '/test/conf/AFC_basic'
		elif specID.startswith('FFR'):
			model = 'free_floating_robot'
			basic_file = home + '/test/conf/FFR_basic'
	elif rq == 2:
		pass
	elif rq == 3:
		pass
	
	with open(basic_file, 'r') as conf_basic:
		lines = conf_basic.readlines()
		with open(conf_file, 'w') as conf:
			conf.write('model 1\n')
			conf.write(model + '\n')
			conf.write('phi 1\n')
			conf.write(specID + ' ' + spec + '\n')
			conf.write('trials 1\n')
			conf.write(str(trials) + '\n')
			conf.write('addpath 1\n')
			conf.write(home + '\n')
			if algo == 'foresee':
				conf.write('scalar 1\n')
				conf.write(c + '\n')
				conf.write('budget_p 1\n')
				conf.write(bp + '\n')
			conf.write('\n'.join(lines))

	if algo == 'foresee':
		os.system('python3 foresee_gen.py ' + conf_file)
	elif algo == 'breach':
		os.system('python3 breach_gen.py ' + conf_file)
	os.system('chmod 777 ' + home + '/test/benchmarks/*')

	os.system('make')

	res_file = 'results/' + model + '_' + algo +'_' +  specID +  '.csv'
	res_out = res_file.replace('.csv', '_summary.csv')
	fal = 0
	time = 0.0
	with open(res_out, 'w') as resout:
		with open(res_file, 'r') as res:
			status = 0
			row = ''
			lines = res.readlines()
			f.write(lines[0].strip()+'\n')
			for line in lines[1:]:
				data = line.strip().split(';')
				status = status + 1
				fal = fal + int(data[2])
				time = (time + float(data[3])) if int(data[2])==1 else time
				if status == trials:
					status = 0
					time = (time/fal) if fal != 0 else -1
					row = ';'.join(data[0:2]) + ';'+str(fal)+';'+str(time)
					f.write(row+'\n')
					fal = 0
					time = 0
	print('-------------------------------\n')	
	print('falsification success rate: ' + str(fal) + '\n')
	print('average time cost: ' + str(time) + '\n')

if __name__ == "__main__":
	home = os.getcwd()
	curr_time = time.time()
	ts = time.strftime('%Y%m%d%H%M%S',time.localtime(curr_time))

	if sys.argv[1] == 'RQ1':
		while True:
			print('-------------------------------\n')
			print('Please select a specification ID,\nfrom \'AT[1-22]\', \'AFC[1-6]\', \'FFR[1-2]\':')
			print('e.g., AT3')
			print('-------------------------------\n')
			specID = input()
			if (specID.startswith('AT') and int(specID[2:]) <= 22) or (specID.startswith('AFC') and int(specID[3:])<= 6) or (specID.startswith('FFR') and int(specID[3:]) <=2 ):
				break
			else:
				print('Please try again ...\n')

		while True:
			print('\n\n')
			print('-------------------------------\n')
			print('Please select a falsification algorithm,\nfrom \'breach\' and \'foresee\'\n e.g., foresee')
			print('-------------------------------\n')
			algo = input()
			if algo == 'breach' or algo == 'foresee':
				break
			else:
				print('Please try again ...\n')

		print('\n\n')
		print('-------------------------------\n')
		print('Please specify the number of trials,\ne.g., 10')
		trials = int(input())
		conf_gen(home, 1, ts,  specID, algo, trials)
	elif sys.argv[1] == 'RQ2':
		print('-------------------------------\n')
		print('Please select a specificatio ID,\nfrom \'AT[1-22]\', \'AFC[1-6]]\', \'FFR[1-2]\':\n')
		print('e.g., AT3\n')
		specID = input()
		print('-------------------------------\n')
		print('Please select a falsification algorithm,\nfrom \'breach\' and \'foresee\'\n e.g., foresee')
		algo = input()
		print('-------------------------------\n')
		print('Please specify the number of trials,\n e.g., 10')
		trials = int(input())
		conf_gen(specID, algo, trials)
	elif sys.argv[1] == 'RQ3':
		print('-------------------------------\n')
		print('Please select a specificatio ID,\n from \'AT[1-22]\', \'AFC[1-6]]\', \'FFR[1-2]\':\n')
		print('e.g., AT3\n')
		specID = input()
		print('-------------------------------\n')
		print('Please select a falsification algorithm,\n from \'breach\' and \'foresee\'\n e.g., foresee')
		algo = input()
		print('-------------------------------\n')
		print('Please specify the number of trials,\n e.g., 10')
		trials = int(input())
		conf_gen()
	else:
		print('Please try again')
