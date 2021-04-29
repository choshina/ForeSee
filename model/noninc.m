

clear;
%addpath /home/zhenya/falsification/falsification/src/test/simulink
%addpath /Users/zhenya/git/falsification/src/test/matlab/MCTS/optchild/opt/'oneopttree_20180307-3-Input-Values-Synthesized-Non-incrementally-biased- expansion'/
InitBreach;


mdl = 'free_floating_robot';
Br = BreachSimulinkSystem(mdl);
br = Br.copy();
N_max =40;
scalar = 0.2;
phi_str = 'not ev_[0,5](x1[t]>3.9 and x1[t]<4.1 and x2[t]>-1 and x2[t]<1 and x3[t]>3.9 and x3[t]<4.1 and x4[t]>-1 and x4[t]<1)';
phi = STL_Formula('phi1',phi_str);
T = 5;
controlpoints = 5;
hill_climbing_by = 'global_nelder_mead';
T_playout = 5;
input_name = {'u1','u2','u3','u4'};
input_range = [[-10.0 10.0];[-10.0 10.0];[-10.0 10.0];[-10.0 10.0]];
partitions = [2 2 2 2];
filename = '20180307_1_Input-Values_Synthesized_Non_incrementally_Strap_5_0.2_2_2_2_2_40_global_nelder_mead_5';
algorithm = '20180307_1_Input-Values_Synthesized_Non_incrementally';
falsified_at_all = [];
total_time = [];
falsified_in_preprocessing = [];
time_for_preprocessing = [];
falsified_after_preprocessing = [];
time_for_postpreprocessing = [];
trials = 10;
for i = 1:trials
	 tic
	 m = MCTS(br, N_max, scalar, phi, T, controlpoints, hill_climbing_by, T_playout, input_name, input_range, partitions);
	 falsified_in_preprocessing = [falsified_in_preprocessing; m.falsified];
	 time = toc;
	 time_for_preprocessing = [time_for_preprocessing; time];
	 if m.falsified == 0
		 BR = Br.copy();
		 BR.Sys.tspan = 0:.01:5;
		 input_gen.type = 'UniStep';
		 input_gen.cp = controlpoints;
		 BR.SetInputGen(input_gen);
		 range = m.best_children_range;
		 r = numel(range);
		 for cpi = 1:controlpoints
			 for k = 1:numel(input_name)
				 sig_name = strcat(input_name(k), '_u', num2str(cpi-1));
				 if cpi <= r
					 BR.SetParamRanges({sig_name},range(cpi).get_signal(k));
				 else
					 BR.SetParamRanges({sig_name},input_range(k,:));
				 end
			 end
		 end
		 falsif_pb = FalsificationProblem(BR, phi);
		 falsif_pb.max_time = 300;
		 falsif_pb.setup_solver('cmaes');
		 falsif_pb.solve();
		 if falsif_pb.obj_best < 0
			 time_for_postpreprocessing = [time_for_postpreprocessing; falsif_pb.time_spent];
			 falsified_after_preprocessing = [falsified_after_preprocessing; 1];
		 else
			 time_for_postpreprocessing = [time_for_postpreprocessing; falsif_pb.time_spent];
			 falsified_after_preprocessing = [falsified_after_preprocessing;0];
		 end
	 else
		 falsified_after_preprocessing = [falsified_after_preprocessing; 1];
		 time_for_postpreprocessing = [time_for_postpreprocessing; 0];
	 end
end
falsified_at_all = falsified_after_preprocessing;
total_time = time_for_preprocessing + time_for_postpreprocessing;
phi_str = {phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str};
algorithm = {algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm};
hill_climbing_by = {hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by};
filename = {filename;filename;filename;filename;filename;filename;filename;filename;filename;filename};
controlpoints = controlpoints*ones(trials,1);
scalar = scalar*ones(trials,1);
partitions = [partitions(1)*ones(trials,1) partitions(2)*ones(trials,1)];
T_playout = T_playout*ones(trials,1);
N_max = N_max*ones(trials,1);
result = table(filename, phi_str, algorithm, hill_climbing_by, controlpoints, scalar, partitions, T_playout, N_max, falsified_at_all, total_time, falsified_in_preprocessing, time_for_preprocessing, falsified_after_preprocessing, time_for_postpreprocessing);
writetable(result,'$csv','Delimiter',';');

