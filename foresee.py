import sys

def conf_gen():

def bench_gen():

def make():
	

if __name__ == "__main__":
	if sys.argv[1] == 'RQ1':
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
		conf_gen(specID, algo, trials)
		bench_gen()
		make()
	else if sys.argv[1] == 'RQ2':
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
		conf_gen(specID, algo, trials)
		bench_gen()
		make()
	else if sys.argv[1] == 'RQ3':
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
		conf_gen(specID, algo, trials)
		bench_gen()
		make()
	else
		print('Please try again')
